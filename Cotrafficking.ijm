//   Copyright [2023] [Sidharth Tyagi]

//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

//setting directory for file creation
dir = getDirectory("Choose a Directory");
path = File.openDialog("Select a File");
//stores filename
fileName = File.getNameWithoutExtension(path);
open(path);
//ims to tif conversion
mainpath = dir + File.separator + fileName + File.separator;
File.makeDirectory(mainpath);
saveAs("Tiff", mainpath + fileName);
fileExtension = fileName + ".tif"
imgName = getTitle();
NewimgName = replace(imgName,".tif","")
run("Make Composite");
Stack.setChannel(1);
run("Magenta");
for (i=0; i<5; i++) {
run("Enhance Contrast", "saturated=0.35");
}
Stack.setChannel(2);
run("Green");
for (i=0; i<5; i++) {
run("Enhance Contrast", "saturated=0.35");
}

run("Split Channels");
//Generates two subfolders for the channels
C1Path = mainpath + File.separator + "Channel1" + File.separator;
C2Path = mainpath + File.separator + "Channel2" + File.separator;
File.makeDirectory(C1Path);
File.makeDirectory(C2Path);
C1fileName = "C1-" + imgName;
C2fileName = "C2-" + imgName;
selectWindow(C1fileName);
saveAs("Tiff", C1Path + C1fileName);
C1fileExtension = C1fileName + ".tif";
selectWindow(C2fileName);
saveAs("Tiff", C2Path + C2fileName);
C2fileExtension = C2fileName + ".tif";

run("Merge Channels...", "c2=["+C1fileName + "] c6=["+C2fileName+ "] create");
selectWindow(fileExtension);
saveAs("Tiff", mainpath + File.separator + NewimgName + "_Comp" + ".tif");


//sets filepath for channel 1 Max intensity image generation
pathfileC1 = C1Path + File.separator + C1fileName + File.separator;
//bypasses settings of KymographClear toolbox
imageDir=C1Path;
fileList = getFileList(imageDir); 
numberSlice=fileList.length;
Number_of_images=1;
first_image=1;
increment=1;
//generates maximum intensity image
run("Image Sequence...", 
  "open=[&pathfileC1]"+
  " number="+numberSlice+
  " starting="+first_image+
  " increment="+increment+
  " scale=100 "+
  "sort");

	run("Z Project...", " projection=[Max Intensity]");
	setTool("zoom");
//sets filepath for channel 2 Max intensity image generation
pathfileC2 = C2Path + File.separator + C2fileName + File.separator;
//bypasses settings of KymographClear toolbox
imageDir=C2Path;
fileList = getFileList(imageDir); 
numberSlice=fileList.length;
Number_of_images=1;
first_image=1;
increment=1;
//generates maximum intensity image
run("Image Sequence...", 
  "open=[&pathfileC2]"+
  " number="+numberSlice+
  " starting="+first_image+
  " increment="+increment+
  " scale=100 "+
  "sort");

	run("Z Project...", " projection=[Max Intensity]");
	setTool("zoom");
selectWindow("MAX_Channel2");
for (i=0; i<5; i++) {
run("Enhance Contrast", "saturated=0.35");
}
selectWindow("MAX_Channel1");
for (i=0; i<5; i++) {
run("Enhance Contrast", "saturated=0.35");
}
//merge max images
run("Merge Channels...", "c2=MAX_Channel2 c6=[MAX_Channel1] create keep");
MaxfileName = "MaxIntensity" + NewimgName;
MaxfileExtension = MaxfileName + ".tif";
selectWindow("Composite");
saveAs("Tiff", mainpath + MaxfileName);

