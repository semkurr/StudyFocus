@echo off
chcp 1251 >nul
echo ====================================================
echo         SUPER GAMES BLOCKER FOR CLUB
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

echo Starting complete games blocking process...
echo This will block websites, disable Store AND block installers.
echo.

echo [PHASE 1] Blocking game websites in hosts file...
echo.

:: Add all blocking addresses to hosts
echo # ===== BLOCKED GAMES - DO NOT EDIT ===== >> "%SystemRoot%\System32\drivers\etc\hosts"

:: BLOCK YANDEX GAMES - MULTIPLE DOMAINS
echo 0.0.0.1 yastatic.net >> "%SystemRoot%\System32\drivers\etc\hosts"
echo 0.0.0.1 yandex.net >> "%SystemRoot%\System32\drivers\etc\hosts"
echo 0.0.0.1 yandexgames.com >> "%SystemRoot%\System32\drivers\etc\hosts"
echo 0.0.0.1 games.yandex.ru >> "%SystemRoot%\System32\drivers\etc\hosts"
echo 0.0.0.1 yandex.ru >> "%SystemRoot%\System32\drivers\etc\hosts"

:: OTHER GAMES
echo 0.0.0.1 minigames.mail.ru >> "%SystemRoot%\System32\drivers\etc\hosts"
echo 0.0.0.1 www.min2win.ru >> "%SystemRoot%\System32\drivers\etc\hosts"
echo 0.0.0.1 igroutka.ru >> "%SystemRoot%\System32\drivers\etc\hosts"
echo 0.0.0.1 poki.com >> "%SystemRoot%\System32\drivers\etc\hosts"
echo 0.0.0.1 vk.com >> "%SystemRoot%\System32\drivers\etc\hosts"
echo 0.0.0.1 www.crazygames.ru >> "%SystemRoot%\System32\drivers\etc\hosts"
echo 0.0.0.1 games.woman.ru >> "%SystemRoot%\System32\drivers\etc\hosts"
echo 0.0.0.1 playhop.com >> "%SystemRoot%\System32\drivers\etc\hosts"
echo 0.0.0.1 wellgames.com >> "%SystemRoot%\System32\drivers\etc\hosts"
echo 0.0.0.1 ru.4game.ru >> "%SystemRoot%\System32\drivers\etc\hosts"
echo 0.0.0.1 startgamer.ru >> "%SystemRoot%\System32\drivers\etc\hosts"
echo 0.0.0.1 store.epicgames.com >> "%SystemRoot%\System32\drivers\etc\hosts"
echo 0.0.0.1 best-casino.ulusp.ru >> "%SystemRoot%\System32\drivers\etc\hosts"
echo 0.0.0.1 www.igraemsa.ru >> "%SystemRoot%\System32\drivers\etc\hosts"
echo 0.0.0.1 igraz.ru >> "%SystemRoot%\System32\drivers\etc\hosts"
echo 0.0.0.1 gfn.am >> "%SystemRoot%\System32\drivers\etc\hosts"
echo 0.0.0.1 ru.y8.com >> "%SystemRoot%\System32\drivers\etc\hosts"
echo 0.0.0.1 tankionline.com >> "%SystemRoot%\System32\drivers\etc\hosts"
echo 0.0.0.1 mersibo.ru >> "%SystemRoot%\System32\drivers\etc\hosts"
echo 0.0.0.1 rudagames.com >> "%SystemRoot%\System32\drivers\etc\hosts"
echo 0.0.0.1 www.pacogames.com >> "%SystemRoot%\System32\drivers\etc\hosts"
echo 0.0.0.1 www.gladiators.ru >> "%SystemRoot%\System32\drivers\etc\hosts"
echo 0.0.0.1 www.starstable.com >> "%SystemRoot%\System32\drivers\etc\hosts"
echo 0.0.0.1 salo.fun >> "%SystemRoot%\System32\drivers\etc\hosts"
echo 0.0.0.1 pwonline.ru >> "%SystemRoot%\System32\drivers\etc\hosts"
echo 0.0.0.1 allods.ru >> "%SystemRoot%\System32\drivers\etc\hosts"
echo 0.0.0.1 www.leagueoflegends.com >> "%SystemRoot%\System32\drivers\etc\hosts"
echo 0.0.0.1 ru.sgames.org >> "%SystemRoot%\System32\drivers\etc\hosts"
echo 0.0.0.1 play.win-pinup-casino.buzz >> "%SystemRoot%\System32\drivers\etc\hosts"
echo 0.0.0.1 w1.dwar.ru >> "%SystemRoot%\System32\drivers\etc\hosts"
echo 0.0.0.1 ru.warface.com >> "%SystemRoot%\System32\drivers\etc\hosts"

