import React, { useEffect, useState } from 'react';
import './App.css';

function App() {
    const [images, setImages] = useState([]);

    useEffect(() => {
        // Fetch the list of image filenames from your server
        fetch('http://localhost:3000/api/images')
            .then(response => response.json())
            .then(data => {
                setImages(data.images);
            })
            .catch(error => console.error('Error fetching images:', error));
    }, []);

    return (
        <div className="App">
            <h1>Image Gallery</h1>
            <div className="image-gallery">
                {images.map((image, index) => (
                    <div key={index} className="image-item">
                        <img src={`http://localhost:3000/images/${image}`} alt={image} />
                    </div>
                ))}
            </div>
        </div>
    );
}

export default App;