Stack.setChannel(1);
for (i=0; i<5; i++) {
run("Enhance Contrast", "saturated=0.35");
}
Stack.setChannel(2);
for (i=0; i<5; i++) {
run("Enhance Contrast", "saturated=0.35");
}
//Creates user dialog for selection of axon. While loop ensures 'OK' cannot be selected without a valid segment
setTool("polyline");
do {waitForUser("Select the axon to analyze");
} while(selectionType()!=6);
ROIName = NewimgName + "_ROI";
saveAs("Selection", mainpath + ROIName);
ROIextension = ROIName + ".roi";
ROIfile = mainpath + File.separator + ROIextension + File.separator;
LampName = "Channel2" + NewimgName;
LampExtension = LampName + ".tif";
HaloName = "Channel1" + NewimgName;
HaloExtension = HaloName + ".tif";
selectWindow("MAX_SNAPRab11a");
open(ROIfile);
activeimgtittle = getTitle();
if (startsWith(activeimgtittle, "AVG_"))
{selectWindow(substring(activeimgtittle,4));}
if (startsWith(activeimgtittle, "MAX_"))
{selectWindow(substring(activeimgtittle,4));}

seqID = getImageID();
setBatchMode(true);
run("Restore Selection");
run("Profile Plot Options...", "width=450 height=200 minimum=0 maximum=0 interpolate draw sub-pixel");
run("Interpolate", "interval=1 smooth");
  

//if (startsWith(File.getName(call("ij.io.OpenDialog.getDefaultDirectory")), "kymograph"))
//
//{if (startsWith(File.getName(File.getParent(call("ij.io.OpenDialog.getDefaultDirectory"))), "kymograph"))
//mainfolderpath = File.getParent(File.getParent((call("ij.io.OpenDialog.getDefaultDirectory"))));
//else mainfolderpath = File.getParent(call("ij.io.OpenDialog.getDefaultDirectory"));}
//
//else if (startsWith(File.getName(call("ij.io.OpenDialog.getDefaultDirectory")), "backward"))
//mainfolderpath = File.getParent(File.getParent(File.getParent(call("ij.io.OpenDialog.getDefaultDirectory"))));
//
//else if (startsWith(File.getName(call("ij.io.OpenDialog.getDefaultDirectory")), "forward"))
//mainfolderpath = File.getParent(File.getParent(File.getParent(call("ij.io.OpenDialog.getDefaultDirectory"))));
//
//else mainfolderpath = call("ij.io.OpenDialog.getDefaultDirectory");
//
//
//if (File.exists(mainfolderpath + File.separator + "kymograph")!=1) {
//	File.makeDirectory(mainfolderpath + File.separator + "kymograph");
//}
//
//
//	i = 1;
//	j = 1;
//  while (File.exists(mainfolderpath + File.separator + "kymograph" + File.separator + "Segment_kymograph_"+ i +".txt")==1) {	
//    	i = i + 1;
//	j = i;
//  }
//
//File.makeDirectory(mainfolderpath + File.separator + "kymograph" + File.separator + "kymograph_"+ j);
//
//saveAs("XY Coordinates", mainfolderpath  + File.separator + "kymograph" + File.separator + "Segment_kymograph_" + j + ".txt");
mainfolderpath = mainpath;

if (File.exists(mainfolderpath + File.separator + "kymograph")!=1) {
	File.makeDirectory(mainfolderpath + File.separator + "kymograph");
}


	i = 1;
	j = 1;
  while (File.exists(mainfolderpath + File.separator + "kymograph" + File.separator + "Segment_kymograph_"+ i +".txt")==1) {	
    	i = i + 1;
	j = i;
  }

File.makeDirectory(mainfolderpath + File.separator + "kymograph" + File.separator + "kymograph_"+ j);

saveAs("XY Coordinates", mainfolderpath  + File.separator + "kymograph" + File.separator + "Segment_kymograph_" + j + ".txt");

/////////////// Line width


			chosen_linewidth = 5;
			chosen_linewidth = 5;
			run("Line Width...", "line=" + chosen_linewidth);

			f_linewidth = File.open( mainfolderpath + File.separator + "kymograph" + File.separator + "kymograph_"+ j +"" + File.separator + "linewidth" + chosen_linewidth + ".txt");

			File.close(f_linewidth);
			
