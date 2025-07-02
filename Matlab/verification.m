% Code d'identification d'une fonction de transfert par la méthode
% des moindres carrés

format long;
global I_in P_mot tps       % définition des variables                      

% chargement des données
%Data = load('step_response_cst_intervalle.txt');
%Data = load('filtered_step_response.txt');
%Data = load('NotFiltered_step_response.txt');
%Data = load('verification_step_response.txt');
%Data = load('resampled_data.txt');
%Data = load("Step response 0 to 0.3A try 2_resampled.txt")
Data = load('Step response speed/Step response speed 0.2 to 0.4A_resampled.txt')
% not filtered
%t1 = 3474;                      % séléction de la plage des données
%t2 = 9474; 

%
%t1=3716;
%t2=9716;
%tps = Data(t1:t2,1);
%P_mot = Data(t1:t2,2); 
%I_in = Data(t1:t2,3);
tps = Data(:,1);
P_mot = Data(:,2); 
I_in = Data(:,4);

% La valeur du point est enlevée à chaque mesure
%P_mot = P_mot-P_mot(1); 
P_mot = P_mot - 350;
%P_mot = P_mot - 30;
I_in=I_in-I_in(1);

%K = 9000;

% Validation des paramètres identifiés
% Calcul de la fonction de transfert
%FF=tf([K],[T1,1,0]);
FF= tf([K],[T1,1])

% Simulation de la fonction de transfert FF connaissant 
% l'entrée I et le temps T
%  returns the system response y to the input u, sampled at the same times t as the input
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
%exportgraphics(gcf, 'VerificationTransferFunctionSpeed.pdf', 'ContentType','vector');


