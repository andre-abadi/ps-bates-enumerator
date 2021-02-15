# By Andre Abadi

$file = "bates-file-list.txt"

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




# check if text file already exists
$exists = Test-Path "$($mydir)\$($file)"
if ($exists) {
    echo "Overwriting old '$($file)'`n"
}



echo "The following files were found with Bates Numbers:"
echo "==================================================="

# main function
  # recursively find all files in this and lower directories
  Get-ChildItem -Recurse -File | `
      # regex for only files with bates  number at start
      Where-Object {$_.Name -match '(.{3}\.\d{4}\.\d{4}\.\d{4})'} | `
          # get those file names
          Select-Object -ExpandProperty Name | `
              # spit them out the command line as well as dumping to text file
              Tee-Object -FilePath $file 


# ending bits
echo "==================================================`n"
echo "Wrote to '$($file)`n"
Read-Host "Press ENTER to exit"