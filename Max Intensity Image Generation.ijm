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
//Splits channels
run("Split Channels");
//Generates two subfolders for the channels
C1Path = mainpath + File.separator + "GFP-Rab6a" + File.separator;
C2Path = mainpath + File.separator + "Halo 1.7" + File.separator;
File.makeDirectory(C1Path);
File.makeDirectory(C2Path);
C1fileName = "C1-" + imgName
C2fileName = "C2-" + imgName
selectWindow(C1fileName);
saveAs("Tiff", C1Path + C1fileName);
close();
selectWindow(C2fileName);
saveAs("Tiff", C2Path + C2fileName);
close();
//sets filepath for channel 1 Max intensity image generation
pathfileC1 = C1Path + File.separator + C1fileName + File.separator;
//bypasses settings of KymographClear toolbox
imageDir=C1Path;
fileList = getFileList(imageDir); 
numberSlice=fileList.length;
Number_of_images=1
first_image=1
increment=1
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
Number_of_images=1
first_image=1
increment=1
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
		

