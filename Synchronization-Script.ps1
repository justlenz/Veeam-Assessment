#Call The Function From The PowerShell Console Like: Sync-Folder C:\Temp\Source C:\Temp\Target C:\Temp\Logs

function Sync-Folder{

    #Path Parameters
    param(
        [parameter(Mandatory)]
        [String]$aSource,
        [String]$bTarget,
        [String]$cLogs
    )

    #---Variables----------------------------------------------------------------------------------------------------------------------------------------

    #Dates
    $date1 = Get-Date -Format yyyy-MM-dd
    $date2 = (Get-Date).toString("yyyy-MM-dd HH:mm:ss")

    #Paths
    #$aSource = "C:\Users\Just\Documents\_Veeam_Assessment\aSource"
    #$bTarget = "C:\Users\Just\Documents\_Veeam_Assessment\bTarget"
    #$cLogs = "C:\Users\Just\Documents\_Veeam_Assessment\cLogs\"

    #Create Logfile
    $logFile = $cLogs + "LOG-Sync_" + $date1 + ".txt"
    "Synchronization from " + $date2 | Add-Content $logFile
    "----------------------------------------" | Add-Content $logFile

    #Get Folder Contents
    $aSourceFiles = Get-ChildItem -Path $aSource -Recurse -Name
    $bTargetFiles = Get-ChildItem -Path $bTarget -Recurse -Name

    #Compare Differences
    $diffs_left = Compare-Object @($aSourceFiles | Select-Object) @($bTargetFiles | Select-Object) -PassThru | Where-Object {$_.SideIndicator -eq "<="}
    $diffs_right = Compare-Object @($aSourceFiles | Select-Object) @($bTargetFiles | Select-Object) -PassThru | Where-Object {$_.SideIndicator -eq "=>"}

    #---Functions----------------------------------------------------------------------------------------------------------------------------------------

    #Test Input Paths
    if(Test-Path $aSource, $bTarget, $cLogs){
    Write-Output "Paths are valid"

    #Copy Files From Source
    foreach($file in $diffs_left){
        Copy-Item $aSource\$file -Destination $bTarget -Recurse -Force

        #Output String
        $outString = $date2 + " COPY " + $aSource + "\" + $file + " TO " + $bTarget

        #Console Output
        Write-Host $outString -ForegroundColor Yellow 

        #Write To Log
        $outString | Add-Content $logFile
        "-------------------" | Add-Content $logFile
        }

    #Delete Files From Target
    foreach($file in $diffs_right){
        Remove-Item $bTarget\$file -Recurse
    
        #Output String
        $outString = $date2 + " DELETE " + $bTarget + "\" + $file

        #Console Output
        Write-Host $outString -ForegroundColor Red

        #Write To Log
        $outString | Add-Content $logFile
        "-------------------" | Add-Content $logFile
        }

    }
    else{Write-Output "At least 1 path is not valid!"}
}