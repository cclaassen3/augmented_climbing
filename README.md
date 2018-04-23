# Augmented Climbing Brickbreaker Game

This project is an augmented rock climbing game that makes use of the Microsoft Kinect's skeletal-tracking technology to project an interactive Brickbreaker game onto a rock climbing wall.

## Release Notes for Version 1.0

### New features

- Implemented a Brickbreaker game with static bricks and a bouncing ball, as well as collision detection algorithms such that the ball moves appropriately around the screen.
- Implemented double-hit bricks that require two ball hits to vanish. These bricks begin with a yellow color, and turn red after they have been hit once.
- Added a home screen with buttons to start the game or view instructions for how to play the game.
- Added adjustable timer between when the player presses the 'start game' button and when the game actually begins.
- Perform skeletal tracking on the climber through the Microsoft Kinect and project the climber's tracke body onto the climbing wall to detect inconsistencies between the climber's true body position and the algorithm's perceived body position.
- Integrated library to allow player to calibrate the projector with the Kinect.
- Added scoring to the game and a transition screen such that on gameover, the score is displayed to the player.
- Made the ball's speed increase over time to incrementally increase difficulty.

### Bug fixes

- Improved skeletal tracking on the Kinect when the player is greater than ~15 feet away from the Kinect
- Fixed the double-hit brick collision detection such that the brick is only hit once now and cannot be double hit.

### Known bugs and defects

- Sometimes the ball can get stuck on one of the edges of the screen and flutter back and forth for a few seconds before properly bouncing off the wall. It seems that this is due to the collision detection algorithm perceiving the ball as being in collision with the ball even after it bounces off the wall already.
- The Kinect can relatively easily 'lose' the climber on the wall and either have no projection of the climber or a completely deformed projection. This problem can be mitigated by having the climber wear colors that more highly contrast the colors of the wall. It also helps when the climber's body more closely resembles the shape of a human from an angle looking directly at the front of back of the body, as that shape is essentialy what the skeletal tracking algorithm is looking for. This issue is also related to the speed at which the UI is drawn and upated, as the game needs to be streamed in realtime for it to be consistent with the climber's current motion. Ultimately, the skeletal tracking is a hardware limitation of the Kinect.
- The KinectProjectorToolkit library used to calibrate the projector with the Kinect is very difficult to use and the calibration process is very lengthy (the link in the 'dependent library' section below leads you to the library's page for setup and calibration instructions). We found that if we place the Kinect direclty on top of the projector, the default calibration works very well and better than it did for any of the instances in which we created our own calibrations.

## Install Guide 

### Prerequisites

The user must have:
- Microsoft Kinect v1
- Microsoft Kinect USB Adapter
- [Processing 2.0](https://processing.org/)
- A laptop/computer
- Officially tested and running on MacOSX 10.11 - 10.13 El Capitan

### Dependent libraries

The software relies on the following dependencies in Processing 2.0:
- OpenCV for Processing v0.5.2
- ControlP5 v2.2.6
- SimpleOpenNI v1.96
- [KinectProjectorToolkit](<https://github.com/genekogan/KinectProjectorToolkit>)

### Download and Install

- Download and extract the codebase by selecting 'Download ZIP' on the green 'Clone or download' button in the top right corner of this repository.
- In your machine's user's Documents directory, there should be a folder called 'Processing'. From the extracted folder, copy the 'libraries' folder into your 'Documents/Processing' folder.
- At this point, the necessary dependencies will be available to applications in the Processing environment.

### Run

- Connect your Kinect v1 to your laptop/computer.
- Connect a projector to your laptop/computer.
- Navigate to the 'augmented_climbing/BrickBreakerWithKinect' folder that was downloaded.
- Open the code in the Processing IDE by double-clicking on the BrickBreakerWithKinect.pde file.
- In the top left of the IDE, click the triangle 'Play' button to run the application.

### Troubleshooting

- During testing and development, due to Kinect dependency issues, the application only runs correctly on the specified OS in the Prerequisites section. If there are errors with the dependent libraries, it is likely an issue with the OS compatibility with that library, so another computer/laptop will need to be used.
- After running the application for a while, the Kinect sometimes disconnects, and if this happens the error message displayed at the bottom of the Processing IDE will say something something about no Kinect object found. This can be fixed easily by disconnecting the Kinect from the power and the laptop/computer and reconnecting it.
