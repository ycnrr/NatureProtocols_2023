*** Automation of co-trafficking analysis

The goal of a co-trafficking assay is to take a raw microscope file containing 2 fluorescent channels, and generate a composite kymograph so that the user can score vesicle tracks as containing 1 or both of the proteins of interest.

This macro takes a microscope file as an input, splits and recolors the fluorescent channels, generates maximum intensity projections of the images, and prompts the user to define an ROI for analysis. All image (raw files, max intensity projections) windows are left open to allow the user to have this information to select the ROI.

Then, kymographs in both colors are generated, saved, and merged. These kymographs can be used to analyze co-trafficking. 