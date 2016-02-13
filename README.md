# merge-csv-files
Powershell script that merges a bunch of files into one file and filters out duplicate lines in the process.

If the output file does not exist, it will be created.

If the output file already exists, only new/unique lines will be added. So the script
can be run multiple times with the same source files, and the output file will still
contain only unique lines.
