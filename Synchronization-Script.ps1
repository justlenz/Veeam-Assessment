$date = Get-Date -Format yyyy-MM-dd

#Paths
$aSource = "C:\Users\Just\Documents\_Veeam_Assessment\aSource"
$bTarget = "C:\Users\Just\Documents\_Veeam_Assessment\bTarget"
$cLogs = "C:\Users\Just\Documents\_Veeam_Assessment\cLogs"

#Folder Contents
$aSourceFiles = Get-ChildItem -Path $aSource -Recurse -Name
$bTargetFiles = Get-ChildItem -Path $bTarget -Recurse -Name

#Differences
$diffs_left = Compare-Object @($aSourceFiles | Select-Object) @($bTargetFiles | Select-Object) -PassThru | Where-Object {$_.SideIndicator -eq "<="}
$diffs_right = Compare-Object @($aSourceFiles | Select-Object) @($bTargetFiles | Select-Object) -PassThru | Where-Object {$_.SideIndicator -eq "=>"}

echo $diffs_left
echo $diffs_right

#Copy Files From Source
foreach($file in $diffs_left){
    Copy-Item $aSource\$file -Destination $bTarget -Recurse -Force
}

#Delete Files From Target
foreach($file in $diffs_right){
    Remove-Item $bTarget\$file -Recurse
}