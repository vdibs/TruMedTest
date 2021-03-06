:: test teamcity prerelease
 
:: push tag to GitHub
git tag v%BUILD_NUMBER%
git push origin --tags

:: create release 
echo Creating Release
echo {"tag_name": "v%BUILD_NUMBER%","target_commitish": "master","name": "v%BUILD_NUMBER%","body":"Release of version v%BUILD_NUMBER% with TeamCity", "draft": false,"prerelease": true} > json.json
curl -u "vdibs" https://api.github.com
curl -# -XPOST -H 'Content-Type:application/json' -H 'Accept:application/json' --data-binary @json.json https://api.github.com/repos/:vdibs/:TruMedTest.git/releases -o response.json
del json.json

:: get release id
for /f "tokens=1,2 delims=:, " %%a in (' find ":" ^< "response.json" ') do (
   set "%%~a=%%~b"
)
set
echo This is the id: %id%

:: Copy installer to current directory
echo Reached 3
copy /y %~dp0\Folder\AccuVaxInstaller.msi  %~dp0
echo Reached 4
:: rename installer
move /y AccuVaxInstaller.msi AccuVaxInstaller_%BUILD_NUMBER%.msi

:: upload msi to release
curl -u "vdibs" https://api.github.com
curl -# -XPOST -H "Content-Type:application/x-ole-storage" --data-binary @AccuVaxInstaller_%BUILD_NUMBER%.msi --data-binary https://uploads.github.com/repos/:vdibs/:TruMedTest.git/releases/:%id%/assets?name=AccuVaxInstaller_%BUILD_NUMBER%.msi

:: delete installer in current dir
del AccuVaxInstaller_%BUILD_NUMBER%.msi


:: replace old version with new version number
echo Reached 1
type %~dp0\Folder\Shared.wxi|repl "[0-9*]+.[0-9*]+.[0-9*]+.[0-9*]" "%BUILD_NUMBER%" >%~dp0\Folder\testShared.wxi 
del %~dp0\Folder\Shared.wxi 
echo Reached 2
:: rename to original
move /y %~dp0\Folder\testShared.wxi %~dp0\Folder\Shared.wxi

:: To Test!!
echo Reached: add Shared.wxi
git add %~dp0\Folder\Shared.wxi
git commit -m "bump version number"
git push

EXIT
