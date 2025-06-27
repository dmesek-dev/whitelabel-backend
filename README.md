# Icon Resizer API

A Node.js API that resizes images using the `normalize_icon.sh` script with ImageMagick.

## Prerequisites

- Node.js (v14 or higher)
- ImageMagick installed on your system
- The `normalize_icon.sh` script (should be in the same directory)

## Installation

1. Install dependencies:
```bash
npm install
```

2. Make sure ImageMagick is installed:
```bash
# On macOS
brew install imagemagick

# On Ubuntu/Debian
sudo apt-get install imagemagick

# On CentOS/RHEL
sudo yum install imagemagick
```

## Usage

1. Start the server:
```bash
npm start
```

Or for development with auto-restart:
```bash
npm run dev
```

2. The server will start on port 3000 (or the port specified in PORT environment variable).

## API Endpoints

### POST `/resize-icon`

Resizes an uploaded image using the normalize_icon.sh script.

**Parameters:**
- `image` (file): The image file to resize (form-data)
- `size` (query parameter): The size in pixels (optional, defaults to 1024)

**Example using curl:**
```bash
curl -X POST \
  "http://localhost:3000/resize-icon?size=512" \
  -F "image=@/path/to/your/image.jpg" \
  --output resized-icon.png
```

**Example using JavaScript (fetch):**
```javascript
const formData = new FormData();
formData.append('image', fileInput.files[0]);

fetch('http://localhost:3000/resize-icon?size=512', {
    method: 'POST',
    body: formData
})
.then(response => response.blob())
.then(blob => {
    // Handle the resized image blob
    const url = URL.createObjectURL(blob);
    // Use the URL to display or download the image
});
```

### GET `/health`

Health check endpoint.

**Response:**
```json
{
    "status": "OK",
    "message": "Icon resizer API is running"
}
```

## Features

- Accepts various image formats (PNG, JPEG, GIF, etc.)
- Automatic cleanup of temporary files
- File size limit of 10MB
- Error handling and validation
- Streams response for efficient memory usage

## How it works

1. The API receives an image file and size parameter
2. Saves the uploaded file temporarily
3. Calls the `normalize_icon.sh` script with appropriate parameters
4. Returns the processed image as a PNG file
5. Automatically cleans up temporary files

The `normalize_icon.sh` script:
- Converts the input to PNG format
- Detects background color from pixel (1,1)
- Uses white background if the detected color is black
- Resizes to specified dimensions with proper aspect ratio
- Creates a final 1024x1024 icon with centered content 