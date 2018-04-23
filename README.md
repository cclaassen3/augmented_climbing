# Augmented Climbing

Augmented Climbing experience using Kinect skeletal-tracking technology to project interactive games onto a climbing wall.


# Release Notes

## New features

- Added scoring to the game. Each brick is valued at 10 points per hardness level. When the game is over, the current score and potential total score are shown.
- Speed of ball increases over time

## Bug fixes

- None

## Known bugs and defects

- Sometimes, it fails to detect collisions, so the ball may get stuck inside the projection of the player. Also, when the ball may trigger a double collision for a brick. This is related to the speed at which the UI is drawn and updated.

# Install Guide 

## Pre-requisites

The user must have:
- Microsoft Kinect v1
- Microsoft Kinect USB Adapter
- A laptop/computer
- Processing 2.0 installed on the laptop
- Officially tested and running on MacOSX 10.11 - 10.13 El Capitan

## Dependent libraries

The software relies on the following dependencies in Processing:
- OpenCV for Processing v0.5.2
- ControlP5 v2.2.6
- SimpleOpenNI v1.96
- KinectProjectorToolkit: <https://github.com/genekogan/KinectProjectorToolkit>

## Download and Install

- Download and extract the software from https://github.com/cclaassen3/augmented_climbing
- In your machine's user's Documents directory, there should be a folder called 'Processing'. From the extracted folder, copy the 'libraries' folder into your 'Documents/Processing' folder.
- At this point, the necessary dependencies will be available to applications in the Processing environment.

## Run

- Connect your Kinect v1 to your laptop/computer.
- Navigate to the '\augmented_climbing\BrickBreakerWithKinect' folder that was downloaded.
- Open any of the Processing files in the Processing 2.0 IDE.
- In the top left of the IDE, click the triangle 'Play' button to run the application.

## Troubleshooting

- During testing and development, due to Kinect dependency issues, the application only runs correctly on the specified OS in the Pre-Requisites section. 