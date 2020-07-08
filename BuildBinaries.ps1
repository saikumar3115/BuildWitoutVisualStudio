function SystemLayer
{
    param
    (
        [parameter(Mandatory=$true)]
        [String] $path,
       
        [parameter(Mandatory=$false)]
        [bool] $clean = $true,

        [parameter(Mandatory=$true)]
        [bool] $DoYouWantToCopy = $true,

        [parameter(Mandatory=$true)]
        [String] $Destination 
         
    )
    process
    {
        $startBuildtime=(Get-Date).tostring("dd-MM-yyyy-hh-mm-ss")

        $ArchiveFolder="binGlobe.Net-"+$startBuildtime
        
        $ArchiveSource="bin-"+$startBuildtime

       [bool]$CreateFolder=true

        Write-Host "Your Build Process is started " -ForegroundColor DarkRed
         
        $msBuildExe = 'C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\MSBuild\Current\Bin\amd64\msbuild.exe'

         
        Write-Host "Please Wait......" -foregroundcolor Red

        Write-Host "Taking backup of your bin" -foregroundcolor green
        
        New-Item -Path $path -Name $ArchiveSource -ItemType "directory"

        Copy-Item -Force -Path $path\bin\*.* -Destination $path\$ArchiveSource\ -Recurse

     ##Corecollection.sln
           if ($clean) {
               Write-Host "Cleaning $($path)\CoreCollection.sln" -foregroundcolor Red
               & "$($msBuildExe)" "$($path)\CoreCollection.sln" /t:Clean /m
           }
   
           Write-Host "Building $($path)\CoreCollection.sln" -foregroundcolor green
           & "$($msBuildExe)" "$($path)\CoreCollection.sln" /t:Build /m
   
     ##SystemLayer.sln
   
           if ($clean) {
               Write-Host "Cleaning $($path)\SystemLayer.sln" -foregroundcolor Red
               & "$($msBuildExe)" "$($path)\SystemLayer.sln" /t:Clean /m
           }
   
           Write-Host "Building $($path)\SystemLayer.sln" -foregroundcolor green
           & "$($msBuildExe)" "$($path)\SystemLayer.sln" /t:Build /m
   
       
    ##LayoutCollection.sln
            if ($clean) {
                   Write-Host "Cleaning $($path)\LayoutCollection.sln" -foregroundcolor Red
                   & "$($msBuildExe)" "$($path)\LayoutCollection.sln" /t:Clean /m
               }
   
           Write-Host "Building $($path)\LayoutCollection.sln" -foregroundcolor green
           & "$($msBuildExe)" "$($path)\LayoutCollection.sln" /t:Build /m
   
    ##ECL.sln
          if ($clean) {
                   Write-Host "Cleaning $($path)\ECL.sln" -foregroundcolor Red
                   & "$($msBuildExe)" "$($path)\ECL.sln" /t:Clean /m
               }
   
           Write-Host "Building $($path)\ECL.sln" -foregroundcolor green
           & "$($msBuildExe)" "$($path)\ECL.sln" /t:Build /m
   
   ##SystemLayer2.sln
            if ($clean) {
                   Write-Host "Cleaning $($path)\SystemLayer2.sln" -foregroundcolor Red
                   & "$($msBuildExe)" "$($path)\SystemLayer2.sln" /t:Clean /m
               }
   
           Write-Host "Building $($path)\SystemLayer2.sln" -foregroundcolor green
           & "$($msBuildExe)" "$($path)\SystemLayer2.sln" /t:Build /m
   
            
         Write-Host "Your Build Process is finished @" $(get-date)  -ForegroundColor Red   
       
         Write-Host "Your Build Process is started @ $($startBuildtime) and  finished @" $((Get-Date).tostring("dd-MM-yyyy-hh-mm-ss"))  -foregroundcolor green
    
         Write-Host "Please wait while we are copying the latest binaries" -foregroundcolor green
        
        if ($DoYouWantToCopy) {

             if (-not (Test-Path -Path $Destination\binGlobe.Net\ -PathType Container)){
               try { 

                   New-Item -Path $Destination\binGlobe.Net\ -ItemType Directory -ErrorAction Stop | Out-Null #-Force

                   }
               catch {
                 Write-Error -Message "Unable to create directory $Destination\binGlobe.Net\. Error was: $_" -ErrorAction Stop
                 } 
             }

             Else{
                
                New-Item -Path $Destination -Name $ArchiveFolder -ItemType "directory"
         
                Copy-Item -Path $Destination\binGlobe.Net\* -Destination $Destination\$ArchiveFolder\  -Force -Recurse -Verbose 
                
                }
        

           Remove-Item -Force -Path $Destination\binGlobe.Net\* -Recurse
         
        if (-not (Test-Path -Path $Destination\binGlobe.Net\ -PathType Container)){
            try {
                New-Item -Path $Destination\binGlobe.Net\ -ItemType Directory -ErrorAction Stop | Out-Null #-Force
            }
            catch {
                 Write-Error -Message "Unable to create directory '$DirectoryToCreate'. Error was: $_" -ErrorAction Stop
            }
            
          }
         
           Copy-Item -Force -Path $path\bin\* -Destination $Destination\binGlobe.Net\  -Force -Recurse -Verbose 
           Write-Host "Binaries copied" -foregroundcolor green

       }
 
        
    }

}
