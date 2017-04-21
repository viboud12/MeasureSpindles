// This macro draws the Feret's Diameter, the longest distance between any two points 
// along the ROI boundary. Feret's Diameter is also known as the caliper length. 
// "Feret's Diameter" is  a standard measurment option in ImageJ 1.29n and later.

// VB: works on a segmented spindle image.

roiManager("Reset");
viboud = getImageID();
run("Analyze Particles...", "size=10-Infinity display exclude include add");
roiManager("Select", 0);

drawFeretsDiameter();

macro "Draw Ferets Diameter" {
    drawFeretsDiameter();
}

macro "Analyze Particles and Draw" {
    run("Analyze Particles...", "show=Nothing exclude clear record");
    drawAllFeretsDiameters();
}

function drawAllFeretsDiameters() {
    for (i=0; i<nResults; i++) {
        x = getResult('XStart', i);
        y = getResult('YStart', i);
        doWand(x,y);
        drawFeretsDiameter();
        if (i%5==0) showProgress(i/nResults);
   }
    run("Select None");
}

function drawFeretsDiameter() {
     requires("1.29n");
     run("Line Width...", "line=1");
     diameter = 0.0;
     getSelectionCoordinates(xCoordinates, yCoordinates);
     n = xCoordinates.length;
     for (i=0; i<n; i++) {
        for (j=i; j<n; j++) {
            dx = xCoordinates[i] - xCoordinates[j];
            dy = yCoordinates[i] - yCoordinates[j];
            d = sqrt(dx*dx + dy*dy);
            if (d>diameter) {
                diameter = d;
                i1 = i;
                i2 = j;
            }
        }
    }
    setForegroundColor(255,127,255);
    setColor("red");
    Overlay.drawLine(xCoordinates[i1], yCoordinates[i1],xCoordinates[i2],yCoordinates[i2]);
    Overlay.show();
}