import org.openkinect.processing.*;

Kinect kinect;

void setup() {
  size(640, 360);
  
  kinect = new Kinect(this);
  kinect.initVideo();
  kinect.initDepth();
  kinect.enableIR(true);
}

void draw() {
  PImage img = kinect.getVideoImage();
  //PImage img = kinect.getDepthImage();
  image(img, 0, 0);
}