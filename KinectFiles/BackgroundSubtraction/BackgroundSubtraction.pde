import org.openkinect.processing.*;
import org.opencv.core.Core;
import org.opencv.core.Mat;
import gab.opencv.*;

int x, y;
Kinect kinect;
OpenCV opencv_bg;
OpenCV opencv_img;
PImage background;
Mat mat_bg;
//Mat mat_bg_r;
//Mat mat_bg_b;
//Mat mat_bg_g;

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
  //opencv_bg.useColor();
  opencv_img = new OpenCV(this, x, y);
  opencv_bg.loadImage(background);
  mat_bg = opencv_bg.getGray();
  //mat_bg_r = opencv_bg.getR();
  //mat_bg_g = opencv_bg.getG();
  //mat_bg_b = opencv_bg.getB();
  //print(mat_bg_r.channels());
}


void draw() {
  
  //retrieve kinect image
  PImage img = kinect.getVideoImage();
  opencv_img.loadImage(img);
  Mat mat_img = opencv_img.getGray();
  //Mat mat_img_r = opencv_img.getR();
  //Mat mat_img_g = opencv_img.getG();
  //Mat mat_img_b = opencv_img.getB();
  
  //subtract background
  //Core.absdiff(mat_img_r, mat_bg_r, mat_img_r);
  //Core.absdiff(mat_img_g, mat_bg_g, mat_img_g);
  //Core.absdiff(mat_img_b, mat_bg_b, mat_img_b);
  
  //opencv_img.setR

  //Mat mat_img_all = opencv_img.getGray();
  //Core.split(mat_img_all, mat_img);
  
  //subtract background for all color channels
  Core.absdiff(mat_img, mat_bg, mat_img);
  //opencv_img.threshold(60);
  
  //opencv.threshold(60);
  //opencv.invert();
  //opencv.dilate();
  //opencv.dilate();
  //opencv.erode();
  //opencv.blur(10);
  
  //opencv.findCannyEdges(50,300);
  //opencv.findSobelEdges(1,1);
  
  //display image
  image(opencv_img.getSnapshot(), 0, 0);
}