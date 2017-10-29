@echo off

call :get_windows_main_version WinVer
call :get_windows_main_version_full WinVerFull
call :get_windows_build_number BuildNumber
set BuildNumber=%BuildNumber:]=%

call :developer_mode_enabled DeveloperMode
call :linux_subsystem_installed LinuxSybSystemInstalled

@echo # ----------------------------------------------------------------------------------------- #
@echo # Copyright (c) 2017 Juri Boxberger                                                         #
@echo # ----------------------------------------------------------------------------------------- #
@echo # @author Juri Boxberger                                                                    #
@echo # @date 20.10.2017                                                                          #
@echo # License: GNU GPLv3                                                                        #
@echo # ----------------------------------------------------------------------------------------- #
@echo # @version 1.0                                                                              #
@echo # ----------------------------------------------------------------------------------------- #
@echo.
@echo WinVer: %WinVer%
@echo WinVerFull: %WinVerFull%
@echo BuildNumber: %BuildNumber%
@echo DeveloperMode: %DeveloperMode%
@echo LinuxSybSystemInstalled: %LinuxSybSystemInstalled%
@echo #####################################################################################################
@echo.

REM set WinVer=9
REM set BuildNumber=1011
REM set DeveloperMode=0

if %WinVer% LSS 10 (
	echo.
	echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	echo ! Minimum Windows 10 required! Youre Windows Vrsion is: %WinVerFull% please update your system first. !
	echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	echo.
	pause
	exit
) else (
	if %BuildNumber% LSS 16299 if %DeveloperMode% == 0 (
		echo.
		echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		echo ! Fall Creators Update not installed. Please Update your system or enable developer mode!                           !
		echo ! Update: https://support.microsoft.com/de-de/help/4028685/windows-10-get-the-fall-creators-update                  !
		echo ! Developer Mode: https://docs.microsoft.com/de-de/windows/uwp/get-started/enable-your-device-for-development       !
		echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		echo.
		pause
		exit
	)
)

if not %LinuxSybSystemInstalled% == 1 (
	echo.
	echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	echo ! Linux SysbSystem is not Installed! Please install it first!                                                       !
	echo ! Please See "2. Enable Windows Subsystem for Linux":                                                               !
	echo ! http://www.omgubuntu.co.uk/2016/08/enable-bash-windows-10-anniversary-update                                      !
	echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	echo.
	pause
	exit
)

REM Uninstall completely:
lxrun /uninstall /full /y

REM New install (root user created):
lxrun /install /y

REM added new user to prevent root usage:
lxrun /setdefaultuser

set CurrentDriveUpper=%cd:~0,1%
call :drive_letter_to_lower %CurrentDriveUpper% CurrentDriveLower
set ScriptPath=%CurrentDriveLower%%cd:~2%
set "ScriptPath=/mnt/%ScriptPath:\=/%"
REM @echo ScriptPath: %ScriptPath%

bash.exe -c 'bash %ScriptPath%/wsl-install-lampp.sh'

echo.
echo ######################################################################
echo #   INSTALLATION COMPLETE - PLEASE START "bash.exe" to run the WLS   #
echo ######################################################################
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

:developer_mode_enabled
	set KEY_NAME="HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock"
	set VALUE_NAME="AllowDevelopmentWithoutDevLicense"
	set DeveloperMode=0x0

	FOR /F "usebackq tokens=3*" %%A IN (`REG QUERY %KEY_NAME% /v %VALUE_NAME%`) DO (
		set DeveloperMode=%%A
	)
	if %DeveloperMode% == 0x1 (
		SET %1=1
	) else (
		SET %1=0
    )
goto :EOF

:linux_subsystem_installed
	for %%X in (lxrun.exe) do (set FOUND=%%~$PATH:X)
	if defined FOUND (
		set %1=1
	) else (
		SET %1=0
    )
goto :EOF