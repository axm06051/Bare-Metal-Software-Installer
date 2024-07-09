# InstallBareMetalSoftware.ps1

# Function to check for admin rights
function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

# Function to add directory to PATH
function Add-ToPath {
    param([string]$Directory)
    $path = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine)
    if ($path -notlike "*$Directory*") {
        [Environment]::SetEnvironmentVariable("Path", "$path;$Directory", [EnvironmentVariableTarget]::Machine)
    }
}

# Check for admin rights
if (-not (Test-Admin)) {
    Start-Process powershell.exe "-File `"$PSCommandPath`"" -Verb RunAs
    exit
}

try {
    # Create directory
    $installDir = "C:\Program Files\Bare Metal Software"
    New-Item -ItemType Directory -Force -Path $installDir | Out-Null
    Write-Host "Installation directory created: $installDir" -ForegroundColor Cyan

    # Search for executables
    $searchLocations = @(
        $PWD.Path,
        [Environment]::GetFolderPath("UserProfile") + "\Downloads"
    )

    $executablesMoved = @()

    foreach ($location in $searchLocations) {
        Write-Host "Searching in: $location" -ForegroundColor Cyan
        if (Test-Path $location) {
            $files = Get-ChildItem -Path $location -Filter "bare*.exe"
            foreach ($file in $files) {
                $destPath = Join-Path $installDir $file.Name
                Move-Item -Path $file.FullName -Destination $destPath -Force
                $executablesMoved += $destPath
                Write-Host "Moved: $($file.Name)" -ForegroundColor Green
            }
            if ($files.Count -gt 0) {
                break  # Exit the loop if files are found and moved
            }
        }
        else {
            Write-Host "Warning: Directory $location does not exist." -ForegroundColor Yellow
        }
    }

    if ($executablesMoved.Count -eq 0) {
        throw "No 'bare*.exe' files found in the searched locations."
    }

    # Add to PATH
    Add-ToPath $installDir
    Write-Host "Added to PATH: $installDir" -ForegroundColor Cyan

    # Verify installation
    $newPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine)
    if ($newPath -notlike "*$installDir*") {
        throw "Failed to add directory to PATH."
    }

    foreach ($exe in $executablesMoved) {
        if (-not (Test-Path $exe)) {
            throw "Failed to move $exe to installation directory."
        }
    }

    Write-Host "Installation completed successfully." -ForegroundColor Green
    Write-Host "Moved files: $($executablesMoved -join ', ')" -ForegroundColor Cyan
}
catch {
    Write-Host "Error: $_" -ForegroundColor Red
    
    # Revert changes
    foreach ($exe in $executablesMoved) {
        if (Test-Path $exe) {
            Move-Item -Path $exe -Destination $searchLocations[0] -Force
            Write-Host "Reverted: $exe" -ForegroundColor Yellow
        }
    }

    if (Test-Path $installDir) {
        Remove-Item -Path $installDir -Recurse -Force
        Write-Host "Removed installation directory: $installDir" -ForegroundColor Yellow
    }

    $path = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine)
    $path = ($path.Split(';') | Where-Object { $_ -ne $installDir }) -join ';'
    [Environment]::SetEnvironmentVariable("Path", $path, [EnvironmentVariableTarget]::Machine)
    Write-Host "Removed installation directory from PATH" -ForegroundColor Yellow

    Write-Host "Installation failed. All changes have been reverted." -ForegroundColor Yellow
}
