%% === PID Cascade === 
% This matlab code is a summary of the research conducted to tune the
% cascade PID

%% Model parameters 
K = 0.597;
I = 0.011;
b_p=0.0314;
I_w = 3e-3;
I_r = (I+I_w)/(I*I_w);
G = 7475;
T = 6.8;
b_w=1/(T*I_r);
K_m=G*b_w;
%% Inner and outer loop transfer functions
% Inner loop TF
num_in = [1.049];
denom_in = [0.2,1];
G_in = tf(num_in, denom_in);

% Outer loop TF
num_out = [1,0];
denom_out = [-I_r*I,b_p/I-b_p*I_r,-K/I+K*I_r];
G_out = tf(num_out,denom_out);

G = G_in*G_out;

%% Controller tuned with rltool()
num_C = [-42.18, - 1279, - 9440];
denom_C = [0.0001834,1,0.01];
C = tf(num_C,denom_C);
disp('Controller transfer function:');
disp(C);

%% Continuous roubsutness margins
H = C*G;

w = logspace(-4, 2, 1000);  % 10^-4 to 10^2 rad/s

[mag, phase] = bode(H, w);

mag = squeeze(mag);
phase = squeeze(phase);

% Compute margins over this range
[GM, PM, Wcg, Wcp] = margin(mag, phase, w);

fprintf('GM = %.2f dB at %.2f rad/s\n', 20*log10(GM), Wcg);
fprintf('PM = %.2f° at %.2f rad/s\n', PM, Wcp);

%% Discrete robustness margins
Ts = 0.01;
G_d = G * tf(1, 1, 'InputDelay', Ts);
H_d = C*G_d;

w = logspace(-4, 2, 1000);  % 10^-4 to 10^2 rad/s

[mag, phase] = bode(H_d, w);

mag = squeeze(mag);
phase = squeeze(phase);

% Compute margins over this range
[GM, PM, Wcg, Wcp] = margin(mag, phase, w);

fprintf('GM = %.2f dB at %.2f rad/s\n', 20*log10(GM), Wcg);
fprintf('PM = %.2f° at %.2f rad/s\n', PM, Wcp);


%% Disturbance rejection

% Discretize controller and plant
C_tustin = c2d(C, Ts, 'tustin');
G_tustin = c2d(G, Ts, 'tustin');

% Closed-loop from disturbance to output
T_dist_cont = G / (1 + C*G);                     
T_dist_tustin = G_tustin / (1 + C_tustin*G_tustin);  

t = 0:Ts:2;
figure;
step(T_dist_cont, t, 'b'); hold on;
step(T_dist_tustin, t, 'r');

xlabel('Time')
ylabel('Pendulum angle (deg)')
legend('Continuous', 'Tustin');
title('Disturbance Rejection: Continuous vs Tustin');
grid on;
