# Snapchat Media Downloader with Metadata Preservation

A Python script to download Snapchat memories directly from your data export JSON file with full metadata preservation (dates, GPS coordinates, and EXIF data).

## Features

- 📥 Downloads all media from Snapchat JSON export files
- 📅 Preserves original creation dates
- 📍 Embeds GPS coordinates in EXIF metadata
- 🖼️ Sets EXIF data for images (date, location)
- ⏰ Updates file timestamps to match original dates
- 📁 Organizes files with date-based naming

## Prerequisites

### Python Requirements

- Python 3.6 or higher
- Required packages:
  ```bash
  pip install requests pillow piexif
  ```

### Getting Your Snapchat Data Export

1. Open Snapchat and go to your profile
2. Tap the ⚙️ (Settings) icon
3. Scroll down to **Privacy Controls**
4. Select **My Data**
5. Click **Submit Request**
6. Wait for Snapchat to email you (usually takes 24-48 hours)
7. Download the export ZIP file from the email link
8. Extract the ZIP file and locate the JSON file (usually in `json/memories_history.json` or similar)

## JSON Format

Your Snapchat export JSON file should contain a structure like this:

```json
{
    "Saved Media": [
        {
            "Date": "2024-05-06 23:18:11 UTC",
            "Media Type": "Image",
            "Location": "Latitude, Longitude: 40.7128, -74.0060",
            "Download Link": "https://app.snapchat.com/dmd/memories?uid=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx&sid=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX&mid=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX&ts=1234567890123&proxy=true&sig=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
            "Media Download Url": "https://us-east1-aws.api.snapchat.com/dmd/mm?uid=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx&sid=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX&mid=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX&ts=1234567890123&sig=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
        },
        {
            "Date": "2024-05-07 14:32:45 UTC",
            "Media Type": "Video",
            "Location": "Latitude, Longitude: 34.0522, -118.2437",
            "Download Link": "https://app.snapchat.com/dmd/memories?uid=...",
            "Media Download Url": "https://us-east1-aws.api.snapchat.com/dmd/mm?uid=..."
        }
    ]
}
```

### Required JSON Fields

- `Saved Media`: Array containing all media items
- `Date`: Creation date in format "YYYY-MM-DD HH:MM:SS UTC"
- `Media Type`: Either "Image" or "Video"
- `Location`: GPS coordinates in format "Latitude, Longitude: XX.XXXX, -XX.XXXX" (or "N/A")
- `Media Download Url`: Direct download URL for the media file

## Installation

1. Clone or download this repository
2. Install required Python packages:
   ```bash
   pip install requests pillow piexif
   ```

## Usage

### Interactive Mode

Run the script and follow the prompts:

```bash
python download_via_json.py
```

You'll be asked to provide:
1. **JSON file path**: Path to your Snapchat export JSON file
2. **Output folder**: Where to save downloaded media (default: `downloads`)

### Example Session

```
=== Snapchat Media Downloader with Metadata Preservation ===

Enter JSON file path: memories_history.json
Enter output folder (or press Enter for 'downloads'): my_snapchat_memories

Loading JSON from: memories_history.json
Found 150 media items to download

[1/150] Processing...
  File: 20240506_231811_1.jpg
  Date: 2024-05-06 23:18:11 UTC
  Location: 40.7128, -74.0060
  Downloading... ✓ Downloaded
  ✓ Set file timestamp to 2024-05-06 23:18:11
  ✓ Set EXIF metadata (date + GPS)

[2/150] Processing...
  File: 20240507_143245_2.mp4
  Date: 2024-05-07 14:32:45 UTC
  Location: 34.0522, -118.2437
  Downloading... ✓ Downloaded
  ✓ Set file timestamp to 2024-05-07 14:32:45
  Note: Video EXIF requires additional tools (ffmpeg)

...

✓ Complete! Downloaded 150 files to 'my_snapchat_memories'
```

## Output

### File Naming Convention

Files are named with the following pattern:
```
YYYYMMDD_HHMMSS_<index>.<extension>
```

Examples:
- `20240506_231811_1.jpg` - Image taken on May 6, 2024 at 11:18:11 PM
- `20240507_143245_2.mp4` - Video taken on May 7, 2024 at 2:32:45 PM

### Metadata Preservation

