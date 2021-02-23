# ps-bates-enumerator
PowerShell eDiscovery Automatic Bates File Enumerator

# Description
PowerShell script that recursively scans subdirectories for filenames matching Australian legal Bates numbering sequences, and lists the Bates numbers in a text file.

# Function

1. Recurses this and all subdirectories and lists all files with Bates numbers.
    - EG: `ABC.0001.0001.0001_PH.pdf`
2. Outputs all matching files to a text file
3. Splices out just the Bates numbers and spits those out to a text file as well
