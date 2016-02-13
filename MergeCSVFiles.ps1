$pathSourceFiles = "D:\MyStuff\Workspaces\Github\merge-csv-files\TestFiles\Files\"
$pathDestinationFile = "D:\MyStuff\Workspaces\Github\merge-csv-files\TestFiles\"
$destinationFile = "Merged.csv"

$linesWrittenTotal = 0
$sourceFiles = Get-ChildItem $pathSourceFiles | sort CreationTime
Foreach ($sourceFile in $sourceFiles)
{
    $sourceFiletoRead = $pathSourceFiles + $sourceFile.Name
    $linesToProcess = Import-Csv -UseCulture $sourceFiletoRead -Encoding ASCII

    $destinationFileToReadWrite = $pathDestinationFile + $destinationFile
    if (Test-Path ($destinationFileToReadWrite))
    {
        $existingLines = Import-Csv -UseCulture $destinationFileToReadWrite -Encoding ASCII
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
            Export-Csv $destinationFileToReadWrite -InputObject $lineToProcess -Append -UseCulture -Encoding ASCII -NoTypeInformation
            $linesWrittenFile++
            $linesWrittenTotal++
        }
        
        $linesProcessedCounter++
    }
    
    Write-Host (" done, " + $linesWrittenFile + " new line(s).")
}

$linesWrittenTotal.ToString() + " new line(s) written to " + $destinationFile + "."