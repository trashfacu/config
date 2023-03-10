# Install Oh My Posh
Install-Module oh-my-posh -Scope CurrentUser
# Set up the PowerShell profile
if (!(Test-Path -Path $PROFILE )) { New-Item -Type File -Path $PROFILE -Force }
Add-Content $PROFILE "`n# Set up Oh My Posh"
Add-Content $PROFILE 'Import-Module oh-my-posh'
Add-Content $PROFILE 'Set-Theme Paradox'