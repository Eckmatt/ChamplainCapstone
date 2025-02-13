﻿#Get General Utils
$generalutils_path = Get-ChildItem -Path C:\Users\$env:UserName -Filter backupbuddy_generalutils.ps1 -Recurse | %{$_.FullName}
Import-Module $generalutils_path

#resolving config filepath
$configpath = ResolveFilePath -File backupbuddy_config.json


#Allows the user to enter VM names for backup
$looper=1
$BigObject = Get-Content $configpath | ConvertFrom-Json
$targets = $BigObject.vmTargets


while($looper -eq 1){
    $entry = Read-Host -Prompt "Please enter the Full Name of the Virtual Machine you wish to back up, or leave entry blank to exit."
    if($entry -and $targets.Contains($entry)){ 
        Write-Output "Named VM already exists as a target."
    }elseif($entry -and !($targets.Contains($entry))){
        $targets += $entry
    }else{
        $looper=0
    }
}
$BigObject.vmTargets = $targets
$BigObject | Convertto-Json -Depth 100 | Out-File $configpath
