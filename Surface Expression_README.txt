***Automating Surface Expression Analysis

When analyzing surface expression experiments, the goal is to take a microscope movie file as an input, and eventual get a fluorescence intensity value for some user-defined region.

This macro converts the imaging file to Tiff, generates appropriate folders to store output data, and generates a max intensity projection of the image.

Then, the user is prompted to define the ROI. Using the measure tool (keyboard shortcut: "m"), the user can track the length of their defined ROI.

On conclusion of the macro the average fluorescence intensity value over the ROI is provided.