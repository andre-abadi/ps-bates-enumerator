# By Andre Abadi



# starting bits & info
echo "`nRecursive Document Enumerator by Andre Abadi.`n"
echo "Recurses this and all subdirectories"
echo "  and lists all files with Bates numbers."
echo "  EG: ABC.0001.0001.0001.pdf`n"
echo "Puts them in a file called '$($file)'"
echo "  alongside this script.`n"



# ensure this script's executing directory is correct
$mydir = Get-Location
Set-Location -Path $mydir

# initiate an empty arraylist to hold copied files
$foundFiles = [System.Collections.ArrayList]@()

# initiate an empty arraylist to hold copied files
$foundDocIDs = [System.Collections.ArrayList]@()


$file = "enumerated-files.txt"
$filePath = "$($mydir)\$($file)"
$documents = "enumerated-docIDs.txt"
$documentsPath = "$($mydir)\$($documents)"


echo "The following files were found with Bates Numbers:"
echo "==================================================="


# recursively find all files in this and lower directories
$allFiles =  Get-ChildItem -Recurse -File

# filter to regex matches
$regexHits = echo $allFiles | Where-Object {$_.Name -match '(.{3})\.(\d{4})\.(\d{4})\.(\d{4})(.*(?=\.))\.(.*)'}

# trim down to just filenames
$hitFileNames = echo $regexHits | Select-Object -ExpandProperty Name

# iterate through each hit
foreach ($instance in $hitFileNames)
{
    # add this instance to the list of found files
    $foundFiles.Add($instance) | Out-Null

    # write the name of the found file
    echo $instance

    # trim DocID from instance filename
    $instanceDocID = $instance.Substring(0,18)

    # add the DocID to the list
    $foundDocIDs.Add($instanceDocID) | Out-Null

}

echo "==================================================`n"

echo "Preparing output.`n"

if ($foundFiles.Count -gt 0)
{
    # warn if overwriting old file
    if (Test-Path $filePath)
    {
        echo "Overwriting old '$($file)'`n"
        Remove-Item -Path $filePath -Force | Out-Null
    }
    # iterate through array and write output
    foreach ($instance in $foundFiles)
    {
        Add-Content -Path $filePath -Value $instance
    }



}

if ($foundDocIDs.Count -gt 0)
{
    # warn if overwriting old file
    if (Test-Path $documentsPath)
    {
        echo "Overwriting old '$($documents)'`n"
        Remove-Item -Path $documentsPath -Force | Out-Null
    }

    # get just the uniques
    $uniqueDocIDs = echo $foundDocIDs | Sort-Object | Get-Unique


    foreach ($instance in $uniqueDocIDs)
    {
        Add-Content -Path $documentsPath -Value $instance
    }

}


# ending bits
echo "Found $($foundFiles.Count) files and wrote to '$($file)'`n"
echo "Found $($uniqueDocIDs.Count) unique Document IDs and wrote to '$($documents)'`n"
Read-Host "Press ENTER to exit"