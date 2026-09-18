# Calculation of Systolic Ejection Fraction from Cardiac MRI Images

MATLAB project for estimating left-ventricular (LV) cavity size and systolic ejection fraction from cardiac MRI images using several image-segmentation approaches.

The project compares four segmentation strategies on paired diastolic and systolic cardiac MR images and includes expert-provided masks that can be used as a reference.

## Overview

The processing pipeline is organized in two stages:

1. **Common preprocessing** (`Script.m`)
   - Loads the DICOM cardiac MRI images.
   - Loads the expert segmentation masks.
   - Crops a region of interest around the heart.
   - Applies an S-curve intensity transformation to enhance contrast.
   - Binarizes the images using image-specific thresholds.

2. **Left-ventricle segmentation**
   - **Method 1:** mathematical morphology.
   - **Method 2:** polygon-based manual segmentation with `roipoly`.
   - **Method 3:** k-means segmentation with automatic LV component selection.
   - **Method 4:** circular LV detection with `imfindcircles`.

For every image pair, the scripts estimate the LV cavity size in diastole and systole and compute an ejection-fraction estimate.

## Ejection Fraction

The ejection fraction is calculated as:

```text
EF = (Diastolic cavity size - Systolic cavity size) / Diastolic cavity size
```

The MATLAB scripts print EF as a fraction between 0 and 1. Multiply the result by 100 to express it as a percentage.

In the current implementation, cavity size is obtained by summing the foreground pixels of the segmented 2D mask. Therefore, the reported values are pixel-based estimates rather than physical volumes in mL.

## Requirements

- **MATLAB 2025** (as specified in the original project execution instructions)
- **Image Processing Toolbox**

The Image Processing Toolbox is required for functions used throughout the project, including `dicomread`, `imbinarize`, `bwlabel`, `strel`, `imclose`, `imdilate`, `roipoly`, `imsegkmeans`, `regionprops`, `imfindcircles`, and related image-processing operations.

## Project Structure

```text
.
├── Images_og/                     # Original cardiac MRI DICOM images
├── Expert/                        # Expert/manual LV segmentation masks
│   ├── *.pgm                      # Expert binary masks used by the code
│   └── *.txt                      # Expert contour coordinates
│
├── Script.m                       # Mandatory preprocessing script
├── Seg_with_mat_morphologie.m     # Method 1: mathematical morphology
├── Seg_with_roipoly.m             # Method 2: stored polygon ROI segmentation
├── Seg_with_kmeans.m              # Method 3: k-means segmentation
├── Seg_with_imfindcircles.m       # Method 4: circular detection
├── Script_expert.m                # Displays/calculates expert-reference results
│
├── PadToOriginal.m                # Restores cropped masks to 256 × 256
├── bestLVMaskFromLabels.m         # Selects the most likely LV from k-means labels
├── lvCircleMask.m                 # Detects the LV using imfindcircles
│
├── Rapport.pdf                    # Project report
└── Exposé.pdf                     # Project presentation
```

> **Important — folder-name case:** `Script.m` currently looks for a folder named `images_og`, while the repository contains `Images_og`. On Windows this will usually work because paths are generally case-insensitive. On a case-sensitive system, either rename `Images_og` to `images_og` or change the corresponding line in `Script.m`.

## How to Run

### 1. Open the project in MATLAB

Start MATLAB and set the **Current Folder** to the root directory of this repository — the directory containing `Script.m`.

For example:

```matlab
cd('path/to/Calculation-of-the-systolic-ejection-fraction-from-cardiac-MRI-images')
```

The scripts use the current working directory to locate the DICOM images, expert masks, and helper functions.

### 2. Run the preprocessing script

Always run:

```matlab
Script
```

first.

`Script.m` initializes the workspace and creates the variables required by all four segmentation scripts. It also displays the original images, cropped regions, contrast-enhanced images, and binary masks.

The segmentation scripts are **not standalone programs**: they depend on variables created by `Script.m`, so they must be run in the same MATLAB session after `Script.m`.

### 3. Run a segmentation method

After `Script.m`, run any of the following methods.

#### Method 1 — Mathematical morphology

```matlab
Seg_with_mat_morphologie
```

This method:

- labels connected regions in the binary images;
- selects predefined connected components corresponding to the LV;
- applies morphological closing and dilation;
- restores each mask to the original `256 × 256` image size;
- prints estimated cavity sizes and ejection fractions.

Helper function used:

```text
PadToOriginal.m
```

#### Method 2 — Polygon ROI segmentation

```matlab
Seg_with_roipoly
```

This method reconstructs manually selected LV regions using previously stored polygon vertices and MATLAB's `roipoly` function.

It then restores the masks to their original dimensions and prints the resulting cavity-size and ejection-fraction estimates.

Helper function used:

