import org.opencv.objdetect.Objdetect;
import org.openkinect.processing.*;
import org.opencv.core.Core;
import org.opencv.core.Mat;
import gab.opencv.*;

//globals
int x, y;
Kinect kinect;

//background img variables
OpenCV opencv_bg;
Mat mat_bg;
ArrayList<Mat> mat_bg_channels;

//live capture img variables
PImage img;
OpenCV opencv_img;
Mat mat_img;
ArrayList<Mat> mat_img_channels;

void setup() {
    
  //specify screen size
  size(640, 480);
  x = 640;
  y = 480;
  
  //set up kinect
  kinect = new Kinect(this);
  kinect.initVideo();
  kinect.initDepth();
  
  //get backgroud
  PImage background = kinect.getVideoImage().copy();
  
  //set up openCV for background
  opencv_bg = new OpenCV(this, x, y);
  opencv_bg.useColor();
  opencv_bg.loadImage(background);
  mat_bg = opencv_bg.getColor();
  mat_bg_channels = new ArrayList<Mat>();
  Core.split(mat_bg, mat_bg_channels);
    
  //set up openCV for img captures
  opencv_img = new OpenCV(this, x, y);
  opencv_img.useColor();
}

void draw() {
  
  //retrieve kinect image
  img = kinect.getVideoImage();
  opencv_img.loadImage(img);
  mat_img = opencv_img.getColor();
  
  //split into color channels
  mat_img_channels = new ArrayList<Mat>();
  Core.split(mat_img, mat_img_channels);
  
  //subtract each color channel
  for (int i=0; i<3; i++) {
    Core.absdiff(mat_img_channels.get(i), mat_bg_channels.get(i), mat_img_channels.get(i));
  }
  
  //merge color channels
  Core.merge(mat_img_channels, mat_img);
  
  //threshold img
  opencv_img.blur(10);
  opencv_img.threshold(35);
  
  //dilate and erode
  for (int i=0; i<5; i++) {
    opencv_img.dilate();
    opencv_img.erode();
  }
  
  opencv_img.setColor(mat_img);
  
  //convert to grayscale img
  //opencv_img.useGray();
  
  //display image
  image(opencv_img.getSnapshot(), 0, 0);
}