// Works on projections of images containing a tubulin stain in
// channel 1 and a centrosomal stain in channel 2


run("Set Measurements...", "area perimeter fit shape feret's  display redirect=None decimal=4");
roiManager("Reset");
run("Clear Results");

//dir2 = getDirectory("Choose Destination Directory for Input");
//dir4 = getDirectory("Choose Destination Directory for Output");

setBatchMode(true);

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
mask1 = getImageID();
rename("Edge");

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

// asterless fluorescence intensity detector

selectImage(CELLviboud);
run("Duplicate...", "duplicate channels=2");
run("Grays");
getStatistics(area, mean, min, max, std, histogram);
// was 0.2
favThresh = min + 0.3*(max-min);
setThreshold(favThresh, max);
run("Convert to Mask");
mask4 = getImageID();
rename("Asterless");

selectImage(CELLviboud1);
close();

imageCalculator("Add create", mask1,mask2);
int1 = getImageID();
run("Minimum...", "radius=1");
run("Maximum...", "radius=3");
imageCalculator("Add create", int1,mask3);
int2 = getImageID();
imageCalculator("Add create", int2,mask4);
run("Fill Holes");
run("Despeckle");
run("Maximum...", "radius=2");
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
selectImage(mask4);
close();
selectImage(int1);
close();
selectImage(int2);
close();

selectImage(final);
run("Set Scale...", "distance=pixsize known=1 pixel=1 unit=micron");
rename(t);
run("Analyze Particles...", "size=10-Infinity display exclude include add");

setBatchMode("exit & display");