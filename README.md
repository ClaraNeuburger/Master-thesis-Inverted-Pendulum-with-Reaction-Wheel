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

This type of motor offers an attractive price to performance ratio, a high torques due to external multipole rotor, and a flat and light design meant for limited space. 
The properties of the motor are shown in the table bellow.
<p align="center">
  <img src="Images/EC45Flat.png" width="350px">
</p>

## Driver
In order to control the motor using the microcontroller, a driver needs to be used. A driver serves as the interface between the motor and the microcontroller to control the motor’s speed, direction or other parameter.

The ESCON 50/5 from Maxon compatible with the motor was chosen. 
<p align="center">
  <img src="Images/ESCON.png" width="250px">
</p>

It has 3 integrated operating modes: 

 - Current controller which compares the actual motor current with the applied set value and dynamically adjusts it in case of deviation
 - Closed loop speed controller that compares the actual speed with the applied set value and dynamically adjusts it
 - Open loop speed controller that feeds the motor with a voltage proportional to theset value; the load changes are compensated with IxR methodology

The properties of the driver are shown in the table bellow. 
<p align="center">
  <img src="Images/ESCON tab.png" width="450px">
</p>

The ESCON 50/5 is a programmable driver: on a software developed by Maxon, the user can enter the motor's propreties and select one of the 3 operating modes to control the motor. 

The following process was followed when laucnhing the start up wizard tool: 
- Motor type: Select maxon EC motor
- Motor data: Enter motor speed constant (285 rpm/V), thermal time constant winding (17.7s) and number of pole pairs (8)
- System data: Enter desired maximum speed (5240 rpm but you can increase if needed), nominal current (2.33 A) and max output current limit
- Detection of rotor position: Select digital Hall sensors with Maxon Hall sensor polarity
- Speed sensor: Select available Hall effect sensor
- Mode of operation: Select current controller
- Enable: Select your desired digital input with high active. In this situation, a switch was placed between digital Input 2 and the +5Vdc of the ESCON to easily enable the motor
- Set value: Select analog set value, with the analog input connected to the DAC pin of the microcontroller (here analog input 1). Since the Arduino DAC output is able to send voltages from 0.55 V to 2.75 V, the current sent at 0.55 V is set at -2.33 A and the current sent at 2.75 V is set at 2.33 A.
- ADD SPEED RAMP, OFFSET AND MINIMAL SPEED (need to check the computer for that)


## Sensors
### Inertial Measurement Unit (IMU)
### Hall effect sensors


## 3D design and printing
