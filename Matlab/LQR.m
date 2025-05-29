%% === LQR === 
% This matlab code is a summary of the research conducted to tune the LQR

%% Model parameters LQR 1
K = 0.597;
I = 0.012;
b_p=0.0114;
I_w = 3e-3;
I_r = (I+I_w)/(I*I_w);
G = 7475;
T = 7.611;
b_w=1/(T*I_r);
K_m=G*b_w;

%% Model parameters LQR 2
K = 0.597;
I = 0.011;
b_p=0.0314;
I_w = 3e-3;
I_r = (I+I_w)/(I*I_w);
G = 7475;
T = 6.8;
b_w=1/(T*I_r);
K_m=G*b_w;

%% State space
A = [0, 1, 0;K/I, -b_p/I, b_w/I;-K/I, b_p/I, -b_w*I_r];
B = [0;-K_m/I;I_r*K_m];
C = [1 0 0;0 1 0;0 0 1];
D = [0;0;0;0]; 

%% Matrices Q and R
Q = [100 0 0;
     0 5.9e-4*100 0;
     0 0 50];

R = 1e7;
[K_lqr, ~, p] = lqr(A, B, Q, R);

%% Nyquist plot 
L = ss(A, B, K_lqr, 0);
nyquist(L);

%% Nyquist plot for GM
gamma=0.42;
L_gm = ss(A, B, gamma*K_lqr, 0);
nyquist(L_gm)

%% Nyquist for PM
phi = 61.1;  
L_pm = L * exp(-1j * deg2rad(phi)); 
nyquist(L_pm);

%% Algorithm 1 
for gamma = 1:-0.05:0.1
    L_scaled = gamma * L;
    CL = feedback(L_scaled, 1);  
    stable = all(real(pole(CL)) < 0);
    fprintf("Gain: %.2f → Stable: %d\n", gamma, stable);
end

%% Details for search of Q and R

Q = eye(4);
R_values = logspace(6, 10, 50); 

mean_ratio_theta_p = zeros(size(R_values));
mean_ratio_theta_w = zeros(size(R_values));

max_command = 2.33; 

% Loop over different R values
for i = 1:length(R_values)
    R = R_values(i); 
    
    [K_lqr, ~, ~] = lqr(A, B, Q, R);
    
    A_cl = A - B * K_lqr;
    
  
    x0 = [20; 0; 0; 0];
    t = linspace(0, 10, 1000); 
    
    ode_fun = @(t, x) A_cl * x + min(max(B * K_lqr * x, -max_command), max_command);  % Hard clipping


    [~, x] = ode45(ode_fun, t, x0);
    

    theta_p = x(:,1);
    dot_theta_p = x(:,2);
    theta_w = x(:,3);
    dot_theta_w = x(:,4);
    
    valid_p = dot_theta_p ~= 0;
    valid_w = dot_theta_w ~= 0;
    
    mean_ratio_theta_p(i) = mean(theta_p(valid_p) ./ dot_theta_p(valid_p), 'omitnan');
    mean_ratio_theta_w(i) = mean(theta_w(valid_w) ./ dot_theta_w(valid_w), 'omitnan');
end

% Compute the overall average of the mean 
overall_mean_theta_p = mean(mean_ratio_theta_p, 'omitnan');
overall_mean_theta_w = mean(mean_ratio_theta_w, 'omitnan');

fprintf('Overall mean of \\theta_p / \\dot{\\theta_p}: %.4f\n', overall_mean_theta_p);
fprintf('Overall mean of \\theta_w / \\dot{\\theta_w}: %.4f\n', overall_mean_theta_w);