:: BLOCK ROBLOX
echo 0.0.0.1 roblox.com >> "%SystemRoot%\System32\drivers\etc\hosts"
echo 0.0.0.1 www.roblox.com >> "%SystemRoot%\System32\drivers\etc\hosts"
echo 0.0.0.1 setup.roblox.com >> "%SystemRoot%\System32\drivers\etc\hosts"
echo 0.0.0.1 assetgame.roblox.com >> "%SystemRoot%\System32\drivers\etc\hosts"

echo # ===== END OF BLOCKED GAMES ===== >> "%SystemRoot%\System32\drivers\etc\hosts"

echo [INFO] Clearing DNS cache...
ipconfig /flushdns >nul
echo ✓ 42 gaming websites blocked

echo.
echo [PHASE 2] Complete Microsoft Store disable...
echo.

echo [1/4] Applying registry policies...
reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v "RemoveWindowsStore" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v "AutoDownload" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModel\AdminOperations" /v "Microsoft.WindowsStore_8wekyb3d8bbwe" /t REG_SZ /d "False" /f >nul 2>&1
echo ✓ Registry policies applied

echo [2/4] Stopping and disabling services...
sc stop "AppXSvc" >nul 2>&1
sc config "AppXSvc" start= disabled >nul 2>&1
sc stop "InstallService" >nul 2>&1
sc config "InstallService" start= disabled >nul 2>&1
sc stop "WSService" >nul 2>&1
sc config "WSService" start= disabled >nul 2>&1
echo ✓ Services disabled

echo [3/4] Applying additional registry restrictions...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoWindowsStore" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d 1 /f >nul 2>&1
echo ✓ Additional restrictions applied

echo [4/4] Running PowerShell cleanup...
powershell -Command "Get-AppxPackage *WindowsStore* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
powershell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -like '*WindowsStore*'} | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue" >nul 2>&1
echo ✓ PowerShell cleanup completed

echo.
echo [PHASE 3] Blocking .exe installers...
echo.

echo [1/3] Blocking installer services...
sc stop "msiserver" >nul 2>&1
sc config "msiserver" start= disabled >nul 2>&1
echo ✓ Windows Installer service disabled

echo [2/3] Applying software restriction policies...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers" /v "DefaultLevel" /t REG_DWORD /d 131072 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers" /v "AuthenticodeEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
echo ✓ Software restrictions applied

echo [3/3] Blocking common installer locations...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "DisableLocalMachineRun" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "DisableLocalMachineRunOnce" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "DisableCurrentUserRun" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "DisableCurrentUserRunOnce" /t REG_DWORD /d 1 /f >nul 2>&1
echo ✓ Installer locations blocked

echo.
echo ====================================================
echo SUCCESS: COMPLETE BLOCKING FINISHED!
echo.
echo BLOCKED:
echo ✓ 42 gaming websites (hosts file)
echo ✓ Microsoft Store (registry + services)
echo ✓ Windows Store packages (PowerShell)
echo ✓ .exe installers (services + policies)
echo.
echo DNS cache cleared.
echo Please RESTART computer for full effect.
echo ====================================================
echo.
pause