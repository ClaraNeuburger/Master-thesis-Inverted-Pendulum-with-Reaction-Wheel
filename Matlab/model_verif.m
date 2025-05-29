%% Verification of the mathematical model 

%% Model parameters 
K = 0.597;
I = 0.012;
b_p=0.0114;
I_w = 3e-3;
I_r = (I+I_w)/(I*I_w);
G = 7475;
T = 7.611;
b_w=1/(T*I_r);
K_m=G*b_w;

%% State space of the pendulum upside down
A = [0, 1, 0, 0;-K/I, -b_p/I, 0, -b_w/I;0, 0, 0, 1;K/I, b_p/I, 0, -b_w*I_r];
B = [0, 0;-K_m/I, 1/I;0, 0;I_r*K_m, -1/I];
C = [1 0 0 0;0 1 0 0;0 0 1 0;0 0 0 1];
D = [0,0;0,0;0,0;0,0];

%% Plot of the experimental with the simulation 
Data = load('Verification/command 1A 1sec test 1 resampled.txt');
tps = Data(:,1);
theta_p_exp= -Data(:,2); 
dot_theta_w_exp = -Data(:,3);
command_exp = Data(:,4);
figure
plot(tps,theta_p_exp,'b');
hold on;
plot(out.theta_p_nl,'r');
grid
title('Verification of mathematical model');
xlabel('Time(s)')
ylabel('Pendulum position(deg)')
legend('Experimental','Simulation')


figure
plot(tps,dot_theta_w_exp,'b');
hold on;
plot(out.theta_w_nl,'r');
grid
title('Verification of mathematical model');
xlabel('Time(s)')
ylabel('Motor angular speed (rpm)')
legend('Experimental','Simulation')

figure
plot(tps,command_exp);
hold on;
plot(out.command,'r');
grid
title('Verification of mathematical model');
xlabel('Time(s)')
ylabel('Current command (A)')
legend('Experimental','Simulation')
