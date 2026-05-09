# ===============================
# Logging Function
# ===============================
function Write-Log {
    param (
        [Parameter(Mandatory=$true)][string]$Message,
        [ValidateSet("INFO","WARN","ERROR")][string]$Level="INFO",
        [string]$Path="Z:\Logs\OUCreation.log"
    )

    $Stamp = Get-Date -Format "MM-dd-yyyy HH:mm:ss"
    $Line = "$Stamp [$Level] - $Message"

    # Ensure log directory exists
    $Dir = Split-Path $Path
    if (-not (Test-Path $Dir)) { New-Item -ItemType Directory -Path $Dir -Force | Out-Null }

    Add-Content -Path $Path -Value $Line
    Write-Host $Line
}

# ===============================
# Interactive Dry-Run Prompt
# ===============================
$dryRunResponse = Read-Host "Do you want to perform a DRY-RUN first? (y/n)"
$DryRun = $false

if ($dryRunResponse -match '^[Yy]$') {
    $DryRun = $true
    Write-Log "DRY-RUN mode enabled. No OUs will be created."
}

# ===============================
# Import AD Module
# ===============================
try {
    Import-Module ActiveDirectory -ErrorAction Stop
    Write-Log "Active Directory module imported successfully"
} catch {
    Write-Log "Failed to import AD module: $_" -Level "ERROR"
    exit
}

# Base OU (already exists)
$baseOU = "OU=Space Cops,DC=domain,DC=com"

# Companies and Departments arrays
$companies = @("Plumbers", "Star Command", "Justice League", "Peach Creek Defenders")
$departments = @("HR", "IT", "Sales", "Engineering", "Legal")

# Track summary for reporting
$CreatedOUs = @()
$ExistingOUs = @()

function Create-OUs {
    param ($DryRunMode)

    foreach ($company in $companies) {
        $companyOU = "OU=$company,$baseOU"

        try {
            if ($DryRunMode) {
                Write-Log "[DRY-RUN] Would create Company OU: $company"
                $CreatedOUs += $companyOU
            } else {
                New-ADOrganizationalUnit -Name $company -Path $baseOU -ErrorAction Stop
                Write-Log "Created Company OU: $company"
                $CreatedOUs += $companyOU
            }
        } catch {
            if ($_ -match "The object already exists") {
                Write-Log "Company OU already exists: $company" -Level "INFO"
                $ExistingOUs += $companyOU
            } else {
                Write-Log "Failed to create Company OU: $company. Error: $_" -Level "ERROR"
            }
        }

        foreach ($dept in $departments) {
            $deptOU = "OU=$dept,$companyOU"
            try {
                if ($DryRunMode) {
                    Write-Log "[DRY-RUN] Would create Department OU: $dept under $company"
                    $CreatedOUs += $deptOU
                } else {
                    New-ADOrganizationalUnit -Name $dept -Path $companyOU -ErrorAction Stop
                    Write-Log "Created Department OU: $dept under $company"
                    $CreatedOUs += $deptOU
                }
            } catch {
                if ($_ -match "The object already exists") {
                    Write-Log "Department OU already exists: $dept under $company" -Level "INFO"
                    $ExistingOUs += $deptOU
                } else {
                    Write-Log "Failed to create Department OU: $dept under $company. Error: $_" -Level "ERROR"
                }
            }
        }
    }
}

# ===============================
# Run Dry-Run if selected
# ===============================
if ($DryRun) {
    Create-OUs -DryRunMode $true

    # Prompt for confirmation to proceed
    $confirmRun = Read-Host "Dry-run completed. Do you want to run the script for real now? (y/n)"
    if ($confirmRun -match '^[Yy]$') {
        Write-Log "User confirmed to proceed with real OU creation."
        $DryRun = $false
    } else {
        Write-Log "User canceled real OU creation. Exiting."
        exit
    }
}

# ===============================
# Run Real Creation if confirmed
# ===============================
if (-not $DryRun) {
    # Clear summary arrays for real run
    $CreatedOUs = @()
    $ExistingOUs = @()
    Create-OUs -DryRunMode $false
}

# ===============================
# Summary Report
# ===============================
Write-Log "---------------- Summary ----------------"
Write-Log "Created/Planned OUs:"
$CreatedOUs | ForEach-Object { Write-Log "  $_" }
Write-Log "Existing OUs:"
$ExistingOUs | ForEach-Object { Write-Log "  $_" }

Write-Log "Script Completed"
