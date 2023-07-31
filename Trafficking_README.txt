*** Automation of Trafficking Analysis

The goal of the trafficking assay is to take a microscope movie file as an input, and generate kymographs on the appropriate axon of interest.

This macro takes a raw microscope file as an input, generates a directory with the same name, and generates and saves a max intensity image of the movie.

Sometimes it is desirable to analyze the trafficking behavior in both the midpoint of the axon as well as the ending. To enable this, the macro asks for both a "MID ROI" and an "END ROI". If one of these functions is not desired, they can be commented out.

The user is prompted for one or both of these ROIs (the original image is left open to provide reference to the user) and kymographs are generated and saved.

These kymographs can then be added to .zip folders for export to KymoButler. 