/////////////// Retrieve segment from the saved file
			
	fkymosegment = File.openAsString(mainfolderpath  + File.separator + "kymograph" + File.separator + "Segment_kymograph_" + j + ".txt");

	rows=split(fkymosegment, "\n"); 
	x=newArray(rows.length); 
	y=newArray(rows.length); 
	for(m=0; m<rows.length; m++){ 
	columns=split(rows[m],"\t"); 
	x[m]=parseFloat(columns[0]); 
	y[m]=parseFloat(columns[1]); 
	}
	toUnscaled(x, y);



File.saveString("", mainfolderpath + File.separator + "kymograph" + File.separator + "kymograph_"+ j + File.separator + "kymograph" + j + ".txt") 

getDimensions(width1, height1, channels, slices, frames);

f = File.open( mainfolderpath + File.separator + "kymograph" + File.separator + "kymograph_"+ j + File.separator + "kymograph" + j + ".txt");

   for (k=1; k<slices+1; k++)
	{
	
		setSlice(k);
		
		makeSelection("polyline", x, y);
		profile = getProfile();

		string="";
		for (l=0; l<lengthOf(profile); l++) {
			if (l==0) {
				string=string+profile[l];
			} else {
				string=string+"\t"+profile[l];
			}
			
		}
		print(f, string);
  	}
File.close(f);

run("Line Width...", "line=1");

run("Text Image... ", "open=[" + mainfolderpath + File.separator + "kymograph" + File.separator + "kymograph_"+ j + File.separator + "kymograph" + j + ".txt]");
makeRectangle(1, 0, lengthOf(profile), slices); ///********** this line and the next one are used to delete the first column of the kymograph which does not make sense most of the time (known problem from ImageJ) ********////
run("Crop");

selectWindow("kymograph" + j + ".txt");



saveAs("Tiff", mainfolderpath + File.separator + "kymograph" + File.separator + "kymograph_"+ j + File.separator + LampName + ".tif");
rename("kymograph" + j);
run("Green");
setTool("zoom");


// creation of paved kymograph to reduce edge issues


run("Duplicate...", "title=subFourier1");
run("Duplicate...", "title=subFourier2");
run("Duplicate...", "title=subFourier3");
run("Duplicate...", "title=subFourier4");

selectWindow("subFourier2");
run("Flip Horizontally");

selectWindow("subFourier3");
run("Flip Horizontally");
run("Flip Vertically");

selectWindow("subFourier4");
run("Flip Vertically");


setColor(0);
selectWindow("subFourier1");
run("Copy");
getDimensions(width1, height1, channels, slices, frames);

newImage("filter forward", "16-bit Black", 3*width1, 3*height1,1);

 
makeRectangle(width1, height1, width1, height1); 
run("Paste"); 

selectWindow("subFourier2");
run("Copy");
selectWindow("filter forward");
makeRectangle(0, height1, width1, height1); 
run("Paste"); 
makeRectangle(2*width1, height1, width1, height1); 
run("Paste");

selectWindow("subFourier3");
run("Copy");
selectWindow("filter forward");
makeRectangle(0, 0, width1, height1); 
run("Paste"); 
makeRectangle(2*width1, 0, width1, height1); 
run("Paste");
makeRectangle(0, 2*height1, width1, height1); 
run("Paste"); 
makeRectangle(2*width1, 2*height1, width1, height1); 
run("Paste");

selectWindow("subFourier4");
run("Copy");
selectWindow("filter forward");
makeRectangle(width1, 0, width1, height1); 
run("Paste"); 
makeRectangle(width1, 2*height1, width1, height1); 
run("Paste");

selectWindow("subFourier1");
close();
selectWindow("subFourier2");
close();
selectWindow("subFourier3");
close();
selectWindow("subFourier4");
close();

makeRectangle(0, 0, 3*width1, 3*height1); 
newImage("filter backward", "16-bit Black", 3*width1, 3*height1,1);
newImage("static", "16-bit Black", 3*width1, 3*height1,1);

