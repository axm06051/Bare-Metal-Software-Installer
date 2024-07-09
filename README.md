# Bare Metal Software Installation Guide

This guide will help you install Bare Metal Software tools on your Windows computer using a PowerShell script.

## Prerequisites

1. Windows operating system
2. PowerShell (comes pre-installed on modern Windows systems)
3. Administrator privileges on your computer

## Installation Steps

### 1. Download the Software

- Visit the [Bare Metal Software website > Tools for Computer Professionals](https://www.baremetalsoft.com/index.php)
- Download the desired .exe files (e.g., baregrep.exe, baretail.exe)
- Save these files to your Downloads folder or any convenient location

### 2. Download the Installer Script

- Download the `InstallBareMetalSoftware.ps1` script
- Save it to a location you can easily access, such as your Downloads folder

### 3. Run the Installer

1. Right-click on the Windows Start button and select "Windows PowerShell (Admin)" to open PowerShell with administrator privileges
2. Navigate to the folder containing the `InstallBareMetalSoftware.ps1` script
   - For example, if it's in your Downloads folder, type: `cd ~\Downloads`
3. Run the script by typing: `.\InstallBareMetalSoftware.ps1`
4. Follow any on-screen prompts

### 4. Verify Installation

- After successful installation, you should see a message saying "Installation completed successfully."
- The script will display which files were moved

## What the Script Does

The `InstallBareMetalSoftware.ps1` script automates the installation process by:

1. Creating a new directory: `C:\Program Files\Bare Metal Software`
2. Searching for Bare Metal Software executables (files starting with "bare" and ending in .exe) in your current directory and Downloads folder
3. Moving found executables to the newly created directory
4. Adding the new directory to your system's PATH, allowing you to run the tools from any location in the command line
5. Verifying the installation was successful

## Using the Installed Software

After installation, you can use the Bare Metal Software tools from any command prompt or PowerShell window. For example:

- To use BareGrep, open a command prompt and type: `baregrep [options]`
- For usage instructions, refer to Bare Metal Software's CLI documentation, for example: <https://www.baremetalsoft.com/baregrep/usage.php>

## Troubleshooting

- If you encounter any errors during installation, the script will attempt to revert any changes made
- Make sure you're running PowerShell as an administrator
- Ensure the .exe files you want to install are in your Downloads folder or the same folder as the script before running it

## Note

This script is designed to simplify the installation process. It will only install .exe files that start with "bare" to ensure it doesn't move unrelated files. If you have any concerns, please review the script contents before running.
