const express = require('express');
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const { exec } = require('child_process');
const { promisify } = require('util');

const execAsync = promisify(exec);
const app = express();
const PORT = process.env.PORT || 3000;

const uploadsDir = path.join(__dirname, 'uploads');
if (!fs.existsSync(uploadsDir)) {
    fs.mkdirSync(uploadsDir, { recursive: true });
}

const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, uploadsDir);
    },
    filename: (req, file, cb) => {
        const uniqueName = `${Date.now()}-${Math.round(Math.random() * 1E9)}${path.extname(file.originalname)}`;
        cb(null, uniqueName);
    }
});

const upload = multer({ 
    storage: storage,
    fileFilter: (req, file, cb) => {
        if (file.mimetype.startsWith('image/')) {
            cb(null, true);
        } else {
            cb(new Error('Only image files are allowed!'), false);
        }
    },
    limits: {
        fileSize: 10 * 1024 * 1024
    }
});

app.post('/resize-icon', upload.single('image'), async (req, res) => {
    try {
        if (!req.file) {
            return res.status(400).json({ error: 'No image file provided' });
        }

        const size = req.query.size || '1024';
        const inputPath = req.file.path;
        const outputDir = path.dirname(inputPath);
        const scriptPath = path.join(__dirname, 'normalize_icon.sh');

        if (!fs.existsSync(scriptPath)) {
            return res.status(500).json({ error: 'normalize_icon.sh script not found' });
        }

        const command = `"${scriptPath}" -s "${size}" -d "${outputDir}" -p "${inputPath}"`;
        
        console.log(`Executing: ${command}`);
        await execAsync(command);

        const outputPath = path.join(outputDir, 'icon.png');

        if (!fs.existsSync(outputPath)) {
            throw new Error('Failed to create resized image');
        }

        res.setHeader('Content-Type', 'image/png');
        res.setHeader('Content-Disposition', 'attachment; filename="resized-icon.png"');
        
        const fileStream = fs.createReadStream(outputPath);
        fileStream.pipe(res);

        fileStream.on('end', () => {
            setTimeout(() => {
                fs.unlink(inputPath, (err) => {
                    if (err) console.error('Error deleting input file:', err);
                });
                fs.unlink(outputPath, (err) => {
                    if (err) console.error('Error deleting output file:', err);
                });
            }, 1000);
        });

    } catch (error) {
        console.error('Error processing image:', error);
        
        if (req.file && req.file.path) {
            fs.unlink(req.file.path, (err) => {
                if (err) console.error('Error deleting uploaded file:', err);
            });
        }

        res.status(500).json({ 
            error: 'Failed to process image', 
            details: error.message 
        });
    }
});

app.post('/generate-assets', async (req, res) => {
    try {
        const clientFolder = req.query['client-folder'] || req.body?.clientFolder;
        
        if (!clientFolder) {
            return res.status(400).json({ error: 'client-folder parameter is required' });
        }

        const scriptPath = path.join(__dirname, 'generate_assets_utils.sh');

        if (!fs.existsSync(scriptPath)) {
            return res.status(500).json({ error: 'generate_assets_utils.sh script not found' });
        }

        const command = `"${scriptPath}" -c "${clientFolder}"`;
        
        console.log(`Executing: ${command}`);
        const { stdout, stderr } = await execAsync(command);

        console.log('Script output:', stdout);
        if (stderr) {
            console.warn('Script stderr:', stderr);
        }

        res.json({ 
            success: true, 
            message: `Assets generated successfully for client: ${clientFolder}`,
            output: stdout
        });

    } catch (error) {
        console.error('Error generating assets:', error);
        res.status(500).json({ 
            error: 'Failed to generate assets', 
            details: error.message 
        });
    }
});

app.post('/setup-client-firebase', async (req, res) => {
    try {
        const clientFolder = req.query['client-folder'] || req.body?.clientFolder;
        
        if (!clientFolder) {
            return res.status(400).json({ error: 'client-folder parameter is required' });
        }

        const scriptPath = path.join(__dirname, 'setup_firebase.sh');

        if (!fs.existsSync(scriptPath)) {
            return res.status(500).json({ error: 'setup_firebase.sh script not found' });
        }

        const command = `"${scriptPath}" -c "${clientFolder}"`;
        
        console.log(`Executing: ${command}`);
        const { stdout, stderr } = await execAsync(command);

        console.log('Script output:', stdout);
        if (stderr) {
            console.warn('Script stderr:', stderr);
        }

        res.json({ 
            success: true, 
            message: `Firebase setup completed successfully for client folder: ${clientFolder}`,
            output: stdout
        });

    } catch (error) {
        console.error('Error setting up Firebase:', error);
        res.status(500).json({ 
            error: 'Failed to setup Firebase', 
            details: error.message 
        });
    }
});

app.post('/setup-admin-firebase', async (req, res) => {
    try {
        const clientFolder = req.query['client-folder'] || req.body?.clientFolder;
        
        if (!clientFolder) {
            return res.status(400).json({ error: 'client-folder parameter is required' });
        }

        const scriptPath = path.join(__dirname, 'setup_admin_firebase.sh');

        if (!fs.existsSync(scriptPath)) {
            return res.status(500).json({ error: 'setup_admin_firebase.sh script not found' });
        }

        const command = `"${scriptPath}" -c "${clientFolder}"`;
        
        console.log(`Executing: ${command}`);
        const { stdout, stderr } = await execAsync(command);

        console.log('Script output:', stdout);
        if (stderr) {
            console.warn('Script stderr:', stderr);
        }

        res.json({ 
            success: true, 
            message: `Admin Firebase setup completed successfully for client folder: ${clientFolder}`,
            output: stdout
        });

    } catch (error) {
        console.error('Error setting up Admin Firebase:', error);
        res.status(500).json({ 
            error: 'Failed to setup Admin Firebase', 
            details: error.message 
        });
    }
});

app.get('/health', (req, res) => {
    res.json({ status: 'OK', message: 'Icon resizer API is running' });
});

app.use((error, req, res, next) => {
    if (error instanceof multer.MulterError) {
        if (error.code === 'LIMIT_FILE_SIZE') {
            return res.status(400).json({ error: 'File too large' });
        }
    }
    res.status(500).json({ error: error.message });
});

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
    console.log(`POST /resize-icon - Upload an image with ?size=<pixels> query parameter`);
    console.log(`POST /generate-assets - Generate assets for a client`);
    console.log(`POST /setup-client-firebase - Setup Firebase for a client`);
    console.log(`POST /setup-admin-firebase - Setup Admin Firebase for a client`);
    console.log(`GET /health - Health check endpoint`);
});
