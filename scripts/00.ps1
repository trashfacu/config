# List of applications to install with Winget
$Apps = @(
    @{name="AutoHotkey"; id="AutoHotkey.AutoHotkey"},
    @{name="Discord"; id="Discord.Discord"},
    @{name="Steam"; id="Valve.Steam"},
    @{name="Joplin"; id="Joplin.Joplin"},   
    @{name="Git"; id="Git.Git"},
    @{name="Google Chrome"; id="Google.Chrome"},
    @{name="IntelliJ IDEA Community"; id="JetBrains.IntelliJIDEA.Community"},
    @{name="Java"; id="Oracle.JavaRuntimeEnvironment"},
    @{name="Java SDK 19"; id="Oracle.JDK.19"},
    @{name="League of Legends"; id="RiotGames.LeagueOfLegends.LA2"},
    @{name="Lightshot"; id="Skillbrains.Lightshot"},
    @{name="Visual Studio Code"; id="Microsoft.VisualStudioCode"},
    @{name="Oh my posh"; id="JanDeDobbeleer.OhMyPosh"},
    @{name="Postman"; id="Postman.Postman"},
    @{name="7zip"; id="7zip.7zip"},
    @{name="Zoom"; id="Zoom.Zoom"}
)

# Install each application and show progress
$i = 1
$total = $Apps.Count
foreach ($app in $Apps) {
    Write-Host "Installing $($app.name) ($i/$total)..."
    winget install -i $($app.id) -e
    $i++
}

# Check if installations were successful
if ($LASTEXITCODE -ne 0) {
    Write-Host "Some applications were not installed successfully."
} else {
    Write-Host "All applications were installed successfully."
}