selectWindow("filter forward");
makeRectangle(0, 0, 3*width1, 3*height1); 
run("Copy");
selectWindow("filter backward");
run("Paste");
selectWindow("static");
makeRectangle(width1, height1, 3*width1, 3*height1);
run("Paste");

selectWindow("filter forward");
run("FFT");
getDimensions(width, height, channels, slices, frames);
fillRect(width/2, height/2-1, width/2, height/2+1);
fillRect(0, 0, width/2, height/2+1);
run("Inverse FFT");

makeRectangle(width1, height1, width1, height1);
run("Crop");
saveAs("Tiff", mainfolderpath + File.separator + "kymograph" + File.separator + "kymograph_"+ j + File.separator + "kymograph_" + j + " filtered_forward.tif");
rename("forward filtered");
getStatistics(area, mean, min_forward, max_forward, std, histogram);

selectWindow("FFT of filter forward");
close();
selectWindow("filter forward");
close();

selectWindow("filter backward");
makeRectangle(0, 0, 3*width1, 3*height1); 
run("Flip Horizontally");

run("FFT");
fillRect(width/2, height/2-1, width/2, height/2+1);
fillRect(0, 0, width/2, height/2+1);
run("Inverse FFT");
run("Flip Horizontally");



makeRectangle(width1, height1, width1, height1);
run("Crop");
saveAs("Tiff", mainfolderpath + File.separator + "kymograph" + File.separator + "kymograph_"+ j + File.separator + "kymograph_" + j + " filtered_backward.tif");
rename("backward filtered");
getStatistics(area, mean, min_backward, max_backward, std, histogram);


selectWindow("FFT of filter backward");
close();
selectWindow("filter backward");
close();

selectWindow("static");
makeRectangle(0, 0, 3*width1, 3*height1);
run("FFT");

run("Rotate... ", "angle=-45 grid=1 interpolation=Bilinear"); 
fillRect(width/2, height/2-1, width/2, height/2+1);
fillRect(0, 0, width/2, height/2+1);
run("Rotate... ", "angle=45 grid=1 interpolation=Bilinear");
run("Inverse FFT");

makeRectangle(width1, height1, width1, height1);
run("Crop");
run("Rotate... ", "angle=180 grid=1 interpolation=Bilinear");


saveAs("Tiff", mainfolderpath + File.separator + "kymograph" + File.separator + "kymograph_"+ j + File.separator + "kymograph_" + j + " static.tif");
rename("static filtered");
getStatistics(area, mean, min_static, max_static, std, histogram);

selectWindow("FFT of static");
close();
selectWindow("static");
close();

maximum = maxOf(max_backward,max_forward);
minimum = minOf(min_backward,min_forward);

selectWindow("static filtered");
setMinAndMax(min_static, max_static);
selectWindow("forward filtered");
setMinAndMax(minimum, maximum);
selectWindow("backward filtered");
setMinAndMax(minimum, maximum);

run("Merge Channels...", "c1=[forward filtered] c2=[backward filtered] c3=[static filtered] create");
saveAs("Tiff", mainfolderpath + File.separator + "kymograph" + File.separator + "kymograph_"+ j + File.separator + "kymograph_" + j + " color coded directions.tif");
close();

setBatchMode(false);
selectImage(seqID);
run("Select None");
open(mainfolderpath + File.separator + "kymograph" + File.separator + "kymograph_"+ j + File.separator + LampName + ".tif");
//open(mainfolderpath + File.separator + "kymograph" + File.separator + "kymograph_"+ j + File.separator + "kymograph_" + j + " filtered_forward.tif");
//open(mainfolderpath + File.separator + "kymograph" + File.separator + "kymograph_"+ j + File.separator + "kymograph_" + j + " filtered_backward.tif");
//open(mainfolderpath + File.separator + "kymograph" + File.separator + "kymograph_"+ j + File.separator + "kymograph_" + j + " static.tif");
selectWindow("kymograph1");
close();

setTool("zoom");
run("Tile");
waitForUser("Press okay after Rab11 kymograph generation");
selectWindow("Channel2");
close();
selectWindow("MAX_Channel2");
close();