```text
PadToOriginal.m
```

#### Method 3 — K-means segmentation

```matlab
Seg_with_kmeans
```

This method:

- converts the contrast-enhanced images to 8-bit images;
- performs unsupervised intensity segmentation using `imsegkmeans`;
- analyzes the connected components in the resulting clusters;
- automatically selects the most likely LV cavity using intensity, position, area, circularity, solidity, and eccentricity criteria;
- performs morphological post-processing;
- prints the estimated cavity sizes and ejection fractions.

Helper functions used:

```text
bestLVMaskFromLabels.m
PadToOriginal.m
```

#### Method 4 — Circular LV detection

```matlab
Seg_with_imfindcircles
```

This method searches for bright circular structures with `imfindcircles` using image-specific radius and sensitivity parameters. The custom function selects the right-most candidate as the expected LV cavity and creates a filled circular mask.

The script displays diagnostic circle detections and prints the estimated cavity sizes and ejection fractions.

Helper functions used:

```text
lvCircleMask.m
PadToOriginal.m
```

### 4. Display the expert reference results

Optionally, after running `Script.m`, execute:

```matlab
Script_expert
```

This script displays the expert-provided segmentation masks and prints their corresponding cavity sizes and reference ejection fractions.

## Run the Complete Workflow

To execute all available methods in the intended order, run the following commands in the **same MATLAB session**:

```matlab
Script
Seg_with_mat_morphologie
Seg_with_roipoly
Seg_with_kmeans
Seg_with_imfindcircles
Script_expert
```

You can paste the complete block directly into the MATLAB Command Window.

## Running a Single Method

If you only want to test one segmentation technique, first run `Script.m` and then the desired method. For example:

```matlab
Script
Seg_with_kmeans
```

or:

```matlab
Script
Seg_with_imfindcircles
```

If the workspace has been cleared or MATLAB has been restarted, run `Script.m` again before executing a segmentation script.

## Input Data

The repository contains five paired cardiac MRI acquisitions. For each pair, one image represents diastole and the other systole.

The input DICOM files are stored in `Images_og/`, while expert LV masks are stored in `Expert/`.

`Script.m` currently uses the following pairs:

| Pair | Diastole | Systole |
|---|---|---|
| 1 | `IM-0009-0020.dcm` | `IM-0009-0028.dcm` |
| 2 | `IM-0009-0040.dcm` | `IM-0009-0048.dcm` |
| 3 | `IM-0009-0060.dcm` | `IM-0009-0068.dcm` |
| 4 | `IM-0009-0080.dcm` | `IM-0009-0088.dcm` |
| 5 | `IM-0009-0100.dcm` | `IM-0009-0108.dcm` |

## Output

The scripts generate two types of output.

### Figures

Depending on the method, MATLAB displays:

- original DICOM images;
- cropped cardiac regions;
- S-curve contrast-enhanced images;
- binary images;
- segmentation masks;
- k-means label overlays;
- detected circles;
- masks restored to the original image dimensions;
- expert reference masks.

### Command Window results

Each segmentation method prints:

- estimated diastolic cavity size;
- estimated systolic cavity size;
- estimated ejection fraction for each image pair.

`Script_expert.m` prints the equivalent reference results calculated from the expert masks.

## Method Summary

| Method | Script | Main idea | Automatic? |
|---|---|---|---|
| Mathematical morphology | `Seg_with_mat_morphologie.m` | Connected-component selection followed by morphology | Partially |
| Polygon ROI | `Seg_with_roipoly.m` | Previously defined manual polygon contours | No |
| K-means | `Seg_with_kmeans.m` | Intensity clustering + feature-based LV selection | Yes |
| Circle detection | `Seg_with_imfindcircles.m` | Circular-structure detection with `imfindcircles` | Yes, with tuned parameters |

## Implementation Notes

- The region of interest is currently hard-coded to rows and columns `70:170`.
- Binarization thresholds are manually tuned for individual images.
- Morphological connected-component labels are also image-specific.
- K-means uses a different number of clusters for some images.
- Circle radius ranges and sensitivities are individually tuned for each image.
- The current methods are therefore designed for this dataset and may require parameter adjustment for new patients or acquisitions.
- The reported cavity sizes are counts of pixels in binary masks. Physical ventricular volume would require incorporating DICOM spatial information, slice thickness/spacing, and an appropriate multi-slice volume calculation.

## Authors

- Lorenzo Mazzante
- Martin Scorza
- Federico Fioriti

## Documentation

Additional project material is provided in the repository:

- `Rapport.pdf` — detailed project report.
- `Exposé.pdf` — project presentation.

---

This repository is an academic image-processing project intended to explore and compare different strategies for segmenting the left ventricular cavity from cardiac MRI images and estimating systolic ejection fraction.
