# ==============================
# CONFIGURATION
# ==============================
$ouPath = "OU=Heroes,OU=Justice League,OU=Space Cops,DC=domain,DC=com"  # Define the specific OU where the groups will be created
$logPath = "Z:\Logs\JLU unique group-creation.log"  # Log file path

# Define the ArrayList of group names
$groupsToCreate = @(
    "Detriot",
    "Ditko",
    "Haney",
    "International",
    "Justice Society of America",
    "Satellite",
    "Simonson",
    "The Founding Seven",
    "The Seven Soldiers of Victory"
)

# ==============================
# LOGGING FUNCTION
# ==============================
function Write-Log {
    param (
        [string]$Message,
        [string]$Level = "INFO"
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $entry = "$timestamp [$Level] $Message"

    Write-Host $entry
    Add-Content -Path $logPath -Value $entry
}

# ==============================
# SCRIPT START
# ==============================
Write-Log "========================================"
Write-Log "Security Group creation script started"
Write-Log "Running as: $(whoami)"

foreach ($groupName in $groupsToCreate) {

    # Check if the group already exists
    $existingGroup = Get-ADGroup -Filter {Name -eq $groupName} -SearchBase $ouPath -ErrorAction SilentlyContinue

    if ($existingGroup) {
        Write-Log "Group '$groupName' already exists in $ouPath." "WARN"
    } else {
        try {
            # Create the group
            New-ADGroup -Name $groupName `
                -GroupCategory Security `
                -GroupScope Global `
                -Path $ouPath `
                -Description "$groupName security group" `
                -ErrorAction Stop

            Write-Log "Created group '$groupName' in $ouPath."
        }
        catch {
            Write-Log "Error creating group '$groupName' in {$ouPath}: $($_.Exception.Message)" "ERROR"
        }
    }
}

Write-Log "========================================"
Write-Log "Security Group creation script completed"