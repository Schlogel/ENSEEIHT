

%Nettoyer l'interface
clc;
clear all;
close all;

%Constantes
Fe = 24000;
Rb = 3000;
Tb = 1/Rb;
Nbits = 1000;
Te = 1/Fe;
V = 1;
alpha = 0.2 ;
L = 8;

% Ts =nTb; avec n=log2(M)
% Ns = floor(Ts / Te);
Te = 1 / Fe;
bits = randi([0 1],1, Nbits);

%% II Modulateur 1

%Mapping
Symboles1 = zeros(1,length(bits));
Symboles1(bits==1) = V;
Symboles1(bits==0) = -V;

%Suréchantillonage
Tsbin =Tb ;
Nsbin = floor(Tsbin / Te);

surech1 = zeros(1,Nsbin);
surech1(1) = 1;
Xk1 = kron(Symboles1,surech1);

%Mise en forme: 
h1=ones(1,Nsbin);
Signal_Filtre1 = filter(h1,1,Xk1);

%Calcul de la DSP du signal obtenue
DSP1 = pwelch(Signal_Filtre1,[],[],[],Fe,"twosided");

%Traçage des courbes du signal passé par le modulateur et de sa DSP
frequence_binaire1 = linspace(-Fe/2,Fe/2,length(DSP1));
temps1 = [0:Te:(length(Signal_Filtre1)-1)*Te];
figure (1);
subplot(2,1,1);plot(temps1, Signal_Filtre1)
xlabel("Temps(s)");
ylabel("Amplitude");
title("Signal passé par le modulateur 1");
grid on;
subplot(2,1,2);semilogy(frequence_binaire1,fftshift(abs(DSP1)));
xlabel("Fréquence(Hz)");
ylabel("Puissance");
title("Densité spectrale de puissance du signal passé par le modulateur 1");
grid on;

%Calcul de la DSP théorique du signal généré
var_a1 = var(Symboles1); 
DSP1_th  = var_a1 * Tsbin*sinc(frequence_binaire1*Tsbin).^2;


%Traçage des DSP obtenues
figure (2);
semilogy(frequence_binaire1,fftshift(abs(DSP1)));
hold on;
semilogy(frequence_binaire1,abs(DSP1_th));
hold off;
title("Représentation de la DSP expérimentale et théorique du modulateur 1");
xlabel("Fréquence(Hz)");
legend({'DSP_{exp}','DSP_{th}'})
ylabel("Puissance");

%% II Modulateur 2



%Mapping
bits4aires=reshape(bits,length(bits)/2, 2);
Vecteur=bi2de(bits4aires);

Symboles2(Vecteur==0) = -3*V;
Symboles2(Vecteur==1) = -V;
Symboles2(Vecteur==2) = 3*V;
Symboles2(Vecteur==3) = V;

%Suréchantillonage
Ts4air =2*Tb ;
Ns4air = floor(Ts4air / Te);
surech2 = zeros(1,Ns4air);
surech2(1) = 1;
Xk2 = kron(Symboles2,surech2);

%Mise en forme: 
h2=ones(1,Ns4air);
Signal_Filtre2 = filter(h2,1,Xk2);

%Calcul de la DSP du signal obtenue
DSP2 = pwelch(Signal_Filtre2,[],[],[],Fe,"twosided");

%Fréquence 4-aire
frequence_4aire = linspace(-Fe/2,Fe/2,length(DSP2));

%Traçage des courbes du signal passé par le modulateur et de sa DSP
temps2 = [0:Te:(length(Signal_Filtre2)-1)*Te];
figure (3);
subplot(2,1,1);plot(temps2,Signal_Filtre2)
xlabel("Temps(s)");
ylabel("Amplitude");
title("Signal passé par le modulateur 2");
grid on;
subplot(2,1,2);semilogy(linspace(-Fe/2,Fe/2,length(DSP2)),fftshift(abs(DSP2)));
xlabel("Fréquence(Hz)");
ylabel("Puissance");
title("Densité spectrale de puissance du signal passé par le modulateur 2");
grid on;

%Calcul de la DSP théorique du signal généré
var_a2 = var(Symboles2); 
DSP2_th  = var_a2 * Ts4air * sinc(frequence_4aire*Tsbin).^2 .* cos(pi*frequence_4aire*Tsbin).^2;

%Traçage des DSP obtenues
figure (4);
semilogy(frequence_4aire,fftshift(abs(DSP2)));
hold on;
semilogy(frequence_4aire,abs(DSP2_th))
hold off;
title("Représentation de la DSP expérimentale et théorique du modulateur 2");
xlabel("Fréquence(Hz)");
legend({'DSP_{exp}','DSP_{th}'})
ylabel("Puissance");

%% II Modulateur 3

%Mapping
Symboles3 = zeros(1,length(bits));
Symboles3(bits==1) = V;
Symboles3(bits==0) = -V;

%Suréchantillonage
Tsbin2 =Tb ;
Nsbin2 = floor(Tsbin2 / Te);
surech3 = zeros(1,Nsbin2);
surech3(1) = 1;
Xk3 = kron(Symboles3,surech3);

%Mise en forme: 
h3=rcosdesign(alpha,L,Nsbin2);
Signal_Filtre3 = filter(h3,1,Xk3);

%Calcul de la DSP du signal obtenue
DSP3 = pwelch(Signal_Filtre3,[],[],[],Fe,"twosided");

%Traçage des courbes du signal passé par le modulateur et de sa DSP
temps3 = [0:Te:(length(Signal_Filtre3)-1)*Te];
frequence_binaire = linspace(-Fe/2,Fe/2,length(DSP3));
figure (5);
subplot(2,1,1);plot(temps3, Signal_Filtre3)
xlabel("Temps(s)");
ylabel("Amplitude");
title("Signal passé par le modulateur 3");
grid on;
subplot(2,1,2);semilogy(frequence_binaire,fftshift(abs(DSP3)));
xlabel("Fréquence(Hz)");
ylabel("Puissance");
title("Densité spectrale de puissance du signal passé par le modulateur 3");
grid on;

%Calcul de la DSP théorique du signal généré
var_a3 = var(Symboles3); 
constante3 = var_a3/Tsbin2;
DSP3_th = zeros(1,length(DSP3));

borne_min = (1-alpha)/(2*Tsbin2);
borne_max = (1+alpha)/(2*Tsbin2);
cond1 = abs(frequence_binaire) <= borne_max;
cond2 = abs(frequence_binaire) <= borne_min;

DSP3_th(cond1) = (Tsbin2/2)*(1 + cos( (pi*Tsbin2/alpha)*(abs(frequence_binaire(cond1))) - borne_min) );
DSP3_th(cond2) = Tsbin2;


%Traçage des DSP obtenues
figure (6);
semilogy(frequence_binaire,fftshift(abs(DSP3)));
hold on;
semilogy(frequence_binaire,abs(DSP3_th));
hold off;
title("Représentation de la DSP expérimentale et théorique du modulateur 3");
xlabel("Fréquence(Hz)");
legend({'DSP_{exp}','DSP_{th}'})
ylabel("Puissance");


%% II Comparaison des DSP

%Traçage des différentes DSP obtenues avec les différents modulateur 
figure (7);
semilogy(frequence_binaire,fftshift(abs(DSP1)));
hold on;
semilogy(frequence_4aire,fftshift(abs(DSP2)));
semilogy(frequence_binaire,fftshift(abs(DSP3)));
hold off;
title("Représentation des DSP obtenues avec les différents modulateurs");
xlabel("Fréquence(Hz)");
legend({'DSP1','DSP2','DSP3'})
ylabel("Puissance");

























