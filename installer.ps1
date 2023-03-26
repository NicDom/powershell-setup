# Powershell Setup Installer
# Usage: powershell -ExecutionPolicy Bypass -File installer.ps1

# check if $PROFILE exists, if not clone repo


if (!(Test-Path $PROFILE)) {
    $PROFILEDIR = "$HOME\Documents\PowerShell"
    git clone https://github.com/NicDom/powershell-setup $PROFILEDIR
} else {
    echo "Profile already exists."
    $PROFILEDIR = (Get-Item $PROFILE).Directory.FullName
    echo "Trying to pull latest changes from repo..."
    # if $PROFILE exists, pull latest changes. If failes, echo error
    if (!(git -C $PROFILEDIR pull)) {
        echo "Error pulling latest changes from repo."
    }
    else {
        echo "Successfully pulled latest changes from repo."
    }
    # exit script
    exit
}

# remove readme.md, LICENSE .git folder and .gitignore

Remove-Item $PROFILEDIR\README.md
Remove-Item $PROFILEDIR\LICENSE
Remove-Item $PROFILEDIR\.gitignore
# Remove-Item $PROFILEDIR\.git -Recurse