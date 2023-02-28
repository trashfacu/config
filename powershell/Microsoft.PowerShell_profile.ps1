##configuracion 
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/velvet.omp.json" | Invoke-Expression

Import-Module -Name Terminal-Icons

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
    cd E:\Facultad\myOwnThings\Proyectos
}

function startProyect {
    cdp
    code .\ScalonetaClicker\
    cd .\ScalonetaClicker\
}


