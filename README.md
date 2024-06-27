
# Kitchen Drawing App

## Overview

This Flutter application allows users to draw rectangles on a canvas, export the drawing to a DXF file, and ensures that rectangles do not overlap when drawn from the bottom. It supports dynamic resizing, drag-and-drop functionality, and intuitive menu options for creating different types of shapes.

## Features

1. **Canvas Drawing:**
   - Draw rectangles on a canvas.
   - Ensure rectangles do not overlap, especially when drawn from the bottom.

2. **Menu Options:**
   - **New Kitchen Countertop:** Draws rectangles 25.5 inches wide.
   - **New Island:** Draws rectangles 30 inches wide.
   - **Export to DXF file:** Export the canvas drawing to a DXF file.

3. **Rectangle Interaction:**
   - Drag rectangles to different positions on the canvas.
   - Resize rectangles dynamically.
   - Display dimensions (width and height) of rectangles on the canvas.

4. **Export and Share:**
   - Export drawings to DXF files using the Dart DXF library.
   - Share DXF files via email.

## Requirements

- Flutter 3.22 or higher
- flutter_bloc as State managment

## Usage

- **Drawing:**
  - Tap and drag on the canvas to draw rectangles.
  - Choose between "New Kitchen Countertop" or "New Island" options to set rectangle width.
  - Rectangles automatically adjust to ensure no overlap, even when drawing from the bottom.

- **Editing:**
  - Tap on a rectangle to select it.
  - Drag the selected rectangle to move it on the canvas.
  - Tap again to resize the rectangle dynamically.

- **Exporting:**



  - Use the "Export to DXF file" option to save your drawing as a DXF file.
  - Share the DXF file via email for further use.

## Screenshots

<img src="https://github.com/rajeshamby521/kitchen_countertop_app/assets/44517661/d57cb112-168b-43a1-bf3b-cdcc0fa33008" width="450"/>
<img src="https://github.com/rajeshamby521/kitchen_countertop_app/assets/44517661/88b60e65-2285-43f5-8c2e-f91c854601b0" width="450"/>


## Demo Video
https://github.com/rajeshamby521/kitchen_countertop_app/assets/44517661/f0d8f193-fda8-492c-a9c2-e06a68183a77
