##configuracion 
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/material.omp.json" | Invoke-Expression

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

function work {
    cd D:\Work\PayGoal
}

function dotfiles {
    cd E:\Facundo\config
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

function lineCount {
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Path,
        
        [string]$Filter = "*.*",
        [switch]$CopyToClipboard
    )

    $config = [ordered]@{
        "rg17.txt" = @{ 
            Alias       = "RG17"
            SkipHeader  = 0
            SkipFooter  = 4 
        }
        "RG18.csv" = @{ 
            Alias       = "RG18"
            SkipHeader  = 2
            SkipFooter  = 0 
        }
        "RG830.txt" = @{ 
            Alias       = "RG830"
            SkipHeader  = 1
            SkipFooter  = 0 
        }
        "SELE-SAL-CONSTA.p20out1.*.txt" = @{ 
            Alias       = "AFIP Contribuyentes"
            SkipHeader  = 0
            SkipFooter  = 0 
        }
        "padron_*.txt" = @{ 
            Alias       = "Sirtac Contribuyentes"
            SkipHeader  = 0
            SkipFooter  = 0 
        }
        "PADRON ALICUOTAS DIFERENCIALES - REG PARTICULARES *.txt" = @{ 
            Alias       = "Agip Aliquotas Dif"
            SkipHeader  = 0
            SkipFooter  = 0 
        }
        "ARDJU008*.txt" = @{ 
            Alias       = "Afip Regimenes Gen"
            SkipHeader  = 0
            SkipFooter  = 0 
        }
        "PadronRGSPer*.txt"= @{ 
            Alias       = "Arba"
            SkipHeader  = 0
            SkipFooter  = 0 
        }
        "PasiblesConvenioRG202_2020_*.xlsx" = @{ 
            Alias       = "Corrientes Conv"
            SkipHeader  = 2
            SkipFooter  = 0 
        }
        "PasiblesLocalesRG202_2020_*.xlsx" = @{ 
            Alias       = "Corrientes Local"
            SkipHeader  = 2
            SkipFooter  = 0 
        }
        "CTES_RG202_Novedades_*.txt" = @{ 
            Alias       = "Corrientes Excluidos"
            SkipHeader  = 0
            SkipFooter  = 0 
        }
        "PADRONRETPER*.txt" = @{ 
            Alias       = "Jujuy Ret/Per"
            SkipHeader  = 1
            SkipFooter  = 0 
        }
        "PADRONRETPER*_EXCLUIDOS.txt" = @{
            Alias       = "Jujuy Excluidos"
            SkipHeader = 1
            SkipFooter = 0 
        }
        "PadronContConvMult_*_*.csv" = @{ 
            Alias       = "Sta fe Conv Mult"
            SkipHeader  = 1
            SkipFooter  = 0 
        }
        "PadronContRegGeneral_*_*.csv" = @{ 
            Alias = "Sta fe Conv Local"
            SkipHeader = 1
            SkipFooter = 0
        }
        "CnrtVigentes_*_*.csv"= @{
            Alias = "Sta fe no Ret"
            SkipHeader = 1
            SkipFooter = 0 
        }
        "PadronRSCompleto_*_*.csv"= @{ 
            Alias = "Sta fe Reg Simpl"
            SkipHeader = 1
            SkipFooter = 0 }
        "padronTC.txt" = @{ 
            Alias       = "Tucuman TC"
            SkipHeader  = 7
            SkipFooter  = 0 
        }
        "*_padron_banco_srcp.txt" = @{ 
            Alias       = "Sircupa Contribuyetes"
            SkipHeader  = 0
            SkipFooter  = 0 
        }
        "*_devoluciones.txt" = @{ 
            Alias       = "Sircupa Devoluciones"
            SkipHeader  = 0
            SkipFooter  = 0 
        }
    }

    $files = @(Get-ChildItem -Path $Path -Filter $Filter -File)
    $runspacePool = [runspacefactory]::CreateRunspacePool(1, [Environment]::ProcessorCount)
    $runspacePool.Open()
    
    $jobs = $files | ForEach-Object {
        $psInstance = [powershell]::Create().AddScript({
            param($file, $config)
            
            $fileConfig = $config.GetEnumerator() |
                Where-Object { $file.Name -like $_.Name } |
                Select-Object -First 1 -ExpandProperty Value

            try {
                $allLines = [System.IO.File]::ReadAllLines($file.FullName)
                $totalLines = $allLines.Length
                $start = [Math]::Min($fileConfig.SkipHeader, $totalLines)
                $end = [Math]::Max(0, $totalLines - $fileConfig.SkipFooter - $start)
                $effectiveLines = [Math]::Max(0, $end)

                [PSCustomObject]@{
                    ReportName    = if ($fileConfig.Alias) { $fileConfig.Alias } else { $file.Name }
                    TotalLines    = $totalLines
                    Effective     = $effectiveLines
                    OriginalName  = $file.Name
                    OrderKey      = [Array]::IndexOf($config.Keys, ($config.GetEnumerator() | Where-Object { $file.Name -like $_.Name } | Select-Object -First 1).Name)
                }
            }
            catch {
                Write-Warning "Error processing $($file.Name): $_"
            }
        })

        $psInstance.RunspacePool = $runspacePool
        $psInstance.AddParameters(@{ file = $_; config = $config }) | Out-Null
        
        @{ Instance = $psInstance; Handle = $psInstance.BeginInvoke() }
    }

    $results = foreach ($job in $jobs) {
        try {
            $job.Instance.EndInvoke($job.Handle)
        }
        finally {
            $job.Instance.Dispose()
        }
    }

    $runspacePool.Close()
    $runspacePool.Dispose()

    $orderedResults = $results | Sort-Object { 
        if ($_.OrderKey -eq -1) { [Int32]::MaxValue } else { $_.OrderKey }
    }

    $unmatched = $orderedResults | Where-Object { $_.OrderKey -eq -1 } | Sort-Object OriginalName
    $matched = $orderedResults | Where-Object { $_.OrderKey -ne -1 }
    $finalOrder = $matched + $unmatched

    $finalOrder | ForEach-Object {
        $maxNameLength = ($finalOrder.ReportName | Measure-Object -Property Length -Maximum).Maximum
        $maxTotalWidth = ($finalOrder.TotalLines | ForEach-Object { "$_".Length } | Measure-Object -Maximum).Maximum
        $maxValidWidth = ($finalOrder.Effective | ForEach-Object { "$_".Length } | Measure-Object -Maximum).Maximum

        $coloredName = "$($PSStyle.Foreground.Red)$($_.ReportName.PadRight($maxNameLength))$($PSStyle.Reset)"
        $coloredValid = "$($PSStyle.Foreground.Blue)$($_.Effective.ToString().PadLeft($maxValidWidth))$($PSStyle.Reset)"
        $totalLines = $_.TotalLines.ToString().PadLeft($maxTotalWidth)
        "$coloredName  $totalLines  $coloredValid"
        
    } | ForEach-Object {
        $_
    }

    if ($CopyToClipboard) {
        $clipData = $finalOrder | ForEach-Object {
            "`"$($_.Effective)`"`t$($_.ReportName)"
        }
        $clipData | Set-Clipboard
        Write-Host "`Copiado a Excel!" -ForegroundColor Red
        Write-Host "data:`n"
        $clipData | ForEach-Object { Write-Host "| $_ |" }
    }
}