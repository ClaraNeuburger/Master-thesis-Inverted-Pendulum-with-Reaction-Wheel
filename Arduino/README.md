This folder contains all the Arduino scripts used to control the pendulum. 

All the files meant to recover the pendulum's variables from the inertial measurement unit start with 'MPU6050' and where taken from: https://github.com/jrowberg/i2cdevlib

File MPU6050.ino is meant to recover the pendulum angle during live script. 

File Variables.ino defines all variables used in the main file. 

The main.ino file contains the live script to control the Arduino. It recovers the pendulum angle, angular speed and reaction wheel speed to compute the control law using a Linear Quadratic Regulator. It then sends the corresponding DAC value to the microcontroller to control the motor. The current control loop of the ESCON must be previously tuned to achieve control in command. 

