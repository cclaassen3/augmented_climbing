this file will interface with the kinect to do hand tracking.

it does this by configuring the hand to be within a specific depth range away from the kinect and then computing the centroid of all the pixels within that depth range. to configure that range, use the UP button to set the range to be further away from the kinect and the DOWN button to set the range to be closer to the kinect. the video stream will display the pixels in focus in red, so you should adjust this setting until the hand at the desired location is in focus.

note: this should not be our implementation to track the climber, but it could work for pressing buttons to control the game.