// Works on projections of images containing a tubulin stain in
// channel 1


run("Set Measurements...", "area perimeter fit shape feret's  display redirect=None decimal=4");
roiManager("Reset");
run("Clear Results");

dir2 = getDirectory("Choose Destination Directory for Input");
dir4 = getDirectory("Choose Destination Directory for Output");

setBatchMode(true);

images = getFileList(dir2);
list = getFileList(dir2);
for (i=0; i < list.length; i++) {
 inputpath = dir2 + images[i];
 run("TIFF Virtual Stack...", "open=inputpath");
 t = getTitle();

// edge detector

CELLviboud = getImageID();
t = getTitle();
getPixelSize(unit, pixelWidth, pixelHeight);
pixsize = 1/pixelWidth; 
run("Duplicate...", "duplicate channels=1");
run("Grays");
Tubulin = getImageID();
run("Area filter...", "median=12 deriche=1 hysteresis_high=90 hysteresis_low=10");
run("Invert LUT");
run("Dilate");
run("Remove Outliers...", "radius=3 threshold=50 which=Dark");
//run("Despeckle");
//run("Erode");
mask1 = getImageID();
rename("Edge");
//close();

selectImage(Tubulin);
close();

// tubeness detector

selectImage(CELLviboud);
run("Duplicate...", "duplicate channels=1");
CELLviboud1 = getImageID();
run("Grays");
run("Tubeness", "sigma=0.13 use");
getStatistics(area, mean, min, max, std, histogram);
favThresh = min + 0.135*(max-min);
setThreshold(favThresh, max);
run("Convert to Mask");
run("Despeckle");
mask2 = getImageID();
rename("Tubeness");
//close();


// tubulin fluorescence intensity detector

selectImage(CELLviboud);
run("Duplicate...", "duplicate channels=1");
run("Grays");
getStatistics(area, mean, min, max, std, histogram);
favThresh = min + 0.55*(max-min);
setThreshold(favThresh, max);
run("Convert to Mask");
run("Despeckle");
mask3 = getImageID();
rename("Tubulin");
//close();


selectImage(CELLviboud1);
close();

imageCalculator("Add create", mask1,mask2);
int1 = getImageID();
run("Minimum...", "radius=1");
run("Maximum...", "radius=3");
imageCalculator("Add create", int1,mask3);
//int2 = getImageID();
//imageCalculator("Add create", int2,mask4);
run("Fill Holes");
run("Despeckle");
run("Maximum...", "radius=3");
run("Minimum...", "radius=4");
run("Median...", "radius=2");
run("Fill Holes");
final = getImageID();

selectImage(mask1);
close();
selectImage(mask2);
close();
selectImage(mask3);
close();
selectImage(int1);
close();

selectImage(final);
run("Set Scale...", "distance=pixsize known=1 pixel=1 unit=micron");
rename(t);
run("Analyze Particles...", "size=10-Infinity display exclude include add");

selectImage(final);
close();
}

t3 = t + 'measurements';
if (nResults==0) exit("Results table is empty");
   saveAs("Measurements", dir4 + t3 + ".xls");

//setBatchMode("exit & display");