# Inverted Pendulum Actuated by a Reaction Wheel

This github repository contains the codes (Arduino and Matlab) and CAD files used to create a 2D inverted pendulum actuated by a reaction wheel. 
This project was carried out to support the teaching of control engineering at the SAAS (Service d’Automatique et d’Analyse des Systèmes, https://saas.ulb.ac.be/) laboratory at ULB.

## Overview
It consists of a rigid pendulum rod placed on a surface which will be stabilized in the upright position using a motor coupled to a wheel placed on top of the pendulum as shown bellow. 

<p align="center">
  <img src="Images/Full prototype with legend.png" width="450px">
</p>

A video of the working prototype is available in the following link: https://www.youtube.com/shorts/VWwU4DCKMfk

The following sections provide a detailed description of the prototype development process. They cover the design and fabrication of 3D-printed components, the selection of the motor and its integration with the driver, the choice and programming of the microcontroller, the implementation of the control strategy (using an LQR approach), and finally, the verification of the control methods through experimental testing and computation of robustness margins.

