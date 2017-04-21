// Runs on a folder of images that have a single timepoint.
// Gives you a sterotyped box size (115x115 pixels) that you place over your
// cell of interest and it will save a TIFF of that region in one folder
// (all slices and channels) and a maximum intensity projection in another
// folder (both are user defined).

dir2 = getDirectory("Choose Destination Directory for Input");
dir4 = getDirectory("Choose Destination Directory for RAW images");
dir5 = getDirectory("Choose Destination Directory for MAX images");

images = getFileList(dir2);
list = getFileList(dir2);

setBatchMode(true);

for (i=0; i < list.length; i++) {
 inputpath = dir2 + images[i];
 run("Bio-Formats Windowless Importer", "open=inputpath");
 t = getTitle();

 viboud = getImageID();


setBatchMode("exit & display");
selectImage(viboud);
run("Duplicate...", "duplicate");
viboud3 = getImageID();
selectImage(viboud);
close();
selectImage(viboud3);
getDimensions(width, height, channels, slices, frames);
// was 100x100
makeRectangle(45, 45, 115, 115);
Stack.setPosition(2,2,1);
title = "Put rectangle around embryo and click OK";
  	waitForUser(title);
setBatchMode(true);  	
run("Duplicate...", "duplicate");
viboud4 = getImageID();
t5 = t + '_RAW';
saveAs("Tiff", dir4 + t5 + ".tif");

selectImage(viboud4);
run("Z Project...", "projection=[Max Intensity] all");
MAXviboud = getImageID();

// I'm assuming that Tubulin and Asterless are either in channels 2,3 or 3,4
// Would be difficult to generalize this to different channels...

getDimensions(width, height, channels, slices, frames);
if (channels == 3) {
	run("Duplicate...", "duplicate channels=2-3");
	MAXviboud2 = getImageID();
	t6 = t + '_MAX';
	saveAs("Tiff", dir5 + t6 + ".tif"); 
	setBatchMode("exit & display");
	selectImage(viboud3);
	close();
	selectImage(viboud4);
	close();
	selectImage(MAXviboud);
	close();
	selectImage(MAXviboud2);
	close();
} else {
	run("Duplicate...", "duplicate channels=3-4");
	MAXviboud2 = getImageID();
	t6 = t + '_MAX';
	saveAs("Tiff", dir5 + t6 + ".tif"); 
	setBatchMode("exit & display");
	selectImage(viboud3);
	close();
	selectImage(viboud4);
	close();
	selectImage(MAXviboud);
	close();
	selectImage(MAXviboud2);
	close();	
}
}