
# check for notepad++
$npp = scoop which notepad++
if($lastexitcode -ne 0) { 'notepad++ isn''t installed. run ''scoop install notepadplusplus notepadplusplus-pm'''; return }

# get core functions
Write-Output "Getting scoop helper functions..."
$core_url = 'https://raw.github.com/lukesampson/scoop/master/lib/core.ps1'
Write-Output 'Initializing...'
Invoke-Expression (new-object net.webclient).downloadstring($core_url)

$app_dir = appdir('notepadplusplus')
if(test-path $app_dir) {
    Write-Output "Found notepadplusplus app directory:\n$app_dir"
} else {
    Write-Output "error: couldn't find notepadplusplus app directory"; return
}


$persist_dir = persistdir('notepadplusplus')
if(test-path $persist_dir) {
    Write-Output "Found notepadplusplus persist directory:\n$persist_dir"
} else {
    Write-Output "error: couldn't find notepadplusplus persist directory"; return
}

Write-Output "Downloading notepad++ shell integration extension..."

# download scoop zip
$zipurl = 'http://notepad-plus.sourceforge.net/commun/misc/NppShell.New.zip'
$zipfile = "$persist_dir\NppShell.New.zip"
Write-Output 'Downloading...'
dl $zipurl $zipfile
#unzip files
unzip $zipfile "$persist_dir\_tmp"
Copy-Item "$persist_dir\_tmp\*" $persist_dir -r -force
Remove-Item "$persist_dir\_tmp" -r -force
Remove-Item $zipfile

#$persist_dir = "$(split-path $npp -resolve)\..\..\..\persist\notepadplusplus"
#$persist_dir = "$(Resolve-Path $conf)"
write-host "$persist_dir"

cd "$app_dir"

$shellExt = "NppShell.dll"
$shellExt64 = "NppShell64.dll"

Write-Output 'enabling shell extension...'
if(test-path $persist_dir\$shellExt) {
    Write-Output "making a link from $app_dir\current\$shellExt to $persist_dir\$shellExt"
    sudo cmd /c mklink $app_dir\current\$shellExt $persist_dir\$shellExt
    Write-Output "registering $shellExt"
	regsvr32 /s /i "$shellExt"
} else {
	Write-Output "error: couldn't find $shellExt"
}

if(test-path $persist_dir\$shellExt64) {
    Write-Output "making a link from $app_dir\current\$shellExt64 to $persist_dir\$shellExt64"
    sudo cmd /c mklink $app_dir\current\$shellExt64 $persist_dir\$shellExt64
    Write-Output "registering $shellExt64"
	regsvr32 /s /i "$shellExt64"
} else {
	Write-Output "error: couldn't find $shellExt64"
}

Write-Output "done"