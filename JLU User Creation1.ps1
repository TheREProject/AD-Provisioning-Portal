# ==============================
# ACTIVE DIRECTORY USER PROVISIONING SCRIPT
# ==============================

# ========= CONFIG =========
$csvPath = "Z:\CSVs\User Creation\JLU\users.csv"
$logPath = "Z:\Logs\JLUuser-provisioning.log"

# ========= LOGGING FUNCTION =========
function Write-Log {

    param(
        [string]$Message,
        [string]$Level = "INFO"
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $logEntry = "$timestamp [$Level] $Message"

    Add-Content -Path $logPath -Value $logEntry
}

# ==============================
# SCRIPT START
# ==============================
Write-Log "========================================"
Write-Log "User Provisioning Script Started"
Write-Log "Running as: $(whoami)"

try {

    # ========= LOAD AD MODULE =========
    Import-Module ActiveDirectory -ErrorAction Stop

    Write-Log "Active Directory module loaded successfully"

    # ========= VERIFY CSV EXISTS =========
    if (!(Test-Path $csvPath)) {

        Write-Log "CSV file not found at $csvPath" "ERROR"
        throw "CSV file missing"
    }

    Write-Log "CSV located successfully"

    # ========= IMPORT CSV =========
    $users = Import-Csv $csvPath

    Write-Log "Loaded $($users.Count) users from CSV"

    # ==============================
    # PROCESS EACH USER
    # ==============================
    foreach ($user in $users) {

        Write-Log "----------------------------------------"
        Write-Log "Processing user: $($user.Username)"

        try {

            # ==============================
            # DEBUG LOGGING
            # ==============================
            Write-Log "FirstName = '$($user.FirstName)'"
            Write-Log "LastName = '$($user.LastName)'"
            Write-Log "Username = '$($user.Username)'"
            Write-Log "DisplayName = '$($user.DisplayName)'"
            Write-Log "EmailAddress = '$($user.EmailAddress)'"
            Write-Log "DepartmentDN = '$($user.DepartmentDN)'"
            Write-Log "SecurityGroupsDN = '$($user.SecurityGroupsDN)'"

            # ==============================
            # REQUIRED FIELD VALIDATION
            # ==============================
            if (
                -not $user.FirstName `
                -or -not $user.LastName `
                -or -not $user.Username `
                -or -not $user.DisplayName `
                -or -not $user.EmailAddress `
                -or -not $user.DepartmentDN `
                -or -not $user.Password
            ) {

                Write-Log "Missing required fields for $($user.Username)" "ERROR"
                continue
            }

            # ==============================
            # CHECK IF USER EXISTS
            # ==============================
            $existingUser = Get-ADUser `
                -Filter "SamAccountName -eq '$($user.Username)'" `
                -ErrorAction SilentlyContinue

            if ($existingUser) {

                Write-Log "User already exists: $($user.Username)" "WARN"
                continue
            }

            # ==============================
            # RESOLVE OU
            # ==============================
            $ouPath = $user.DepartmentDN.Trim()

            Write-Log "Resolved OU Path: $ouPath"

            # ==============================
            # VALIDATE OU
            # ==============================
            try {

                Get-ADOrganizationalUnit `
                    -Identity $ouPath `
                    -ErrorAction Stop | Out-Null

                Write-Log "OU validated successfully"

            }
            catch {

                Write-Log "Invalid OU Path: $ouPath" "ERROR"
                continue
            }

            # ==============================
            # CREATE USER
            # ==============================
            New-ADUser `
                -Name $user.DisplayName `
                -DisplayName $user.DisplayName `
                -GivenName $user.FirstName `
                -Surname $user.LastName `
                -SamAccountName $user.Username `
                -UserPrincipalName $user.EmailAddress `
                -EmailAddress $user.EmailAddress `
                -Path $ouPath `
                -AccountPassword (
                    ConvertTo-SecureString `
                        $user.Password `
                        -AsPlainText `
                        -Force
                ) `
                -Enabled $true `
                -ChangePasswordAtLogon $true `
                -ErrorAction Stop

            Write-Log "User created successfully: $($user.Username)"

            # ==============================
            # PROCESS GROUPS
            # ==============================
            if ($user.SecurityGroupsDN) {

                $groups = $user.SecurityGroupsDN -split ';'

                foreach ($group in $groups) {

                    $groupDN = $group.Trim()

                    if (-not $groupDN) {
                        continue
                    }

                    Write-Log "Processing group: $groupDN"

                    # ==============================
                    # VALIDATE GROUP
                    # ==============================
                    try {

                        Get-ADGroup `
                            -Identity $groupDN `
                            -ErrorAction Stop | Out-Null

                        Write-Log "Validated group: $groupDN"

                    }
                    catch {

                        Write-Log "Invalid group DN: $groupDN" "ERROR"
                        continue
                    }

                    # ==============================
                    # ADD USER TO GROUP
                    # ==============================
                    try {

                        Add-ADGroupMember `
                            -Identity $groupDN `
                            -Members $user.Username `
                            -ErrorAction Stop

                        Write-Log "Added $($user.Username) to group: $groupDN"

                    }
                    catch {

                        Write-Log "Failed to add $($user.Username) to group: $groupDN -- $($_.Exception.Message)" "ERROR"
                    }
                }
            }

            Write-Log "Finished processing user: $($user.Username)"

        }
        catch {

            Write-Log "Error processing '$($user.Username)': $($_.Exception.Message)" "ERROR"
        }
    }

    Write-Log "User Provisioning Script Completed Successfully"

}
catch {

    Write-Log "FATAL ERROR: $($_.Exception.Message)" "ERROR"
}

Write-Log "Script Finished"
Write-Log "========================================"