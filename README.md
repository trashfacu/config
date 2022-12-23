# config

#### Scripts

**Utility to create basic working directories for a project**

+ First you need to edit the "$PROFILE" file in the system and add these two functions.

```ps1
function touch {set-content -Path ($args[0]) -Value ($null)} 

function mkd
{
    mkdir assets,css,scripts,html
    touch index.html
    mv index.html html/
    touch style.css
    mv style.css css
    touch app.js
    mv app.js scripts
}
```

+ Then you need to reload your terminal or simply type ".$PROFILE" in the console and both "mkd" and "touch" functions would be available
