# ==============================
# CONFIGURATION
# ==============================
$baseOU = "OU=Space Cops,DC=domain,DC=com"  # Base OU where all company OUs reside
$logPath = "Z:\Logs\group-creation.log"  # Path to store logs

$departments = @(
    "IT",
    "HR",
    "Sales",
    "Engineering",
    "Legal"
)

$groupTemplates = @(
    "Users",
    "Managers",
    "ReadOnly"
)

# ==============================
# LOGGING FUNCTION
# ==============================
function Write-Log {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $entry = "$timestamp [$Level] $Message"

    Write-Host $entry
    Add-Content -Path $logPath -Value $entry
}

# ==============================
# START
# ==============================
Write-Log "========================================"
Write-Log "Group provisioning script started"
Write-Log "Running as: $(whoami)"

try {
    # Get all Company OUs
    $companies = Get-ADOrganizationalUnit -SearchBase $baseOU -Filter * |
        Select-Object -ExpandProperty DistinguishedName

    Write-Log "Found $($companies.Count) company OUs"

    foreach ($companyOU in $companies) {

        # Extract Company Name from DN
        $companyName = ($companyOU -split ",")[0] -replace "OU=", ""

        Write-Log "Processing Company: $companyName"

        foreach ($department in $departments) {

            # Build Department OU path
            $departmentOU = "OU=$department,$companyOU"

            try {
                Get-ADOrganizationalUnit -Identity $departmentOU -ErrorAction Stop | Out-Null
            }
            catch {
                Write-Log "Missing Department OU: $departmentOU" "ERROR"
                continue
            }

            Write-Log "Processing Department: $department"

            foreach ($template in $groupTemplates) {

                # ==============================
                # UNIQUE GROUP NAMING STRATEGY
                # ==============================
                $groupName = "${companyName}_${department}_${template}"

                # Check if group already exists anywhere in domain
                $existing = Get-ADGroup -Filter "Name -eq '$groupName'" -ErrorAction SilentlyContinue

                if ($existing) {
                    Write-Log "Group already exists: $groupName" "WARN"
                    continue
                }

                try {
                    New-ADGroup `
                        -Name $groupName `
                        -GroupCategory Security `
                        -GroupScope Global `
                        -Path $departmentOU `
                        -Description "$template group for $department in $companyName" `
                        -ErrorAction Stop

                    Write-Log "Created group: $groupName in $departmentOU"
                }
                catch {
                    Write-Log "Failed creating $groupName in ${departmentOU}: $($_.Exception.Message)" "ERROR"
                }
            }
        }
    }

    Write-Log "Script completed successfully"
}
catch {
    Write-Log "FATAL ERROR: $($_.Exception.Message)" "ERROR"
}

Write-Log "========================================"
