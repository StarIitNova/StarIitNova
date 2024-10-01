@echo off

REM Written by @starlitnova (@Dollor-Lua on github)
REM A simple wrapper for the windows cd command to support
REM listing directories and setting automatic evaluations
REM of certain paths, ex a config with dev=C:\dev will
REM allow for the xcd command to evaluate "xcd dev" as both
REM the current directory (ex in C:\somewhere it checks
REM C:\somewhere\dev) AND the automatic evaluation. So if
REM C:\somewhere\dev doesn't exist, it will evaluate to
REM C:\dev. I wrote this as a utility tool for myself to
REM make it easier to navigate projects while using neovim,
REM but you are free to use this or submit changes to it!

REM LICENSE:

REM Copyright 2024 StarlitNova (Dollor-Lua)
REM Permission is hereby granted, free of charge, to any person
REM obtaining a copy of this software and associated documentation
REM files (the “Software”), to deal in the Software without restriction,
REM including without limitation the rights to use, copy, modify,
REM merge, publish, distribute, sublicense, and/or sell copies of the
REM Software, and to permit persons to whom the Software is
REM furnished to do so, subject to the following conditions:

REM The above copyright notice and this permission notice shall be
REM included in all copies or substantial portions of the Software.

REM THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY
REM OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
REM LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
REM FITNESS FOR A PARTICULAR PURPOSE AND
REM NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
REM COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
REM OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
REM TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
REM CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
REM DEALINGS IN THE SOFTWARE.

set "configFile=%~dp0xcd\xcd_conf.cf"

REM check for the config file
if not exist "%configFile%" (
    echo [xcd] Configuration file "xcd\xcd_conf.cf" not found.
    exit /b
)

set fi_cmdArg=false
if "%1"=="-h" set fi_cmdArg=true
if "%1"=="--help" set fi_cmdArg=true
if "%1"=="" set fi_cmdArg=true
if "%fi_cmdArg%"=="true" (
    echo xcd -- cross change directory -- by @starlitnova
    echo Usage: xcd [directory] [options]
    echo.
    echo Options
    echo     -h, --help         Shows this help menu
    echo     -d, --dirs         Prints all valid directories from the config file
    echo     -l, --list         Lists all files in the current directory
    exit /b
)

set fi_cmdArg=false
if "%1"=="-d" set fi_cmdArg=true
if "%1"=="--dirs" set fi_cmdArg=true
if "%fi_cmdArg%"=="true" (
    REM iterate over the delimeters in the config file
    for /f "tokens=1,2 delims==" %%A in ('type "%configFile%"') do (
        echo %%A ^(-^) %%B
    )
    exit /b
)

set fi_cmdArg=false
if "%1"=="-l" set fi_cmdArg=true
if "%1"=="--list" set fi_cmdArg=true
if "%fi_cmdArg%"=="true" (
    REM list directories first
    for /f "delims=" %%D in ('dir /ad /b') do (
        echo [DIR] %%D
    )

    REM then list files
    for /f "delims=" %%F in ('dir /a-d /b') do (
        REM check if the file is an executable and print it
        set "_fname=%%F"
        call :checkExe "%%F"
    )

    exit /b
)

REM determine if the path is absolute
set "argPath=%~1"

REM convert forward slashes to backslashes
set "argPath=%argPath:/=\%"

REM check if the directory exists
if "%argPath:~1,1%"==":" (
    if exist "%argPath%\" (
        cd "%argPath%"
        exit /b
    )
) else (
    if exist "%cd%\%1" (
        cd "%cd%\%1"
        exit /b
    )
)

REM otherwise, iterate over the config file's directories
for /f "tokens=1,2 delims==" %%A in ('type "%configFile%"') do (
    REM compare the first token to the input
    if "%argPath%"=="%%A" (
        cd "%%B"
        exit /b
    )
)

echo [xcd] The system could not find the path specified.
exit /b

REM function to check  if a file is an executable
:checkExe
setlocal
set "file=%~1"
set "extension=%~x1"

REM check for the common executable extensions
set fi_exec=false
REM TODO: convert to array
if /i "%extension%"==".exe" set fi_exec=true
if /i "%extension%"==".bat" set fi_exec=true
if /i "%extension%"==".cmd" set fi_exec=true
if /i "%extension%"==".com" set fi_exec=true
if /i "%extension%"==".vbs" set fi_exec=true
if /i "%extension%"==".vbe" set fi_exec=true
if "%fi_exec%"=="true" (
    echo ^<EXE^> %file%
) else (
    echo %file%
)
endlocal
