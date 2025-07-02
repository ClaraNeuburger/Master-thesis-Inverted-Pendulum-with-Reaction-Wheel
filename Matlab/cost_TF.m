function [out] = cost_TF(x)
global I_in P_mot tps
global cost_log
% Récupération des différents paramètres à optimiser
K=x(1);T1=x(2);

% Calcul de la fonction de transfert
FF=tf([K],[T1,1]);

% Simulation de la fonction de transfert FF connaissant 
% l'entrée I_in et le temps tps
P_mot_sim = lsim(FF,I_in,tps);

% Calcul de l'erreur
E=P_mot_sim-P_mot;

% Calcul de la fonction de cout (somme des carrés des erreurs)
out=E'*E;


% Log values into table
    new_row = {K, T1, out};
    cost_log = [cost_log; new_row];
% Affichage de la fonction de cout
disp(['F_cout=',num2str(out),' ; K=',num2str(K),' ; T1=',num2str(T1)]);

