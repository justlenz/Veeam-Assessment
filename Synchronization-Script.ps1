#Folder Paths
$aSource = "C:\Users\Just\Documents\_Veeam_Assessment\aSource"
$bTarget = "C:\Users\Just\Documents\_Veeam_Assessment\bTarget"

#Logs Path
$cLogs = "C:\Users\Just\Documents\_Veeam_Assessment\cLogs"

#Current Date
$dDate = Get-Date -Format yyyy-MM-dd

#Check Target Folder
if(Test-Path $bTarget\$dDate){}
    else{New-Item -Path $bTarget\$dDate -ItemType directory}

#Copy Items from source to target
foreach($file in $aSource){
    Copy-Item $file\* -Destination $bTarget\$dDate -Recurse -Force
}

