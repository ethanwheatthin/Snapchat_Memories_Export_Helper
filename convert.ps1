# convert-snap-files.ps1
# Set the folder to search and toggle DryRun
$root = 'C:\Users\Ethan\Desktop\Code_Playground\Snapchat_Export_Helper\export\Download\'   # <-- change this to the folder you want to process
$DryRun = $false                  # set to $false to actually rename files

# Ensure the "original", "processed images", "unzipped", and "videos" folders exist
$originalFolder = Join-Path $root 'original'
$processedFolder = Join-Path $root 'processed images'
$unzippedFolder = Join-Path $root 'unzipped'
$videosFolder = Join-Path $root 'videos'

if (-not (Test-Path $originalFolder)) {
    New-Item -ItemType Directory -Path $originalFolder | Out-Null
}

if (-not (Test-Path $processedFolder)) {
    New-Item -ItemType Directory -Path $processedFolder | Out-Null
}

if (-not (Test-Path $unzippedFolder)) {
    New-Item -ItemType Directory -Path $unzippedFolder | Out-Null
}

if (-not (Test-Path $videosFolder)) {
    New-Item -ItemType Directory -Path $videosFolder | Out-Null
}

Get-ChildItem -Path $root -Recurse -File | ForEach-Object {
    $path = $_.FullName

    if ($_.Extension -eq '.zip') {
        # Handle .zip files
        $zipName = $_.BaseName
        $extractFolder = Join-Path $unzippedFolder $zipName

        if (-not (Test-Path $extractFolder)) {
            New-Item -ItemType Directory -Path $extractFolder | Out-Null
        }

        if ($DryRun) {
            Write-Host "Would extract '$path' to '$extractFolder'"
        } else {
            try {
                Add-Type -AssemblyName System.IO.Compression.FileSystem
                [System.IO.Compression.ZipFile]::ExtractToDirectory($path, $extractFolder)
                Write-Host "Extracted '$path' to '$extractFolder'"
            } catch {
                Write-Host "Error extracting '$path': $_"
            }
        }
    } elseif (($_.Name -eq 'File') -or ([IO.Path]::GetExtension($_.Name) -eq '')) {
        # Handle files named "File" or files with no extension

        # read first 3 bytes to check for JPEG signature (FF D8 FF)
        try {
            $fs = [System.IO.File]::OpenRead($path)
            $bytes = New-Object byte[] 3
            $fs.Read($bytes, 0, 3) | Out-Null
            $fs.Close()
        } catch {
            Write-Host "Error reading $path - skipping"
            return
        }

        if ($bytes[0] -eq 0xFF -and $bytes[1] -eq 0xD8 -and $bytes[2] -eq 0xFF) {
            # build a new name and avoid overwriting existing files
            $base = $_.BaseName
            $newName = "$base.jpeg"
            $newPath = Join-Path $processedFolder $newName

            if (Test-Path $newPath) {
                $i = 1
                do {
                    $newName = "${base}_$i.jpeg"
                    $newPath = Join-Path $processedFolder $newName
                    $i++
                } while (Test-Path $newPath)
            }

            if ($DryRun) {
                Write-Host "Would move original:`n    '$path'`n -> '$originalFolder'"
                Write-Host "Would rename and move:`n    '$path'`n -> '$newPath'"
            } else {
                # Move the original file to the "original" folder
                $originalPath = Join-Path $originalFolder $_.Name
                Move-Item -LiteralPath $path -Destination $originalPath

                # Rename and move the file directly to the "processed images" folder
                Rename-Item -LiteralPath $originalPath -NewName (Split-Path $newPath -Leaf)
                Move-Item -LiteralPath (Join-Path $originalFolder (Split-Path $newPath -Leaf)) -Destination $processedFolder

                Write-Host "Moved original '$path' -> '$originalPath'"
                Write-Host "Renamed and moved '$path' -> '$newPath'"
            }
        } else {
            Write-Host "Skipping (not JPEG): $path"
        }
    } elseif ($_.Extension -match '\.(mp4|avi|mov|mkv|wmv|flv|webm)$') {
        # Handle video files
        $videoPath = Join-Path $videosFolder $_.Name

        if ($DryRun) {
            Write-Host "Would move video file '$path' to '$videoPath'"
        } else {
            Move-Item -LiteralPath $path -Destination $videoPath
            Write-Host "Moved video file '$path' -> '$videoPath'"
        }
    }
}