import numpy as np
import os
from sklearn.cluster import KMeans
from PIL import Image

# This forces Python to look in the exact folder where this .py file is saved
script_dir = os.path.dirname(os.path.abspath(__file__))
image_path = os.path.join(script_dir, 'Image_with_artifacts.jpg')

# Verify the path before opening
if not os.path.exists(image_path):
    print(f"Error: Could not find the file at {image_path}")
    print("Please make sure 'Example.jpg' is in the same folder as this script.")
else:
    # 1. Load the image
    img = Image.open(image_path).convert('RGB')
    img_data = np.array(img)
    rows, cols, channels = img_data.shape

    # 2. Reshape and cluster
    pixels = img_data.reshape((-1, 3))
    kmeans = KMeans(n_clusters=4, n_init='auto', random_state=42)
    idx = kmeans.fit_predict(pixels)
    centers = kmeans.cluster_centers_.astype('uint8')

    # 3. Reconstruct
    final_pixels = centers[idx]
    final_img_data = final_pixels.reshape((rows, cols, 3))
    final_img = Image.fromarray(final_img_data)

    # 4. Save in the same folder
    output_path = os.path.join(script_dir, 'Image_without_artifacts.png')
    final_img.save(output_path)
    print(f"Success! Saved to: {output_path}")