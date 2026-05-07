# ==============================
# CONFIGURATION
# ==============================
$inputFile = "Z:\PShell Scripts\JLU\SecurityGroup txts\Org Groups.txt"
$logPath   = "Z:\PShell Scripts\Plumbers\Script Logs\GroupCreation.log"

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
# SCRIPT START
# ==============================
Write-Log "========================================"
Write-Log "Group creation script started"
Write-Log "Running as: $(whoami)"

try {
    # ==============================
    # VALIDATE INPUT FILE
    # ==============================
    if (-not (Test-Path $inputFile)) {
        Write-Log "Input file not found: $inputFile" "ERROR"
        exit
    }

    $lines = Get-Content $inputFile | Where-Object { $_.Trim() -ne "" }

    if ($lines.Count -lt 2) {
        Write-Log "Input file must contain OU + at least one group" "ERROR"
        exit
    }

    # ==============================
    # EXTRACT OU + GROUPS
    # ==============================
    $ouPath = $lines[0].Trim()
    $groupNames = $lines[1..($lines.Count - 1)]

    Write-Log "Target OU: $ouPath"
    Write-Log "Groups to create: $($groupNames.Count)"

    # ==============================
    # VALIDATE OU EXISTS
    # ==============================
    $ouCheck = Get-ADOrganizationalUnit -Identity $ouPath -ErrorAction SilentlyContinue

    if (-not $ouCheck) {
        Write-Log "Invalid OU path: $ouPath" "ERROR"
        exit
    }

    Write-Log "OU validation successful"

    # ==============================
    # CREATE GROUPS
    # ==============================
    foreach ($groupName in $groupNames) {

        $groupName = $groupName.Trim()

        if ([string]::IsNullOrWhiteSpace($groupName)) {
            continue
        }

        Write-Log "Processing group: $groupName"

        try {
            # Check if group already exists (domain-wide)
            $existingGroup = Get-ADGroup -Filter "Name -eq '$groupName'" -ErrorAction SilentlyContinue

            if ($existingGroup) {
                Write-Log "Group already exists: $groupName" "WARN"
                continue
            }

            # Create group
            New-ADGroup `
                -Name $groupName `
                -SamAccountName $groupName `
                -GroupCategory Security `
                -GroupScope Global `
                -Path $ouPath `
                -Description "Security group for $groupName" `
                -ErrorAction Stop

            Write-Log "Created group: $groupName"

        }
        catch {
            Write-Log "Failed creating ${groupName} in ${ouPath}: $($_.Exception.Message)" "ERROR"
        }
    }

}
catch {
    Write-Log "FATAL ERROR: $($_.Exception.Message)" "ERROR"
}

Write-Log "Script completed"
Write-Log "========================================"