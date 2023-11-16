##configuracion 
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/material.omp.json" | Invoke-Expression

Import-Module -Name Terminal-Icons

echo "Welcome back, Facu"

function touch { set-content -Path ($args[0]) -Value ($null) } 

##Make Directories MKD

function mkd {
    mkdir assets, css, scripts
    touch index.html
    touch style.css
    mv style.css css
    touch app.js
    mv app.js scripts
}

function cdp {
    cd E:\Facultad\myOwnThings
}

function cdj {
	cd E:\Facultad\Challenges-jobs
}

function archive {
	cd E:\Facundo\trashFacuDB
}
