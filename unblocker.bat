@echo off
chcp 1251 >nul
echo ====================================================
echo         SUPER GAMES UNBLOCKER FOR CLUB
echo ====================================================
echo.

:: Check admin rights
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ERROR: Please run as Administrator!
    echo Right-click - Run as administrator
    pause
    exit /b 1
)

echo Starting complete games unblocking process...
echo This will unblock websites, enable Store AND allow installers.
echo.

echo [PHASE 1] Restoring original hosts file...
echo.

:: Create temporary file without blocked games
findstr /v "BLOCKED GAMES" "%SystemRoot%\System32\drivers\etc\hosts" > "%SystemRoot%\System32\drivers\etc\hosts.tmp"

:: Replace original hosts with cleaned version
move /y "%SystemRoot%\System32\drivers\etc\hosts.tmp" "%SystemRoot%\System32\drivers\etc\hosts" >nul

echo [INFO] Clearing DNS cache...
ipconfig /flushdns >nul
echo ✓ All gaming websites unblocked

echo.
echo [PHASE 2] Complete Microsoft Store enable...
echo.

echo [1/4] Removing registry policies...
reg delete "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v "RemoveWindowsStore" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v "AutoDownload" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModel\AdminOperations" /v "Microsoft.WindowsStore_8wekyb3d8bbwe" /f >nul 2>&1
echo ✓ Registry policies removed

echo [2/4] Starting and enabling services...
sc config "AppXSvc" start= demand >nul 2>&1
sc start "AppXSvc" >nul 2>&1
sc config "InstallService" start= demand >nul 2>&1
sc start "InstallService" >nul 2>&1
sc config "WSService" start= demand >nul 2>&1
sc start "WSService" >nul 2>&1
echo ✓ Services enabled

echo [3/4] Removing additional registry restrictions...
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoWindowsStore" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /f >nul 2>&1
echo ✓ Additional restrictions removed

echo [4/4] Reinstalling Store via PowerShell...
powershell -Command "Get-AppxPackage -AllUsers | ForEach-Object {Add-AppxPackage -DisableDevelopmentMode -Register \"$($_.InstallLocation)\AppXManifest.xml\" -ErrorAction SilentlyContinue}" >nul 2>&1
echo ✓ Store packages reinstalled

echo.
echo [PHASE 3] Enabling .exe installers...
echo.

echo [1/3] Enabling installer services...
sc config "msiserver" start= demand >nul 2>&1
sc start "msiserver" >nul 2>&1
echo ✓ Windows Installer service enabled

echo [2/3] Removing software restriction policies...
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers" /v "DefaultLevel" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers" /v "AuthenticodeEnabled" /f >nul 2>&1
echo ✓ Software restrictions removed

echo [3/3] Unblocking installer locations...
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "DisableLocalMachineRun" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "DisableLocalMachineRunOnce" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "DisableCurrentUserRun" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "DisableCurrentUserRunOnce" /f >nul 2>&1
echo ✓ Installer locations unblocked

echo.
echo ====================================================
echo SUCCESS: COMPLETE UNBLOCKING FINISHED!
echo.
echo UNBLOCKED:
echo ✓ All gaming websites (hosts file cleaned)
echo ✓ Microsoft Store (registry + services)
echo ✓ Windows Store packages (reinstalled)
echo ✓ .exe installers (services + policies)
echo.
echo DNS cache cleared.
echo Please RESTART computer for full effect.
echo ====================================================
echo.
pause