#### For Images (.jpg, .jpeg)
- ✅ File modification/access timestamps
- ✅ EXIF creation date/time
- ✅ EXIF GPS coordinates (latitude/longitude)

#### For Videos (.mp4)
- ✅ File modification/access timestamps
- ⚠️ EXIF metadata (requires additional tools like ffmpeg)

## Troubleshooting

### Missing Dependencies

If you see this warning:
```
Warning: piexif not installed. Install with: pip install piexif pillow
```

Install the required packages:
```bash
pip install pillow piexif requests
```

### No Download URL Found

If items show "⚠ No download URL found, skipping", verify:
- Your JSON file has the `Media Download Url` field
- The JSON structure matches the expected format
- The export is complete and not corrupted

### EXIF Metadata Errors

If EXIF metadata fails to set:
- Ensure `piexif` and `pillow` are installed correctly
- Verify the image file is a valid JPEG/JPG
- Check you have write permissions in the output directory
- Some images may have incompatible formats

### Download Errors

If downloads fail:
- Check your internet connection
- Verify the download URLs haven't expired (Snapchat URLs are time-limited)
- Request a new data export if URLs are expired
- Ensure you have enough disk space

### Video Metadata

Video EXIF metadata embedding requires additional tools like `ffmpeg`. Currently, the script only sets file timestamps for videos. To add metadata to videos, you would need to use external tools.

## Tips & Best Practices

1. **Download Quickly**: The download URLs in Snapchat's export are time-limited. Download your memories as soon as you receive the export email.

2. **Keep Your JSON**: Save your JSON file as a backup - it contains all the metadata for your memories.

3. **Large Exports**: For large exports (100+ files), be patient. The script processes one file at a time to avoid overwhelming your connection.

4. **Organize by Date**: Files are automatically named with timestamps, making them easy to sort chronologically in any file browser.

5. **Check Output**: After downloading, verify a few files to ensure dates and locations are correctly embedded.

6. **Backup Originals**: Keep your original Snapchat export until you've verified all downloads are complete and correct.

## File Structure

After running the script, your output directory will look like:
```
downloads/
├── 20240101_120000_1.jpg
├── 20240102_153045_2.mp4
├── 20240103_091523_3.jpg
├── 20240104_180932_4.mp4
└── ...
```

## Common Use Cases

### Scenario 1: First Time Export
```bash
python download_via_json.py
# Enter: json/memories_history.json
# Enter: my_memories
```

### Scenario 2: Multiple Exports (Different People)
```bash
python download_via_json.py
# Enter: laura_memories.json
# Enter: laura_downloads

python download_via_json.py
# Enter: john_memories.json
# Enter: john_downloads
```

### Scenario 3: Organize by Year
```bash
python download_via_json.py
# Enter: memories_2024.json
# Enter: memories/2024
```

## Technical Details

### Date Parsing
- Input format: `YYYY-MM-DD HH:MM:SS UTC`
- Output filename format: `YYYYMMDD_HHMMSS`
- EXIF format: `YYYY:MM:DD HH:MM:SS`

### GPS Coordinates
- Input format: `Latitude, Longitude: XX.XXXX, -XX.XXXX`
- Converted to EXIF DMS (Degrees, Minutes, Seconds) format
- Includes hemisphere indicators (N/S for latitude, E/W for longitude)

### File Extensions
- Images: `.jpg`
- Videos: `.mp4`
- Unknown: `.bin`

## Limitations

- Video EXIF metadata requires external tools (ffmpeg) for full support
- Download URLs from Snapchat expire after a certain period
- Large files may take time to download depending on your connection
- Some location data may be unavailable ("N/A") for certain memories

## License

Free to use and modify for personal use.

## Disclaimer

This tool is not affiliated with or endorsed by Snapchat. It is designed to help users organize and preserve their own personal data exports. Use at your own discretion and in accordance with Snapchat's Terms of Service.

## Support

If you encounter issues:
1. ✅ Verify your JSON file format matches the expected structure
2. ✅ Check that all dependencies are installed: `pip list | findstr "requests pillow piexif"`
3. ✅ Ensure you have internet connectivity for downloads
4. ✅ Verify write permissions in the output directory
5. ✅ Check that download URLs haven't expired (request new export if needed)
