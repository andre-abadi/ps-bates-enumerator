# By Andre Abadi

# treat all non-terminating errors as terminating errors
$ErrorActionPreference = "STOP"


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


# starting bits & info
echo "`nRecursive Document Enumerator by Andre Abadi."
echo "`n  Recurses this and all subdirectories"
echo "    and lists all files with Bates numbers."
echo "    EG: ABC.0001.0001.0001.pdf"
echo "  Puts them in a file called '$($file)'"
echo "    alongside this script."
echo "  Puts their DocIDs in a file called '$($documents)'"
echo "    alongside this script."

echo "`nThe following files were found with Bates Numbers:"
echo "==================================================="


# recursively find all files in this and lower directories
try {
    $allFiles =  Get-ChildItem -Recurse -File
}
# catch the old path-too-long error, give feedback and exit
catch [System.IO.PathTooLongException]
{
    echo "`nOne of the specified path, file name, or both are too long."
    echo "  The fully qualified file name must be less than 260 characters,"
    echo "  and the directory name must be less than 248 characters."
    echo "`nExiting because otherwise results would be incomplete."
}
# regurgitate any other errors
catch {  
    $_
}

# filter to regex matches
$regexHits = echo $allFiles | Where-Object {$_.Name -match '(.*)(.{3})\.(\d{4})\.(\d{4})\.(\d{4})(.*(?=\.))\.(.*)'}

# trim down to just filenames
$hitFileNames = echo $regexHits | Select-Object -ExpandProperty Name

# iterate through each hit
foreach ($instance in $hitFileNames)
{
    # add this instance to the list of found files
    $foundFiles.Add($instance) | Out-Null

    # write the name of the found file
    echo $instance

    # run fresh regex for a per-instance Matches table
    $instance -match '(.*)(.{3})\.(\d{4})\.(\d{4})\.(\d{4})(.*(?=\.))\.(.*)'| Out-Null

    # parse the DocID from the regex group matches
    $instanceDocID = "$($Matches[2]).$($Matches[3]).$($Matches[4]).$($Matches[5])" 

    # add the DocID to the list
    $foundDocIDs.Add($instanceDocID) | Out-Null

}

echo "==================================================`n"


if ($foundFiles.Count -gt 0)
{
    # warn if overwriting old file
    if (Test-Path $filePath)
    {
        echo "Overwriting old '$($file)'"

        Remove-Item -Path $filePath -Force | Out-Null
    }

    echo "Writing found files to '$($file)'"

    # iterate through array and write output
    foreach ($instance in $foundFiles)
    {
        Add-Content -Path $filePath -Value $instance

    }

    echo "Wrote $($foundFiles.Count) files to '$($file)'`n"

}

if ($foundDocIDs.Count -gt 0)
{
    # warn if overwriting old file
    if (Test-Path $documentsPath)
    {
        echo "Overwriting old '$($documents)'"

        Remove-Item -Path $documentsPath -Force | Out-Null
    }

    echo "Writing found DocIDs to '$($documents)'"

    foreach ($instance in $foundDocIDs)
    {
        Add-Content -Path $documentsPath -Value $instance
    }

    echo "Wrote $($foundDocIDs.Count) Document IDs to '$($documents)'`n"

}


# ending bits
Read-Host "Press ENTER to exit"