selectWindow("MAX_Channel1");
open(ROIfile);
activeimgtittle = getTitle();
if (startsWith(activeimgtittle, "AVG_"))
{selectWindow(substring(activeimgtittle,4));}
if (startsWith(activeimgtittle, "MAX_"))
{selectWindow(substring(activeimgtittle,4));}

seqID = getImageID();
setBatchMode(true);
run("Restore Selection");
run("Profile Plot Options...", "width=450 height=200 minimum=0 maximum=0 interpolate draw sub-pixel");
run("Interpolate", "interval=1 smooth");
  

//if (startsWith(File.getName(call("ij.io.OpenDialog.getDefaultDirectory")), "kymograph"))
//
//{if (startsWith(File.getName(File.getParent(call("ij.io.OpenDialog.getDefaultDirectory"))), "kymograph"))
//mainfolderpath = File.getParent(File.getParent((call("ij.io.OpenDialog.getDefaultDirectory"))));
//else mainfolderpath = File.getParent(call("ij.io.OpenDialog.getDefaultDirectory"));}
//
//else if (startsWith(File.getName(call("ij.io.OpenDialog.getDefaultDirectory")), "backward"))
//mainfolderpath = File.getParent(File.getParent(File.getParent(call("ij.io.OpenDialog.getDefaultDirectory"))));
//
//else if (startsWith(File.getName(call("ij.io.OpenDialog.getDefaultDirectory")), "forward"))
//mainfolderpath = File.getParent(File.getParent(File.getParent(call("ij.io.OpenDialog.getDefaultDirectory"))));
//
//else mainfolderpath = call("ij.io.OpenDialog.getDefaultDirectory");
//
//
//if (File.exists(mainfolderpath + File.separator + "kymograph")!=1) {
//	File.makeDirectory(mainfolderpath + File.separator + "kymograph");
//}
//
//
//	i = 1;
//	j = 1;
//  while (File.exists(mainfolderpath + File.separator + "kymograph" + File.separator + "Segment_kymograph_"+ i +".txt")==1) {	
//    	i = i + 1;
//	j = i;
//  }
//
//File.makeDirectory(mainfolderpath + File.separator + "kymograph" + File.separator + "kymograph_"+ j);
//
//saveAs("XY Coordinates", mainfolderpath  + File.separator + "kymograph" + File.separator + "Segment_kymograph_" + j + ".txt");
mainfolderpath = mainpath;

if (File.exists(mainfolderpath + File.separator + "kymograph")!=1) {
	File.makeDirectory(mainfolderpath + File.separator + "kymograph");
}


	i = 1;
	j = 1;
  while (File.exists(mainfolderpath + File.separator + "kymograph" + File.separator + "Segment_kymograph_"+ i +".txt")==1) {	
    	i = i + 1;
	j = i;
  }

File.makeDirectory(mainfolderpath + File.separator + "kymograph" + File.separator + "kymograph_"+ j);

saveAs("XY Coordinates", mainfolderpath  + File.separator + "kymograph" + File.separator + "Segment_kymograph_" + j + ".txt");

/////////////// Line width


			chosen_linewidth = 5;
			chosen_linewidth = 5;
			run("Line Width...", "line=" + chosen_linewidth);

			f_linewidth = File.open( mainfolderpath + File.separator + "kymograph" + File.separator + "kymograph_"+ j +"" + File.separator + "linewidth" + chosen_linewidth + ".txt");

			File.close(f_linewidth);
			
/////////////// Retrieve segment from the saved file
			
	fkymosegment = File.openAsString(mainfolderpath  + File.separator + "kymograph" + File.separator + "Segment_kymograph_" + j + ".txt");

	rows=split(fkymosegment, "\n"); 
	x=newArray(rows.length); 
	y=newArray(rows.length); 
	for(m=0; m<rows.length; m++){ 
	columns=split(rows[m],"\t"); 
	x[m]=parseFloat(columns[0]); 
	y[m]=parseFloat(columns[1]); 
	}
	toUnscaled(x, y);



