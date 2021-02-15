# By Andre Abadi
echo "`nRecursive Document Enumerator by Andre Abadi.`n"
echo "Recurses this and all subdirectories"
echo "  and lists all files with Bates numbers."
echo "  EG: ABC.0001.0001.0001.pdf`n"
echo "Puts them in a file called 'Document_ID.txt'"
echo "  alongside this script.`n"
echo "===============================================`n"
$mydir = Get-Location
Set-Location -Path $mydir
  Get-ChildItem -Recurse -File | `
      Where-Object {$_.Name -match '(.{3}\.\d{4}\.\d{4}\.\d{4})'} | `
          Select-Object -ExpandProperty Name | `
              Tee-Object -FilePath Document_ID.txt 
echo "`n===============================================`n"
echo "Wrote to 'Document_ID.txt`n"
$End = Read-Host "Press ENTER to exit"