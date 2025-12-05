# Snapchat Export Helper

## Overview
Snapchat Export Helper is a tool designed to assist users in organizing and fixing exported or downloaded memories from Snapchat. When you export your memories from Snapchat, the files may not always be in the most user-friendly format. This tool helps streamline the process, making your memories easier to manage and enjoy.

## Features
- Automatically processes exported Snapchat memories.
- Fixes file naming issues.
- Organizes files into a more structured format.

## How to Use
### Step 1: Export Your Memories from Snapchat
1. Go to your Snapchat account settings and request an export of your data.
2. Ensure that you select **only your memories** for export.
3. Once the export is ready, download the provided ZIP file and extract its contents.

![Export Memories Screenshot](./images/export_screenshot.png)

### Step 2: Prepare Your Files
1. Locate the `index.html` file in the extracted export folder.
2. Open the `index.html` file in a web browser.
3. Use the interface to download all your memories into a single directory.

### Step 3: Process Your Files
1. Place all the downloaded memories into a single directory.
2. Run the `convert.ps1` script in PowerShell.
3. Follow the on-screen instructions to process your exported Snapchat memories.

### What the Script Does
The `convert.ps1` script performs the following tasks:

1. **Folder Setup:**
   - Ensures the existence of the following folders within the specified root directory:
     - `original`: Stores the original files before processing.
     - `processed images`: Stores processed image files.
     - `unzipped`: Stores extracted contents of ZIP files.
     - `videos`: Stores video files.

2. **ZIP File Handling:**
   - Detects ZIP files and extracts their contents into the `unzipped` folder.

3. **Image Processing:**
   - Identifies files named `File` or files without extensions.
   - Checks if the file is a JPEG image by reading its signature.
   - Renames JPEG files with a `.jpeg` extension and moves them to the `processed images` folder.
   - Avoids overwriting by appending a numeric suffix to duplicate filenames.

4. **Video File Handling:**
   - Detects video files with extensions like `.mp4`, `.avi`, `.mov`, etc.
   - Moves video files to the `videos` folder.

5. **Dry Run Option:**
   - By default, the script performs a dry run, showing what actions it would take without making changes.
   - Set `$DryRun` to `$false` to enable actual processing.

## Requirements
- Windows operating system.
- PowerShell.

## Disclaimer
This tool is not affiliated with or endorsed by Snapchat. Use it at your own discretion.