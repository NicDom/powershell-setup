Invoke-Expression (&starship init powershell)
Import-Module git-aliases -DisableNameChecking
# Import-Module ZLocation
# Import-Module Utils -DisableNameChecking
# Import-Module PSReadLine -DisableNameChecking
# Import-Module PSFzf -DisableNameChecking

$PROJECTSDIR = "$Home\Projects"
$PROFILEDIR = (Get-Item $PROFILE).Directory.FullName

function fpshdot {
    Set-Location -Path $PROFILEDIR
}

function New-Project {
    $ProjectName = $args[0]
    if ($ProjectName -eq $null) {
        $ProjectName = Read-Host "Project Name"
    }
    # Throw exception no filename was given
    if ($ProjectName -eq "") {
        throw "No project name was given"
    }
    if (Test-Path $PROJECTSDIR\$ProjectName) {
        (Get-ChildItem $PROJECTSDIR\$ProjectName).LastWriteTime = Get-Date
        Write-Host "Project already exists"
    } else {
        New-Item -Path $PROJECTSDIR\$ProjectName -ItemType Directory
        Set-Location -Path $PROJECTSDIR\$ProjectName
    }
}

function Backup-Dir ($Dir)
{
    $DirName = Split-Path $Dir -Leaf
    # append date to backup dir name and .bak
    $BackupDir = $DirName + "_" + (Get-Date -Format "yyyy-MM-dd") + ".bak"
    if (Test-Path $BackupDir) {
        Write-Host "Backup $BackupDir already exists"
    } else {
        Copy-Item -Path $Dir -Destination $BackupDir -Recurse -Force
    }
}

function FuzzyRemove-Project
{
    Get-ChildItem $PROJECTSDIR -Attributes Directory | Invoke-Fzf | Remove-Item -Recurse -Force
}

function Open-VSCode {
    code -n .
}

function Open-Explorer {
    explorer.exe .
}

function Edit-Profile {
    code $PROFILEDIR\Microsoft.PowerShell_profile.ps1
}

function fprdir {
    Set-Location -Path $PROJECTSDIR
}

# function fprjui {
#     $MenuOptions = Get-ChildItem -Path $PROJECTSDIR
#     $SelectedProject = Create-Menu -MenuTitle "Projects" -MenuOptions $MenuOptions
#     Clear-Host
#     Set-Location -Path $SelectedProject
# }

function GoTo-Project {
    Get-ChildItem $PROJECTSDIR -Attributes Directory | Invoke-Fzf | Set-Location
}

function Module-Imported {
    $Module = $args[0]
    $ModuleImported = Get-Module -ListAvailable | Where-Object { $_.Name -eq $Module }
    if ($ModuleImported) {
        return $true
    } else {
        return $false
    }
}

function MyImport-Module {
    $Module = $args[0]
    if (Module-Imported $Module) {
        # Write-Host "Module already imported"
    } else {
        Write-Host "Importing module $Module"
        Import-Module $Module
    }
}

function Create-File {
    $FileName = $args[0]
    if ($FileName -eq $null) {
        $FileName = Read-Host "File Name"
    }
    # Throw exception no filename was given
    if ($FileName -eq "") {
        throw "No filename was given"
    }
    if (Test-Path $FileName) {
        (Get-ChildItem $FileName).LastWriteTime = Get-Date
        Write-Host "File already exists"
    } else {
        New-Item -Path $FileName -ItemType File
    }
}

function Create-Files {
    $Files = $args[0]
    foreach ($File in $Files) {
        Create-File $File
    }
}

function Enable-PSFzfAlias {
    Set-PsFzfOption -EnableAliasFuzzyEdit
    Set-PsFzfOption -EnableAliasFuzzyFasd
    Set-PsFzfOption -EnableAliasFuzzyHistory
    Set-PsFzfOption -EnableAliasFuzzyZLocation
}

function Import-PSFzf {
    MyImport-Module "PSReadLine"
    MyImport-Module "PSFzf"
}

function Import-ZLocation {
    MyImport-Module "ZLocation"
    Set-PsFzfOption -EnableAliasFuzzyZLocation
}

function Fzf-Import {
    # Import-PSFzfS
    Get-ChildItem $env:PSModulePath.split(";") -Attributes Directory | Invoke-Fzf | Import-Module
}


function Fuzzy-Edit {
    Get-ChildItem . -Recurse -Attributes !Directory | Invoke-Fzf | % { code $_ }
}

function Fuzzy-Ripgrep {
    $SearchTerm = $args[0]
    if ($SearchTerm -eq $null) {
        $SearchTerm = Read-Host "Search Term"
    }
    Invoke-PsFzfRipgrep -SearchString $SearchTerm
}

function View-PathEnv {
    $PathEnv = $env:Path.split(";")
    # $PathEnv | Out-GridView
    echo $PathEnv
}

#
# Aliases
#

Set-Alias -Name zimp -Value Import-ZLocation
Set-Alias -Name touch -Value Create-Files
Set-Alias -Name fe -Value Fuzzy-Edit
Set-Alias -Name ncd -Value Open-VSCode
Set-Alias -Name cdn -Value Fuzzy-Edit
Set-Alias -Name ep -Value Open-Explorer
Set-Alias -Name profile -Value Edit-Profile
Set-Alias -Name pshdot -Value fpshdot
Set-Alias -Name pr -Value fprdir
Set-Alias -Name prj -Value GoTo-Project
Set-Alias -Name psf -Value Import-PSFzf
Set-Alias -Name imp -Value Fzf-Import
Set-Alias -Name rgf -Value Fuzzy-Ripgrep
Set-Alias -Name npr -Value New-Project
Set-Alias -Name rpr -Value FuzzyRemove-Project
Set-Alias -Name bak -Value Backup-Dir
Set-Alias -Name path -Value View-PathEnv
Set-Alias -Name lg -Value lazygit

#
# Misc Aliases
#

Set-Alias -Name l -Value ls
Set-Alias -Name la -Value ls
