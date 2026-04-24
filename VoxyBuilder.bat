@echo off
:: ═══════════════════════════════════════════════════════════════
::            Voxy Builder Tool  |  MC 1.21.1
:: ═══════════════════════════════════════════════════════════════

:: ── ENGINE MODE ─────────────────────────────────────────────────
if "%~1"=="--engine" goto engine_mode
goto ui_start

:engine_mode
setlocal EnableDelayedExpansion
shift
set "TASK_CMD="
:_arg_loop
if "%~1"=="" goto _arg_done
set "TASK_CMD=!TASK_CMD! %~1"
shift
goto _arg_loop
:_arg_done
set "W_JAR=%~dp0gradle\wrapper\gradle-wrapper.jar"
if defined JAVA_HOME (set "JX=%JAVA_HOME%\bin\java.exe") else (set "JX=java")
"!JX!" "-Dorg.gradle.appname=%~nx0" -classpath "!W_JAR!" org.gradle.wrapper.GradleWrapperMain !TASK_CMD!
echo [ENGINE_FINISHED]
exit /b

:: ── UI INITIALIZATION ───────────────────────────────────────────
:ui_start
setlocal EnableDelayedExpansion
pushd "%~dp0"

:: AUTO-SCALE WINDOW
mode con: cols=80 lines=30

for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do set "ESC=%%b"

set "ROOT=%~dp0"
set "SCRIPT=%~f0"
set "LOG=!ROOT!build_log.txt"
set "ERR=!ROOT!ERROR_REPORT.txt"
set "LAST="

reg add "HKCU\Console" /v VirtualTerminalLevel /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Console" /v QuickEdit /t REG_DWORD /d 0 /f >nul 2>&1
chcp 65001 >nul
<nul set /p "=!ESC![?25l"

:: Set Title
title Voxy Builder Tool

