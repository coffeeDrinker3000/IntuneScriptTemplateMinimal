# IntuneScriptTemplateMinimal
Template for scripting for Intune

Functions:

AddLog

-Message (string)
Add a single string to add to the log file.

-Level (int 1-3)
Set the log level 1 = Information, 2 = Warning, 3 = Error. Default is: 1

-ExceptionObject <System.Management.Automation.ErrorRecord>
Include information from an error by using try-catch. Includes the error message and category.

-Terminate (switch)
Terminate the script, to report issues with the script itself. Don't use in a try block.

ExitScript

-Code (int)
Exit the script by using a specific code or the variable $exitCode if not specified. Default: 65000 -> will use the variable.
