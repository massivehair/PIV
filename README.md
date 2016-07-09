# PIV
PIV code for tracking quantum dot aggregates in blood vessels

Dependencies:
http://www.mathworks.com/matlabcentral/fileexchange/37147-savitzky-golay-smoothing-filter-for-2d-data/

To use:
Edit PIV_main.m to point to your data folder and file, and alter the setup parameters as desired. WindowSize is the size of the window that is extracted from each frame, and MaxStep is how far the window can be moved from frame to frame to locate a cross-correlation peak. PIVMethod and SmoothMethod can be left as they are - FiltSize may be altered to provide more or less smoothing before performing cross-correlation. MaskThreshold controls how flowing regions are isolated from the background - a standard deviation projection is taken through all pixels in the image stack and the pixels with a standard deviation higher than MaskThreshold (after some morphological processing) are assumed to be part of the dataset. You can make this value arbitrarily small to calculate the cross-correlation at all locations, but you might run out of memory doing this.

WARNING: The code will overwrite the file '<FileName>.mat' in the data folder - this stores the results of the PIV calculation.