if not exist "!ROOT!build.gradle" (
    cls
    echo.
    echo    !ESC![91mERROR: Not a Gradle project folder.!ESC![0m
    echo    Make sure this .bat is in the folder containing build.gradle.
    <nul set /p "=!ESC![?25h"
    pause & exit /b
)

:: ── MENU ────────────────────────────────────────────────────────
:menu
cls
echo.
echo    !ESC![92m██╗   ██╗ ██████╗ ██╗  ██╗██╗   ██╗!ESC![0m
echo    !ESC![92m██║   ██║██╔═══██╗╚██╗██╔╝╚██╗ ██╔╝!ESC![0m
echo    !ESC![92m██║   ██║██║   ██║ ╚███╔╝  ╚████╔╝ !ESC![0m
echo    !ESC![92m╚██╗ ██╔╝██║   ██║ ██╔██╗   ╚██╔╝  !ESC![0m !ESC![37mBuilder Tool!ESC![0m
echo    !ESC![92m ╚████╔╝ ╚██████╔╝██╔╝ ██╗   ██║   !ESC![0m !ESC![37mMC 1.21.1!ESC![0m
echo    !ESC![92m  ╚═══╝   ╚═════╝ ╚═╝  ╚═╝   ╚═╝   !ESC![0m 
echo.
echo    !ESC![37m──────────────────────────────────────────────────────────────────!ESC![0m
echo    Created by !ESC![90mNormalCortisolLevels!ESC![0m
echo    !ESC![37m──────────────────────────────────────────────────────────────────!ESC![0m
echo.
echo     !ESC![37m[!ESC![97m1!ESC![37m]!ESC![0m !ESC![37mCLEAN BUILD!ESC![0m  !ESC![90mFull recompile!ESC![0m
echo     !ESC![37m[!ESC![97m2!ESC![37m]!ESC![0m !ESC![37mQUICK BUILD!ESC![0m  !ESC![90mIncremental compile!ESC![0m
echo     !ESC![37m[!ESC![97m3!ESC![37m]!ESC![0m !ESC![37mCLEAN ONLY!ESC![0m   !ESC![90mWipe build artifacts!ESC![0m
if defined LAST (
    echo     !ESC![37m[!ESC![97m4!ESC![37m]!ESC![0m !ESC![92mREPEAT LAST!ESC![0m  !ESC![90m!LAST!!ESC![0m
    echo     !ESC![37m[!ESC![97m5!ESC![37m]!ESC![0m !ESC![91mEXIT!ESC![0m
) else (
    echo     !ESC![37m[!ESC![97m4!ESC![37m]!ESC![0m !ESC![91mEXIT!ESC![0m
)
echo.

if defined LAST (
    <nul set /p "=   !ESC![92m»!ESC![0m Selection (1-5): "
    choice /c 12345 /n >nul
) else (
    <nul set /p "=   !ESC![92m»!ESC![0m Selection (1-4): "
    choice /c 1234 /n >nul
)

set "sel=!errorlevel!"
if "!sel!"=="1" (set "task=clean build" & goto run)
if "!sel!"=="2" (set "task=build"       & goto run)
if "!sel!"=="3" (set "task=clean"       & goto run)
if defined LAST (
    if "!sel!"=="4" (set "task=!LAST!" & goto run)
    if "!sel!"=="5" goto shutdown
) else (
    if "!sel!"=="4" goto shutdown
)
goto menu

:: ── BUILD ───────────────────────────────────────────────────────
:run
set "LAST=!task!"
cls
echo.
echo   !ESC![92mSYSTEM »!ESC![0m Running task: !ESC![97m!task!!ESC![0m
echo   !ESC![90m──────────────────────────────────────────────────────────!ESC![0m
echo.
if exist "!LOG!" del /f /q "!LOG!" >nul 2>&1

start /b "" cmd /c ^""!SCRIPT!" --engine !task!^" > "!LOG!" 2>&1

set "seconds=0"
set "st=Initializing..."
set "pulse=0"

:watch
set /a "seconds+=1"
set /a "pulse=(pulse+1)%%4"
if "!pulse!"=="0" set "icon=·   "
if "!pulse!"=="1" set "icon= ·  "
if "!pulse!"=="2" set "icon=  · "
if "!pulse!"=="3" set "icon=   ·"

set /a "pct=seconds"
if !pct! GTR 99 set "pct=99"
set /a "bw=pct/5"
set "bar="
for /L %%i in (1,1,!bw!)  do set "bar=!bar!█"
set /a "em=20-bw"
if !em! GTR 0 for /L %%i in (1,1,!em!) do set "bar=!bar!░"

if exist "!LOG!" (
    findstr /C:"[ENGINE_FINISHED]" "!LOG!" >nul 2>&1 && goto post
    findstr /C:"BUILD FAILED"      "!LOG!" >nul 2>&1 && goto post
    for /f "usebackq delims=" %%L in (`findstr /b "> Task" "!LOG!" 2^>nul`) do set "st=%%L"
)

<nul set /p "=  !ESC![92m!bar!!ESC![0m !seconds!s !ESC![92m!icon!!ESC![0m ^| !ESC![90m!st!!ESC![0m!ESC![1G"
timeout /t 1 /nobreak >nul 2>&1
goto watch

:post
timeout /t 1 /nobreak >nul
findstr /C:"BUILD SUCCESSFUL" "!LOG!" >nul 2>&1
if !errorlevel! equ 0 goto ok
goto fail

:ok
cls
echo.
echo   !ESC![92m████████████████████!ESC![0m 100%%
echo.
echo   !ESC![92mBUILD SUCCESSFUL!ESC![0m
echo.
if exist "!LOG!" del /f /q "!LOG!" >nul 2>&1
if "!task!"=="clean" (pause & goto menu)
goto deploy

:fail
copy /y "!LOG!" "!ERR!" >nul 2>&1
cls
echo.
echo   !ESC![91mBUILD FAILURE!ESC![0m
echo.
echo   !ESC![90m─── Trace ────────────────────────────────────────────────!ESC![0m
findstr /i /c:"error" /c:"exception" /c:"failure" "!ERR!" 2>nul | findstr /v "ENGINE_FINISHED"
echo   !ESC![90m──────────────────────────────────────────────────────────!ESC![0m
echo.
echo     !ESC![37m[!ESC![97m1!ESC![37m]!ESC![0m Retry   !ESC![37m[!ESC![97m2!ESC![37m]!ESC![0m Log   !ESC![37m[!ESC![97m3!ESC![37m]!ESC![0m Menu
<nul set /p "=   > "
choice /c 123 /n >nul
set "fc=!errorlevel!"
if "!fc!"=="1" goto run
if "!fc!"=="2" (start notepad "!ERR!" & goto fail)
goto menu

:deploy
echo.
echo   !ESC![92mDeployment!ESC![0m
echo   !ESC![90m──────────────────────────────────────────────────────────!ESC![0m
echo     !ESC![37m[!ESC![97m1!ESC![37m]!ESC![0m Copy JAR to Folder
echo     !ESC![37m[!ESC![97m2!ESC![37m]!ESC![0m Open Output Folder
echo     !ESC![37m[!ESC![97m3!ESC![37m]!ESC![0m Back to Menu
echo.
<nul set /p "=   > "
choice /c 123 /n >nul
set "dc=!errorlevel!"

if "!dc!"=="1" (
    for /f "usebackq delims=" %%I in (`powershell -NoProfile -Command "Add-Type -AssemblyName System.Windows.Forms; $f=New-Object System.Windows.Forms.FolderBrowserDialog; $w=New-Object System.Windows.Forms.Form; $w.TopMost=$true; if($f.ShowDialog($w) -eq 'OK'){Write-Output $f.SelectedPath}"`) do set "dest=%%I"
    if defined dest (
        set "fnd=0"
        for %%F in ("!ROOT!build\libs\*.jar") do (
            echo "%%~nxF" | findstr /v /i "sources dev common" >nul && (
                copy /y "%%F" "!dest!\" >nul
                echo   !ESC![92mCopied:!ESC![0m %%~nxF
                set "fnd=1"
            )
        )
        if "!fnd!"=="0" echo   !ESC![91mNo JAR found.!ESC![0m
        pause
    )
    goto deploy
)
if "!dc!"=="2" start explorer "!ROOT!build\libs" & goto deploy
goto menu

:shutdown
if exist "!LOG!" del /f /q "!LOG!" >nul 2>&1
reg add "HKCU\Console" /v QuickEdit /t REG_DWORD /d 1 /f >nul 2>&1
<nul set /p "=!ESC![?25h"
popd
exit /b 0