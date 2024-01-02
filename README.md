# IntuneScriptTemplateMinimal
Template for scripting for Intune
> [!NOTE]
> This script sends all log messages back to Intune that can be read in remediations detection.

## Functions

### AddLog
This function provides you with the option to easily include log information when running the script.

__Parameters__ <br />
`-Message` _(string)_ <br />
Add a single string to add to the log file.

`-Level` _(int <1-3>)_ <br />
Set the log level 1 = Information, 2 = Warning, 3 = Error. Default is: 1

> [!WARNING]
> The parameter `-ExceptionObject` is outdated an can no longer be used. Use `-UseLastError` instead.

`-ExceptionObject` _<System.Management.Automation.ErrorRecord>_ <br />
Include information from an error by using try-catch. Includes the error message and category.

`-UseLastError` _(switch)_ <br />
Use the last global error to include more error infos.

`-Terminate` _(switch)_ <br />
Terminate the script, to report issues with the script itself. Don't use in a try block.

### ExitScript
This function provides you with the option to easily exit the script and still send all infos to Intune.

__Parameters__ <br />
`-Code` _(int)_ <br />
Exit the script by using a specific code or the variable $exitCode if not specified. Default: 65000 -> will use the variable.
