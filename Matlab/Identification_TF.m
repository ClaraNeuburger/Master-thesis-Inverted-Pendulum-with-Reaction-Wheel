% Code d'identification d'une fonction de transfert par la méthode
% des moindres carrés

%close all;clear all;
format long;
global I_in P_mot tps      
global cost_log
cost_log = table([], [], [], 'VariableNames', {'K', 'T1', 'Cost'});


Data = load('Step response speed/Step response speed 0.2 to 0.3A_resampled.txt');

tps = Data(:,1);
P_mot = Data(:,2); 
I_in = Data(:,4);

P_mot = P_mot-300; 
I_in=I_in-I_in(1);

K = 1;
T1=0.25;

% Global storage for parameters and cost at each iteration
global history
history.x = [];
history.fval = [];


% Optimisation
X0=[K T1];
%options = optimset('Tolfun',1e-10);
%options = optimset('Display', 'iter', 'OutputFcn', @outfun);
options = optimset('Tolfun',1e-10);  % base options
options = optimset(options, 'Display', 'iter', 'OutputFcn', @outfun);  
%X = fminsearch('cost_TF',X0,options);
[X, fval_opt] = fminsearch('cost_TF',X0,options);


% Récupération des paramètres identifiés
K=X(1); T1=X(2);

% Affichage des paramètres identifiés
clc
disp(['K=',num2str(K)]);
disp(['T1=',num2str(T1)]);
num_c=[K];
den_c=[T1,1];
disp(['Numérateur de la fonction de transfert = [',num2str(num_c),']']);
disp(['Dénominateur de la fonction de transfert = [',num2str(den_c),']']);

% Validation des paramètres identifiés
% Calcul de la fonction de transfert
%FF=tf([K],[T1,1,0]);
FF= tf([K],[T1,1])
%FF = tf([2000],[0.25,1])
% Simulation de la fonction de transfert FF connaissant 
% l'entrée I et le temps T
P_mot_sim = lsim(FF,I_in,tps);

% Affichage de la fonction de transfert identifiée
FF

% Affichage des températures mesurée et simulée
figure
plot(tps,P_mot,'b');
hold on;
plot(tps,P_mot_sim,'r');
grid
title('Transfer function identification');
xlabel('Time (s)')
legend('Data','Identification')
%exportgraphics(gcf, 'IdentificationTransferFunctionSpeed.pdf', 'ContentType','vector');

figure
subplot(3,1,1)
plot(history.fval, '-o', color='b')
xlabel('Iteration')
ylabel('Cost')
title('Cost Function Value Over Iterations')
grid on

% Plot K evolution
subplot(3,1,2)
plot(history.x(:,1), '-o',color='b')
xlabel('Iteration')
ylabel('G Value')
title('Evolution of G')
grid on

% Plot T1 evolution
subplot(3,1,3)
plot(history.x(:,2), '-o',color='b')
xlabel('Iteration')
ylabel('tau Value')
title('Evolution of tau')
grid on


% Define the output function
function stop = outfun(x, optimValues, state)
    global history
    stop = false;
    if isequal(state, 'iter')
        history.x(end+1, :) = x;
        history.fval(end+1, 1) = optimValues.fval;
    end
end