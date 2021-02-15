# By Andre Abadi


# starting bits & info
echo "`nRecursive Document Enumerator by Andre Abadi.`n"
echo "Recurses this and all subdirectories"
echo "  and lists all files with Bates numbers."
echo "  EG: ABC.0001.0001.0001.pdf`n"
echo "Puts them in a file called 'Document_ID.txt'"
echo "  alongside this script.`n"



# ensure this script's executing directory is correct
$mydir = Get-Location
Set-Location -Path $mydir


# check if text file already exists
#$exists = Test-Path $mydir\Document_ID.txt
#if ($exists) {
#    echo "'Document_ID.txt' already exists!"
#    Read-Host "Press ENTER to  overwrite or CTRL+C to exit"
#    echo "Overwriting 'Document_ID.txt"
#    echo "`n===============================================`n"
#} else {
#    echo "===============================================`n"
#}
echo "The following files were found:"
echo "==============================================="

# main function
  # recursively find all files in this and lower directories
  Get-ChildItem -Recurse -File | `
      # regex for only files with bates  number at start
      Where-Object {$_.Name -match '(.{3}\.\d{4}\.\d{4}\.\d{4})'} | `
          # get those file names
          Select-Object -ExpandProperty Name | `
              # spit them out the command line as well as dumping to text file
              Tee-Object -FilePath Document_ID.txt 


# ending bits
echo "===============================================`n"
echo "Wrote to 'Document_ID.txt`n"
Read-Host "Press ENTER to exit"