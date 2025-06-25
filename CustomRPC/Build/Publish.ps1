$env:GIT_REDIRECT_STDERR = '2>&1'

$verRaw = (Get-Item ..\bin\Release\CustomRP.exe).VersionInfo
$env:CUSTOMRP_VER = "$($verRaw.FileMajorPart).$($verRaw.FileMinorPart)"
if ($verRaw.FileBuildPart -ne 0 -or $verRaw.FilePrivatePart -ne 0) { $env:CUSTOMRP_VER += ".$($verRaw.FileBuildPart)" }
if ($verRaw.FilePrivatePart -ne 0) { $env:CUSTOMRP_VER += ".$($verRaw.FilePrivatePart)" }

xcopy ..\bin\Release CustomRP /e /i /s /y /exclude:exclude.txt
xcopy License.txt CustomRP
xcopy "Privacy Policy.txt" CustomRP
iwr -Uri "https://files.jrsoftware.org/is/6/innosetup-6.4.3.exe" -OutFile "./is.exe"
Start-Process -FilePath ".\is.exe" -ArgumentList "/verysilent", "/suppressmsgboxes" -Wait
git clone https://github.com/jrsoftware/issrc
C:\Program` Files` `(x86`)\Inno` Setup` 6\ISCC.exe /DMyAppVersion=$env:CUSTOMRP_VER Installer.iss

echo "start CustomRP.exe --second-instance" > "CustomRP\Start Second Instance.bat"
Compress-Archive -Path CustomRP,"Windows 7",README.txt -DestinationPath "Artifacts\CustomRP $env:CUSTOMRP_VER.zip" -CompressionLevel Optimal

$hashes = "=== SHA256 Hashes ===`nCustomRP $env:CUSTOMRP_VER.exe`n    $((Get-FileHash "Artifacts\CustomRP $env:CUSTOMRP_VER.exe" -Algorithm SHA256).Hash)`nCustomRP $env:CUSTOMRP_VER.zip`n    $((Get-FileHash "Artifacts\CustomRP $env:CUSTOMRP_VER.zip" -Algorithm SHA256).Hash)`n====================="

$hashes

$hashes > "Artifacts\CustomRP Hashes $env:CUSTOMRP_VER.txt"