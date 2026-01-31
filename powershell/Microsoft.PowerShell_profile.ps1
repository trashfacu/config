##configuracion 
oh-my-posh init pwsh --config 'material'| Invoke-Expression
Import-Module -Name Terminal-Icons

fastfetch

function touch { set-content -Path ($args[0]) -Value ($null) } 

##Make Directories MKD

function cdp {
    cd E:\Facultad\myOwnThings
}

function archive {
    cd E:\Facundo\trashFacuDB
}

function dotfiles {
    cd E:\Facundo\config
}