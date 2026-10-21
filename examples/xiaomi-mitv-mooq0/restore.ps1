<#
.SYNOPSIS
    Script de restauración para Xiaomi Mi TV (MiTV-MOOQ0).
.DESCRIPTION
    Rehabilita los paquetes deshabilitados durante el proceso de debloat y restablece
    el launcher stock (Google TV / Android TV) como predeterminado.
.PARAMETER TvHost
    Dirección IP del televisor en la red local (ejemplo: 192.168.1.50).
.PARAMETER AdbPath
    Ruta opcional al ejecutable adb. Si no se especifica, se detecta automáticamente.
.EXAMPLE
    .\restore.ps1 -TvHost 192.168.1.50
#>
param(
    [Parameter(Mandatory = $true, HelpMessage = "Introduce la IP de la TV (ej. 192.168.1.50)")]
    [string]$TvHost,

    [string]$AdbPath = ""
)

$ErrorActionPreference = 'Stop'

# Detectar ADB automáticamente si no se proporciona ruta
if (-not $AdbPath) {
    if (Get-Command adb -ErrorAction SilentlyContinue) {
        $AdbPath = (Get-Command adb).Source
    } elseif ($env:ANDROID_HOME -and (Test-Path "$env:ANDROID_HOME\platform-tools\adb.exe")) {
        $AdbPath = "$env:ANDROID_HOME\platform-tools\adb.exe"
    } elseif ($env:LOCALAPPDATA -and (Test-Path "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe")) {
        $AdbPath = "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"
    } else {
        # Búsqueda común en paquetes de WinGet
        $wingetAdb = Get-ChildItem "$env:LOCALAPPDATA\Microsoft\WinGet\Packages" -Filter "adb.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($wingetAdb) {
            $AdbPath = $wingetAdb.FullName
        }
    }
}

if (-not $AdbPath -or -not (Test-Path $AdbPath)) {
    throw "No se encontró adb.exe. Asegúrate de tener instalado Android Platform Tools y que esté en el PATH o especifica -AdbPath."
}

Write-Host "Usando ADB: $AdbPath" -ForegroundColor Cyan
Write-Host "Conectando con la TV en $TvHost:5555..." -ForegroundColor Cyan
& $AdbPath connect "$TvHost`:5555" | Out-Null

$packages = @(
    "com.miui.tv.analytics",
    "com.xiaomi.statistic",
    "com.google.android.tv.bugreportsender",
    "com.google.android.feedback",
    "com.mitv.tvhome.atv",
    "com.mitv.tvhome.michannel",
    "com.xm.webcontent",
    "com.xiaomi.floatingframe",
    "android.autoinstalls.config.xiaomi.amelie",
    "com.xiaomi.mitv.tvmanager",
    "com.xiaomi.amazon.alexa",
    "com.mitv.gallery",
    "com.mitv.dream",
    "com.google.android.backdrop",
    "com.mitv.tvlock",
    "com.xiaomo.tv.milegal",
    "com.mstar.android.tv.disclaimercustomization",
    "com.mediatek.wwtv.webview",
    "fusion.android.tv.demo",
    "com.xiaomi.mimusic2",
    "com.google.android.play.games",
    "com.duokan.factorytest",
    "com.google.android.tvrecommendations",
    "com.google.android.leanbacklauncher",
    "com.google.android.leanbacklauncher.recommendations",
    "com.xiaomi.mitv.updateservice",
    "com.xiaomi.mitv.mediaexplorer",
    "com.mitv.videoplayer"
)

Write-Host "Rehabilitando paquetes en la TV..." -ForegroundColor Yellow
foreach ($pkg in $packages) {
    Write-Host "  -> Habilitando $pkg..."
    & $AdbPath -s "$TvHost`:5555" shell pm enable --user 0 $pkg 2>$null
}

Write-Host "Restaurando launcher stock como predeterminado..." -ForegroundColor Yellow
& $AdbPath -s "$TvHost`:5555" shell pm enable --user 0 com.google.android.tvlauncher 2>$null
& $AdbPath -s "$TvHost`:5555" shell cmd package set-home-activity --user 0 com.google.android.tvlauncher/.MainActivity 2>$null

Write-Host "`nRestauración completada con éxito." -ForegroundColor Green
