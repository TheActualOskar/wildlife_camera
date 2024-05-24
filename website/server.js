const express = require('express');
const cors = require('cors');
const path = require('path');
const fs = require('fs');

const app = express();
const PORT = 3000;

// Use CORS to allow cross-origin requests from your React app domain
app.use(cors());

// Serve static files from the cloud/images directory
app.use('/images', express.static(path.join(__dirname, '../cloud/images')));

// Endpoint to list all images
app.get('/api/images', (req, res) => {
    const imagesDirectory = path.join(__dirname, '../cloud/images');

    fs.readdir(imagesDirectory, (err, files) => {
        if (err) {
            console.error('Failed to list images:', err);
            res.status(500).json({ message: "Failed to list images" });
            return;
        }
        res.json({ images: files });
    });
});

// Start the server
app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});
