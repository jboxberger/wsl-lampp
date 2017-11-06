@echo off

set UbuntuVersion=1604
set DownloadLink=0
set DownloadFileName=0

call :get_windows_main_version WinVer
call :get_windows_main_version_full WinVerFull
call :get_windows_build_number BuildNumber
set BuildNumber=%BuildNumber:]=%

call :linux_subsystem_installed LinuxSybSystemInstalled
call :ubuntu_installed UbuntuInstalled

call :get_download_link_from_header DownloadLink
call :get_download_link_parse_filename DownloadFileName

@echo # -------------------------------------------------------------------------------------------------------------- #
@echo # Copyright (c) 2017 Juri Boxberger                                                                              #
@echo # -------------------------------------------------------------------------------------------------------------- #
@echo # @author Juri Boxberger                                                                                         #
@echo # @date 06.11.2017                                                                                               #
@echo # License: GNU GPLv3                                                                                             #
@echo # -------------------------------------------------------------------------------------------------------------- #
@echo # @version 1.1                                                                                                   #
@echo # -------------------------------------------------------------------------------------------------------------- #
@echo.
@echo WinVer: %WinVer%
@echo WinVerFull: %WinVerFull%
@echo BuildNumber: %BuildNumber%
@echo LinuxSybSystemInstalled: %LinuxSybSystemInstalled%
@echo UbuntuInstalled: %UbuntuInstalled%
@echo ##################################################################################################################
@echo.

REM set WinVer=9
REM set BuildNumber=1011

if %WinVer% LSS 10 (
	echo.
	echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	echo ! Minimum Windows 10 required! Your Windows Version is: %WinVerFull% please update your system first.         !
	echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	echo.
	pause
	exit
)

if %BuildNumber% LSS 16299 (
    echo.
    echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    echo ! Fall Creators Update not installed. Please Update your system!                                              !
    echo ! Update: https://support.microsoft.com/de-de/help/4028685/windows-10-get-the-fall-creators-update            !
    echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    echo.
    pause
    exit
)

if not %LinuxSybSystemInstalled% == 1 (
	echo.
	echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	echo ! Linux SybSystem is not Installed! Please install it first!                                                  !
	echo ! Please See "2. Enable Windows Subsystem for Linux":                                                         !
	echo ! http://www.omgubuntu.co.uk/2016/08/enable-bash-windows-10-anniversary-update                                !
	echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	echo.
	pause
	exit
)

if "%1"=="/uninstall" (
    echo.
    echo ###############################################################################################################
    echo #   Uninstalling Ubuntu %UbuntuVersion%
    echo ###############################################################################################################
    start /WAIT powershell -Command "echo 'uninstalling package... please do not close this window!'; Get-AppxPackage -Name CanonicalGroupLimited.UbuntuonWindows | Remove-AppxPackage"
    echo uninstalled successful..
    pause
    exit
)

if not %UbuntuInstalled% == 1 (
    echo ###############################################################################################################
    echo #   Installing Ubuntu %UbuntuVersion%
    echo ###############################################################################################################
    if "%DownloadLink%" NEQ "0" if "%DownloadFileName%" NEQ "0" (
        if not exist %DownloadFileName% (
            %cd%/bin/curl -L -J -O %DownloadLink%
        ) else (
            echo %DownloadFileName% already exists... i take this!
        )
        start /WAIT powershell -Command "Add-AppxPackage -Path '%DownloadFileName%'"
    ) else (
        echo "invalid download link detected"
    )
) else (
	ubuntu clean
)

ubuntu -c "exit"

set CurrentDriveUpper=%cd:~0,1%
call :drive_letter_to_lower %CurrentDriveUpper% CurrentDriveLower
set ScriptPath=%CurrentDriveLower%%cd:~2%
set "ScriptPath=/mnt/%ScriptPath:\=/%"
REM @echo ScriptPath: %ScriptPath%

bash.exe -c 'bash %ScriptPath%/wsl-install-lampp.sh'

echo.
echo ###################################################################################################################
echo #   INSTALLATION COMPLETE - PLEASE START "bash.exe" to run the WLS                                                #
echo ###################################################################################################################
echo.

pause

REM ------------------------------------------------------------------------------------------
:drive_letter_to_lower
    if "%1"=="A" set %2=a
    if "%1"=="B" set %2=b
    if "%1"=="C" set %2=c
    if "%1"=="D" set %2=d
    if "%1"=="E" set %2=e
    if "%1"=="F" set %2=f
    if "%1"=="G" set %2=g
    if "%1"=="H" set %2=h
    if "%1"=="I" set %2=i
    if "%1"=="J" set %2=j
    if "%1"=="K" set %2=k
    if "%1"=="L" set %2=l
    if "%1"=="M" set %2=m
    if "%1"=="N" set %2=n
    if "%1"=="O" set %2=o
    if "%1"=="P" set %2=p
    if "%1"=="Q" set %2=q
    if "%1"=="R" set %2=r
    if "%1"=="S" set %2=s
    if "%1"=="T" set %2=t
    if "%1"=="U" set %2=u
    if "%1"=="V" set %2=v
    if "%1"=="W" set %2=w
    if "%1"=="X" set %2=x
    if "%1"=="Y" set %2=y
    if "%1"=="Z" set %2=z
goto :EOF

:get_windows_build_number
	for /f "tokens=6-6 delims=. " %%i in ('ver') do set %1=%%i
goto :EOF

:get_windows_main_version
	for /f "tokens=4-4 delims=. " %%i in ('ver') do set %1=%%i
goto :EOF

:get_windows_main_version_full
	for /f "tokens=4-5 delims=. " %%i in ('ver') do set %1=%%i.%%j
goto :EOF

:linux_subsystem_installed
	for %%X in (lxrun.exe) do (set FOUND=%%~$PATH:X)
	if defined FOUND (
		set %1=1
	) else (
		SET %1=0
    )
goto :EOF

:ubuntu_installed
	for %%X in (ubuntu.exe) do (set FOUND=%%~$PATH:X)
	if defined FOUND (
		set %1=1
	) else (
		SET %1=0
    )
goto :EOF

:get_download_link_from_header
    SET %1=0
    for /f "tokens=1-2" %%i in ('%cd%/bin/curl -sI  https://aka.ms/wsl-ubuntu-%UbuntuVersion%') do (
        if "%%i"=="Location:" (
            set %1=%%j
        )
    )
goto :EOF

:get_download_link_parse_filename
    SET %1=0
    for %%a in ("%DownloadLink%") do set "%1=%%~nxa"
goto :EOF