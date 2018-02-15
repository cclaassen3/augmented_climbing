import org.opencv.objdetect.Objdetect;
import org.openkinect.processing.*;
import org.opencv.core.MatOfRect;
import org.opencv.core.MatOfInt;
import org.opencv.core.Scalar;
import org.opencv.core.Core;
import org.opencv.core.Mat;
import gab.opencv.*;

int x, y;
Kinect kinect;
OpenCV opencv_bg;
OpenCV opencv_img;
PImage background;
Mat mat_bg;

//Mat mat_ones = new Mat(x,y,0, new Scalar((double)1));

void setup() {
  
  //specify screen size
  size(640, 480);
  x = 640;
  y = 480;
  
  //set up kinect
  kinect = new Kinect(this);
  kinect.initVideo();
  kinect.initDepth();
  
  //initialize backgroud
  //delay(1000);
  background = kinect.getVideoImage().copy();
  
  //set up openCV
  opencv_bg = new OpenCV(this, x, y);
  opencv_img = new OpenCV(this, x, y);
  opencv_bg.loadImage(background);
  mat_bg = opencv_bg.getGray();
}


void draw() {
  
  //retrieve kinect image
  PImage img = kinect.getVideoImage();
  opencv_img.loadImage(img);
  Mat mat_img = opencv_img.getGray();

  //subtract background for all color channels
  Core.absdiff(mat_img, mat_bg, mat_img);
  opencv_img.blur(10);
  opencv_img.threshold(35);
  
  //opencv.threshold(60);
  for (int i=0; i<5; i++) {
    opencv_img.dilate();
    opencv_img.erode();
  }
  
  //ensure single object detection
  opencv_img.dilate();
  opencv_img.dilate();
  opencv_img.dilate();
  opencv_img.dilate();
  opencv_img.erode();
  opencv_img.erode();
  opencv_img.erode();
  opencv_img.erode();
  
  //print(mat_img.size());
  
  //cluster to create unified object
  //Objdetect.groupRectangles(new MatOfRect(mat_img), new MatOfInt(mat_ones), 5);

  //opencv_img.findCannyEdges(2,20);
  //opencv_img.findSobelEdges(1,1);
  //opencv_img.findScharrEdges(-1);
  
  //display image
  image(opencv_img.getSnapshot(), 0, 0);
}