File.saveString("", mainfolderpath + File.separator + "kymograph" + File.separator + "kymograph_"+ j + File.separator + "kymograph" + j + ".txt") 

getDimensions(width1, height1, channels, slices, frames);

f = File.open( mainfolderpath + File.separator + "kymograph" + File.separator + "kymograph_"+ j + File.separator + "kymograph" + j + ".txt");

   for (k=1; k<slices+1; k++)
	{
	
		setSlice(k);
		
		makeSelection("polyline", x, y);
		profile = getProfile();

		string="";
		for (l=0; l<lengthOf(profile); l++) {
			if (l==0) {
				string=string+profile[l];
			} else {
				string=string+"\t"+profile[l];
			}
			
		}
		print(f, string);
  	}
File.close(f);

run("Line Width...", "line=1");

run("Text Image... ", "open=[" + mainfolderpath + File.separator + "kymograph" + File.separator + "kymograph_"+ j + File.separator + "kymograph" + j + ".txt]");
makeRectangle(1, 0, lengthOf(profile), slices); ///********** this line and the next one are used to delete the first column of the kymograph which does not make sense most of the time (known problem from ImageJ) ********////
run("Crop");

selectWindow("kymograph" + j + ".txt");



saveAs("Tiff", mainfolderpath + File.separator + "kymograph" + File.separator + "kymograph_"+ j + File.separator + HaloName + ".tif");
rename("kymograph" + j);
setTool("zoom");
run("Magenta");

// creation of paved kymograph to reduce edge issues


run("Duplicate...", "title=subFourier1");
run("Duplicate...", "title=subFourier2");
run("Duplicate...", "title=subFourier3");
run("Duplicate...", "title=subFourier4");

selectWindow("subFourier2");
run("Flip Horizontally");

selectWindow("subFourier3");
run("Flip Horizontally");
run("Flip Vertically");

selectWindow("subFourier4");
run("Flip Vertically");


setColor(0);
selectWindow("subFourier1");
run("Copy");
getDimensions(width1, height1, channels, slices, frames);

newImage("filter forward", "16-bit Black", 3*width1, 3*height1,1);

 
makeRectangle(width1, height1, width1, height1); 
run("Paste"); 

selectWindow("subFourier2");
run("Copy");
selectWindow("filter forward");
makeRectangle(0, height1, width1, height1); 
run("Paste"); 
makeRectangle(2*width1, height1, width1, height1); 
run("Paste");

selectWindow("subFourier3");
run("Copy");
selectWindow("filter forward");
makeRectangle(0, 0, width1, height1); 
run("Paste"); 
makeRectangle(2*width1, 0, width1, height1); 
run("Paste");
makeRectangle(0, 2*height1, width1, height1); 
run("Paste"); 
makeRectangle(2*width1, 2*height1, width1, height1); 
run("Paste");

selectWindow("subFourier4");
run("Copy");
selectWindow("filter forward");
makeRectangle(width1, 0, width1, height1); 
run("Paste"); 
makeRectangle(width1, 2*height1, width1, height1); 
run("Paste");

selectWindow("subFourier1");
close();
selectWindow("subFourier2");
close();
selectWindow("subFourier3");
close();
selectWindow("subFourier4");
close();

makeRectangle(0, 0, 3*width1, 3*height1); 
newImage("filter backward", "16-bit Black", 3*width1, 3*height1,1);
newImage("static", "16-bit Black", 3*width1, 3*height1,1);

selectWindow("filter forward");
makeRectangle(0, 0, 3*width1, 3*height1); 
run("Copy");
selectWindow("filter backward");
run("Paste");
selectWindow("static");
makeRectangle(width1, height1, 3*width1, 3*height1);
run("Paste");

selectWindow("filter forward");
run("FFT");
getDimensions(width, height, channels, slices, frames);
fillRect(width/2, height/2-1, width/2, height/2+1);
fillRect(0, 0, width/2, height/2+1);
run("Inverse FFT");

