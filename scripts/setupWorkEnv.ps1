# Comprobar si Winget está instalado
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Output "WinGet no está instalado. Por favor, instálalo antes de ejecutar este script."
    exit 1
}

# Lista de aplicaciones a instalar
$appList = @(
    "JetBrains.IntelliJIDEAUltimate",
    "Docker.DockerDesktop",
    "SlackTechnologies.Slack",
    "Postman.Postman",
    "Obsidian.Obsidian",
    "Discord.Discord",
    "Google.Drive",
    "Git.Git",
    "JanDeDobbeleer.OhMyPosh",
    "Microsoft.WSL",
    "7zip.7zip"
)

# Función para instalar cada aplicación
function Install-App {
    param (
        [string]$appName
    )
    
    Write-Output "Instalando $appName..."
    winget install --id $appName --silent --accept-package-agreements --accept-source-agreements
    
    if ($?) {
        Write-Output "$appName instalado exitosamente."
    } else {
        Write-Output "Error al instalar $appName."
    }
}

# Instalar todas las aplicaciones de la lista
foreach ($app in $appList) {
    Install-App -appName $app
}

Write-Output "Instalación de aplicaciones completada."