# ==============================
# CONFIGURATION
# ==============================
$departmentOU = "OU=Justice League,OU=Space Cops,DC=domain,DC=com"
$groupsOU      = "OU=Justice League,OU=Space Cops,DC=domain,DC=com"

$jsonPath = "Z:\JSONS\JLU\ad-data.json"
$logPath  = "Z:\Logs\JLU ad-data-export.log"

# ==============================
# LOGGING FUNCTION
# ==============================
function Write-Log {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )

    $timestamp = Get-Date -Format "MM-dd-yyyy HH:mm:ss"
    $logEntry = "$timestamp [$Level] $Message"

    Write-Host $logEntry
    Add-Content -Path $logPath -Value $logEntry
}

# ==============================
# SCRIPT START
# ==============================
Write-Log "========================================"
Write-Log "AD JSON export script started"
Write-Log "Running as: $(whoami)"

try {

    # ==============================
    # GET DEPARTMENT OUs
    # ==============================
    Write-Log "Querying Department OUs from $departmentOU"

    $ous = Get-ADOrganizationalUnit `
        -SearchBase $departmentOU `
        -SearchScope OneLevel `
        -Filter * |
    Select-Object Name, DistinguishedName

    Write-Log "Found $($ous.Count) department OUs"

    # ==============================
    # GET SECURITY GROUPS
    # ==============================
    Write-Log "Querying Security Groups from $groupsOU"

    $groups = Get-ADGroup `
        -SearchBase $groupsOU `
        -SearchScope Subtree `
        -Filter 'GroupCategory -eq "Security"' |
    Select-Object Name, DistinguishedName

    Write-Log "Found $($groups.Count) security groups"

    # ==============================
    # BUILD JSON OBJECT
    # ==============================
    Write-Log "Building JSON structure"

    $data = @{
        departments = $ous | ForEach-Object {
            @{
                dn   = $_.DistinguishedName
                name = $_.Name
            }
        }

        groups = $groups | ForEach-Object {
            @{
                dn   = $_.DistinguishedName
                name = $_.Name
            }
        }
    }

    # ==============================
    # EXPORT JSON
    # ==============================
    Write-Log "Exporting JSON to $jsonPath"

    $data |
        ConvertTo-Json -Depth 3 |
        Out-File $jsonPath -Encoding UTF8

    # ==============================
    # VALIDATION
    # ==============================
    if (Test-Path $jsonPath) {

        $fileSize = (Get-Item $jsonPath).Length

        Write-Log "JSON export completed successfully"
        Write-Log "Output file size: $fileSize bytes"
    }
    else {
        Write-Log "JSON file was not created" "ERROR"
    }

}
catch {
    Write-Log "FATAL ERROR: $($_.Exception.Message)" "ERROR"
}

Write-Log "Script finished"
Write-Log "========================================"