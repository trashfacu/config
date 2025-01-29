##configuracion 
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/material.omp.json" | Invoke-Expression

Import-Module -Name Terminal-Icons

echo "Welcome back, Facu"

function touch { set-content -Path ($args[0]) -Value ($null) } 

##Make Directories MKD

function cdp {
    cd E:\Facultad\myOwnThings
}

function archive {
    cd E:\Facundo\trashFacuDB
}

function work {
    cd D:\Work\PayGoal
}

function gitcfg {
    $UserName = "Facundo Mazziotti"
    $UserEmail = "facundo.mazziotti@paygoal.io"

    if (-not (Test-Path ".git")) {
        Write-Host "Error: Este directorio no es un repositorio Git." -ForegroundColor Red
        return
    }

    try {
        git config --local user.name $UserName
        git config --local user.email $UserEmail
        Write-Host "Configuración de Git actualizada:"
        Write-Host "  Nombre de usuario: $UserName"
        Write-Host "  Email: $UserEmail"
    }
    catch {
        Write-Host "Error al configurar Git:" -ForegroundColor Red
        Write-Host $_.Exception.Message
    }
}