# This script merges a bunch of files into one file and filters out duplicate lines
#
# If the output file does not exist, it will be created
# If the output file already exists, only new/unique lines will be added. So the script
# can be run multiple times with the same source files, and the output file will still
# contain only unique lines.

# ---- Parameters ---------------------------------------------------------------------
# Folder where the source files are located
$pathSourceFiles = "D:\MyStuff\Workspaces\Github\merge-csv-files\TestFiles\Files\"

# Output file
$destinationFile = "D:\MyStuff\Workspaces\Github\merge-csv-files\TestFiles\Merged.csv"
# -------------------------------------------------------------------------------------

$linesWrittenTotal = 0
$sourceFiles = Get-ChildItem $pathSourceFiles | sort CreationTime
Foreach ($sourceFile in $sourceFiles)
{
    $sourceFiletoRead = $pathSourceFiles + $sourceFile.Name
    $linesToProcess = Import-Csv -UseCulture $sourceFiletoRead -Encoding ASCII

    if (Test-Path ($destinationFile))
    {
        $existingLines = Import-Csv -UseCulture $destinationFile -Encoding ASCII
    }

    Write-Host ("Processing file " + $sourceFile.Name + " (" + $linesToProcess.length + ") lines")
    Write-Host -NoNewline "Please wait ..."

    $linesProcessedCounter = 0
    $linesWrittenFile = 0
    Foreach ($lineToProcess in $linesToProcess)
    {
        $writeLineToDestinationFile = $true
        
        if ($existingLines -ne $null)
        {
            Foreach ($existingLine in $existingLines)
            {
                $lineToProcessAsJson = ConvertTo-Json -InputObject $lineToProcess 
                $existingLineAsJson = ConvertTo-Json -InputObject $existingLine

                If ($lineToProcessAsJson -eq $existingLineAsJson)
                {
                    $writeLineToDestinationFile = $false
                    break
                }
            }
        }
        
        if ($writeLineToDestinationFile)
        {
            Export-Csv $destinationFile -InputObject $lineToProcess -Append -UseCulture -Encoding ASCII -NoTypeInformation
            $linesWrittenFile++
            $linesWrittenTotal++
        }
        
        $linesProcessedCounter++
    }
    
    Write-Host (" done, " + $linesWrittenFile + " new line(s).")
}

$linesWrittenTotal.ToString() + " new line(s) written to " + $destinationFile + "."