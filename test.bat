@echo off
for /f "tokens=1,2 delims=:, " %%a in (' find ":" ^< "fileToSearch.json" ') do (
   set "%%~a=%%~b"
)
set
echo This is the id: %id%

set BUILD_NUMBER=2.1.8.0

echo Reached 1
type Shared.wxi|repl "[0-9*]+.[0-9*]+.[0-9*]+.[0-9*]" "%BUILD_NUMBER%" >testShared.wxi
::type %~dp0\AccuVaxInstaller\AccuVaxInstaller\Shared.wxi | repl "[0-9*]+.[0-9*]+.[0-9*]+.[0-9*]" "%BUILD_NUMBER%" >%~dp0\AccuVaxInstaller\AccuVaxInstaller\testShared.wxi 

del Shared.wxi
:: del %~dp0\AccuVaxInstaller\AccuVaxInstaller\Shared.wxi

echo Reached 2
move /y testShared.wxi Shared.wxi
::move /y %~dp0\AccuVaxInstaller\AccuVaxInstaller\testShared.wxi %~dp0\AccuVaxInstaller\AccuVaxInstaller\Shared.wxi 

:: do the same for AssemblyInfo.cs file

echo Reached 3
copy /y %~dp0\..\Documents\Github\accuvax-kiosk-sw\AccuVaxInstaller\AccuVaxInstaller\bin\Release\AccuVaxInstaller.msi  %~dp0
:: actually copy from %~dp0\AccuVaxInstaller\AccuVaxInstaller\bin\Release\AccuVaxInstaller.msi to %~dp0

echo Reached 4
move /y AccuVaxInstaller.msi AccuVaxInstaller_%BUILD_NUMBER%.msi

:: send .msi file to GitHub
:: delete .msi file from directory
