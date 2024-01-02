# Author: <username>
# Last edited: <date>
$ScriptName = "Script Name"
$ScriptVersion = "1.0"
# Updates: 
# Description: <script description>

# script variables
[int]$script:exitCode = 0
[string]$script:intuneMessage = $null
[string]$script:intuneError = $null
$ErrorActionPreference = "Stop"

function AddLog ([string]$Message,[Int]$Level=1,[switch]$UseLastError,[switch]$Terminate) {
    if ($UseLastError) { $errorCatch = $Error[0] }
    if ($IsMacOS) { $path = "/Users/$(id -un)/temp" }
    else { $path = "$($env:SystemRoot)\CCM\Logs" }
    $null = [System.IO.Directory]::CreateDirectory($path)
    $logFile = "$($ScriptName)_$($ScriptVersion).log"
    $fullLogPath = "$(if($IsMacOS){"$path/$logFile"}else{"$path\$logFile"})"
    if (!(Test-Path $fullLogPath)) {
        try { $null = New-Item -Path $fullLogPath -ItemType File -Force }
        catch { throw "Cannot create log file" }
        $initial=$true
        $newF=$true
    }
    if ($Message -clike 'FIRSTRUN') { $initial=$true }
    elseif ($Message -clike 'LASTRUN') { $last=$true }
    if($initial) {
        $initialText = "$(if(!$newF){"`n"})$([System.Environment]::MachineName)`n$(([System.Environment]::OSVersion.Version).ToString())`n$([System.Environment]::UserName)`n$(Get-Date -Format 'yyyy-MM-dd')`n"
        $null = Add-Content -Path $fullLogPath -Value $initialText -Force
        $null = Add-Content -Path $fullLogPath -Value ("{0,-15}{1,-8}{2,-10}" -f "Date","Level","Message") -Force
        $Message = "Beginning script execution $ScriptName $ScriptVersion"
    }
    if ($last) { $Message = "Exiting script with code $exitCode" }
    if ($Level -eq 2) { $levelStr='Warning' }
    elseif ($Level -eq 3) { $levelStr='Error' }
    else { $levelStr='Info' }
    if ($UseLastError) {
        $Message = "$Message -> $($errorCatch.Exception.Message) - $($errorCatch.CategoryInfo.Category)"
        if ($Level -eq 1) { $levelStr='Error' }
    }
    $null = Add-Content -Path $fullLogPath -Value ("{0,-15}{1,-8}{2}" -f "$(Get-Date -Format 'HH:mm:ss:ffff')","$levelStr","$Message") -Force
    if ($last -or $Terminate) { 
        Write-Output "$intuneMessage $Message"
        if ($intuneError -notlike $null) { Write-Error "$intuneError" }
        if ($Terminate) { throw $Message }
    }
    else { $script:intuneMessage += "$Message - " }
}

function ExitScript ([int]$Code=65000) {
    if (!$Code -eq 65000) { $script:exitCode = $Code }
    AddLog "LASTRUN"
    exit($exitCode)
}

# begin script
AddLog "FIRSTRUN"

# --> begin your script here <--

# use AddLog "<string>" to create log information
# use AddLog -Message "<log message>" -Level <1-3> (-ExceptionObject $Error[0]) to add error logs
# $exitCode = 0 -> all fine $exitCode = 1 -> fix required
# use AddLog "<string>" -Terminate to message Intune the script failed (no fix)

# exiting script
ExitScript $exitCode