makeRectangle(width1, height1, width1, height1);
run("Crop");
saveAs("Tiff", mainfolderpath + File.separator + "kymograph" + File.separator + "kymograph_"+ j + File.separator + "kymograph_" + j + " filtered_forward.tif");
rename("forward filtered");
getStatistics(area, mean, min_forward, max_forward, std, histogram);

selectWindow("FFT of filter forward");
close();
selectWindow("filter forward");
close();

selectWindow("filter backward");
makeRectangle(0, 0, 3*width1, 3*height1); 
run("Flip Horizontally");

run("FFT");
fillRect(width/2, height/2-1, width/2, height/2+1);
fillRect(0, 0, width/2, height/2+1);
run("Inverse FFT");
run("Flip Horizontally");



makeRectangle(width1, height1, width1, height1);
run("Crop");
saveAs("Tiff", mainfolderpath + File.separator + "kymograph" + File.separator + "kymograph_"+ j + File.separator + "kymograph_" + j + " filtered_backward.tif");
rename("backward filtered");
getStatistics(area, mean, min_backward, max_backward, std, histogram);


selectWindow("FFT of filter backward");
close();
selectWindow("filter backward");
close();

selectWindow("static");
makeRectangle(0, 0, 3*width1, 3*height1);
run("FFT");

run("Rotate... ", "angle=-45 grid=1 interpolation=Bilinear"); 
fillRect(width/2, height/2-1, width/2, height/2+1);
fillRect(0, 0, width/2, height/2+1);
run("Rotate... ", "angle=45 grid=1 interpolation=Bilinear");
run("Inverse FFT");

makeRectangle(width1, height1, width1, height1);
run("Crop");
run("Rotate... ", "angle=180 grid=1 interpolation=Bilinear");


saveAs("Tiff", mainfolderpath + File.separator + "kymograph" + File.separator + "kymograph_"+ j + File.separator + "kymograph_" + j + " static.tif");
rename("static filtered");
getStatistics(area, mean, min_static, max_static, std, histogram);

selectWindow("FFT of static");
close();
selectWindow("static");
close();

maximum = maxOf(max_backward,max_forward);
minimum = minOf(min_backward,min_forward);

selectWindow("static filtered");
setMinAndMax(min_static, max_static);
selectWindow("forward filtered");
setMinAndMax(minimum, maximum);
selectWindow("backward filtered");
setMinAndMax(minimum, maximum);

run("Merge Channels...", "c1=[forward filtered] c2=[backward filtered] c3=[static filtered] create");
saveAs("Tiff", mainfolderpath + File.separator + "kymograph" + File.separator + "kymograph_"+ j + File.separator + "kymograph_" + j + " color coded directions.tif");
close();

setBatchMode(false);
selectImage(seqID);
run("Select None");
open(mainfolderpath + File.separator + "kymograph" + File.separator + "kymograph_"+ j + File.separator + HaloName + ".tif");
//open(mainfolderpath + File.separator + "kymograph" + File.separator + "kymograph_"+ j + File.separator + "kymograph_" + j + " filtered_forward.tif");
//open(mainfolderpath + File.separator + "kymograph" + File.separator + "kymograph_"+ j + File.separator + "kymograph_" + j + " filtered_backward.tif");
//open(mainfolderpath + File.separator + "kymograph" + File.separator + "kymograph_"+ j + File.separator + "kymograph_" + j + " static.tif");
selectWindow("kymograph2");
close();
selectWindow("Channel1");
close();
selectWindow("MAX_Channel1");
close();
selectWindow(MaxfileExtension);
close();

setTool("zoom");
run("Tile");

run("Merge Channels...", "c2=["+LampExtension + "] c6=["+HaloExtension+ "] create keep");
selectWindow("Composite");
saveAs("Tiff", mainfolderpath + File.separator + NewimgName + "_Comp Kymo" + ".tif");

selectWindow("Channel1" + imgName);
run("Magenta");
selectWindow("Channel2" + imgName);
run("Green");
