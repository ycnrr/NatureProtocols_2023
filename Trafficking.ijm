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
imgName = getTitle();
//sets filepath for Max Intensity image generation
pathfile = mainpath + File.separator + imgName + File.separator;
selectWindow(imgName);
close();
//bypasses settings of KymographClear toolbox
imageDir = mainpath;
fileList = getFileList(imageDir); 
numberSlice=fileList.length;
Number_of_images=1
first_image=1
increment=1
//generates maximum intensity image
run("Image Sequence...", 
  "open=[&pathfile]"+
  " number="+numberSlice+
  " starting="+first_image+
  " increment="+increment+
  " scale=100 "+
  "sort");

	run("Z Project...", " projection=[Max Intensity]");
	setTool("zoom");
//Auto calibrates window and color settings for Max intensity image
for (i=0; i<5; i++) {
run("Enhance Contrast", "saturated=0.35");
}
run("Magenta");
//Very crude way of getting name of KymoClear produced movie
NewimgName = replace(imgName,".tif","")
MaximgName = "MAX_" + NewimgName
//Auto calibrates window and color settings for KymoClear produced movie
selectWindow(NewimgName)
for (i=0; i<5; i++) {
run("Enhance Contrast", "saturated=0.35");
}
run("Magenta");
//Creates user dialog for selection of END1. While loop ensures 'OK' cannot be selected without a valid segment
setTool("polyline");
do {waitForUser("Waiting for user to draw END1. Press okay to continue after selection is defined.");
} while(selectionType()!=6);
END1ROIName = NewimgName + "_END1";
saveAs("Selection", mainpath + END1ROIName);
//Creates user dialog for selection of MID1. While loop ensures 'OK' cannot be selected without a valid segment
setTool("polyline");
do {waitForUser("Waiting for user to draw MID1. Press okay to continue after selection is defined.");
} while(selectionType()!=6);
MID1ROIName = NewimgName + "_MID1";
saveAs("Selection", mainpath + MID1ROIName);
end1filename = END1ROIName + ".roi";
mid1filename = MID1ROIName + ".roi";
end1file = mainpath + File.separator + end1filename + File.separator;
mid1file = mainpath + File.separator + mid1filename + File.separator;
//open END1 for kymo generation
selectWindow(MaximgName);
open(end1file);
//waitForUser("Press okay after END1 kymograph generation");
//selectWindow(MaximgName);
//open(mid1file);
//provides mechanism for breaking running macro if alt is pressed
//for (i = 0; i < 100; i++) {
//    interruptMacro = isKeyDown("alt");
//    if (interruptMacro == true) {
//        print("interrupted");
//        setKeyDown("none");
//        break;
//    }
//    print(i);
//    wait(500);
//}
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



saveAs("Tiff", mainfolderpath + File.separator + "kymograph" + File.separator + "kymograph_"+ j + File.separator + END1ROIName + ".tif");
rename("kymograph" + j);
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
open(mainfolderpath + File.separator + "kymograph" + File.separator + "kymograph_"+ j + File.separator + END1ROIName + ".tif");
//open(mainfolderpath + File.separator + "kymograph" + File.separator + "kymograph_"+ j + File.separator + "kymograph_" + j + " filtered_forward.tif");
//open(mainfolderpath + File.separator + "kymograph" + File.separator + "kymograph_"+ j + File.separator + "kymograph_" + j + " filtered_backward.tif");
//open(mainfolderpath + File.separator + "kymograph" + File.separator + "kymograph_"+ j + File.separator + "kymograph_" + j + " static.tif");

setTool("zoom");
run("Tile");


waitForUser("Press okay after END1 kymograph generation");
selectWindow(MaximgName);
open(mid1file);

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



saveAs("Tiff", mainfolderpath + File.separator + "kymograph" + File.separator + "kymograph_"+ j + File.separator + MID1ROIName + ".tif");
rename("kymograph" + j);
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
open(mainfolderpath + File.separator + "kymograph" + File.separator + "kymograph_"+ j + File.separator + MID1ROIName + ".tif");
//open(mainfolderpath + File.separator + "kymograph" + File.separator + "kymograph_"+ j + File.separator + "kymograph_" + j + " filtered_forward.tif");
//open(mainfolderpath + File.separator + "kymograph" + File.separator + "kymograph_"+ j + File.separator + "kymograph_" + j + " filtered_backward.tif");
//open(mainfolderpath + File.separator + "kymograph" + File.separator + "kymograph_"+ j + File.separator + "kymograph_" + j + " static.tif");

setTool("zoom");
run("Tile");


