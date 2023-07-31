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

//Z stack to max intensity projection
run("Z Project...", "projection=[Max Intensity]");

//Background subtraction
run("Measure");
background = getResult("Mode");
run("Subtract...", "value=" +background);
run("Enhance Contrast", "saturated=0.35");

//Define ROI
setTool("polyline");
do {waitForUser("Waiting for user to draw ROI around distal axon. Press okay to continue after selection is defined.");
} while(selectionType()!=6);

run("Measure");
intensity = getResult("Mean");
print("Average Flourescence:" +intensity);
