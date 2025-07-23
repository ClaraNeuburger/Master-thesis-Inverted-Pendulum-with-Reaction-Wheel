# Inverted Pendulum Actuated by a Reaction Wheel

This github repository contains the codes (Arduino and Matlab) and CAD files used to create a 2D inverted pendulum actuated by a reaction wheel. 
This project was carried out to support the teaching of control engineering at the SAAS (Service d’Automatique et d’Analyse des Systèmes, https://saas.ulb.ac.be/) laboratory at ULB. The resulting Master thesis text is also available in this repository under 'Master Thesis Text.pdf'

## Overview
It consists of a rigid pendulum rod placed on a surface which will be stabilized in the upright position using a motor coupled to a wheel placed on top of the pendulum as shown bellow. 

<p align="center">
  <img src="Images/Full prototype with legend.png" width="450px">
</p>

A video of the working prototype is available in the following link: https://www.youtube.com/shorts/VWwU4DCKMfk

The following sections provide a detailed description of the prototype development process. They cover the design and fabrication of 3D-printed components, the selection of the motor and its integration with the driver, the choice and programming of the microcontroller, the implementation of the control strategy (using an LQR approach), and finally, the verification of the control methods through experimental testing and computation of robustness margins.

## Microcontroller
The Arduino Due was selected as the development board for this project due to its higher computational performance and advanced features. Its 84 MHz clock speed enables faster signal processing, essential for real-time applications. The Due provides a DAC (Digital-to-Analog Converter) for smoother analog outputs, as well as a larger SRAM (96 kB), allowing efficient handling of complex computations and storage of runtime variables.

<p align="center">
  <img src="Images/Arduino.png" width="250px">
</p>

The codes implemented on the microcontroller for controlling the pendulum are available in the folder 'Arduino'. 

- Scripts starting with *MPU6050* handle the data received from the Inertial Measurement Unit (IMU) and taken from: https://github.com/jrowberg/i2cdevlib
- File *Variables.ino* defines all variables used for the real time control of the pendulum
- File *main.ino* conatins the live script for controlling the pendulum

## Motor
The motor should be as lightweight as possible while also providing maximum torque. A Maxon brushless DC motor was selected: the EC 45 Flat. 
<p align="center">
  <img src="Images/EC45 Flat.jpg" width="250px">
</p>

! Add table of motor properties 

## Driver

## Sensors
### Inertial Measurement Unit (IMU)
### Hall effect sensors


## 3D design and printing
