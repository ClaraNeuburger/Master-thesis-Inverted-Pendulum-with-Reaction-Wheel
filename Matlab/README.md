This folder contains all the main Matlab codes and Simulink simulations used to define the pendulum parameters and establish the control laws. 

Codes 'Identification_TF.m', 'cost_TF.m' and 'verification.m' are used to identify and verify the transfer function of the motor (speed response to a current step input). 

The code 'model_verif.m' is used to superpose the experimental results to the simulation results computed by using Simulink file 'Verification_simulink.slx'. The pendululm was placed upside down, with a current command of 1A during 1 second. 

There are 2 controllers tested: a cascade PID controller and an Linear Quadratic Regulator. 
The LQR is tuned and the gain is computed using the code 'LQR.m', it can then be verified using the simulation 'RegulatorTesting.slx'. 

The cascade PID is tuned using code 'CascadePID.m' and tested using simulation 'PIDcascadeTuning.slx'. 

