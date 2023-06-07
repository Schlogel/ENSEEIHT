%Nettoyer l'interface
clc;
clear all;
close all;

%Données
Fc = 1080;
DeltaF = 100;
Nbits = 1000;
Fe = 48000;
Rb = 300;
Phi0 = rand*2*pi;
Phi1 = rand*2*pi;

%Calculs
F0 = Fc + DeltaF;
F1 = Fc - DeltaF;
Te = 1 / Fe;
Tb = 1 / Rb;
Ts = Tb;
Ns = floor(Ts / Te);
Temps = [0:Te:(Ns*Nbits-1)*Te];

%% 3
%3.1.1
%Génération du signal NRZ
bits = randi([0 1],1, Nbits);
NRZ = kron(bits,ones(1,Ns));

%%
%3.1.2
%Représentation du signal NRZ
figure (1); plot([0:Te:(length(NRZ)-1)*Te],NRZ)
xlabel("Temps(s)");
ylabel("Bits");
title("Réprésentation du signal NRZ");
grid on;

%%
%3.1.3
%Calcul de la DSP de NRZ
DSP_NRZ=pwelch(NRZ,[],[],[],Fe,'twosided');

%Rprésentation de la DSP de NRZ
F=linspace(-Fe/2,Fe/2,length(DSP_NRZ));
figure (5); semilogy(F,fftshift(DSP_NRZ))
xlabel("Fréquences(Hz)");
ylabel("DSP");
title("Réprésentation de la densité spectrale de puissance de NRZ");

%%
%3.1.4
%Calcul de la DSP de NRZ théorique
DSP_NRZ_Theo = (1/4) * Ts * (sinc(F*Ts)).^2 + (1/4) * dirac(F);

%Représentation de la DSP de NRZ avec la DSP de NRZ théorique
figure (2); semilogy(F,fftshift(DSP_NRZ))
xlabel("Fréquences(Hz)");
ylabel("DSP");
title("Réprésentation de la densité spectrale de puissance de NRZ");
grid on;
hold on;
semilogy(F,DSP_NRZ_Theo)
legend({'DSP de NRZ','DSP de NRZ Théorique'})
hold off;

%%
%3.2.1
%Génération du signal modulé en fréquence
x = (1 - NRZ) .* cos(2*pi*F0*Temps + Phi0 ) + NRZ .* cos(2*pi*F1*Temps + Phi1 );

%%
%3.2.2
%Représentation du signal modulé en fréquence (x)
figure (3); plot(Temps,fftshift(x))
xlabel("Temp(s)");
ylabel("x(t)");
title("Réprésentation du signal modulé x(t)");
grid on;

%%
%3.2.4
%Calcul de la DSP de x
DSP_x=pwelch(x,[],[],[],Fe,'twosided');

%Représentation de la DSP de x
Marge = linspace(-Fe/2,Fe/2,length(DSP_x));
figure (4); semilogy(Marge,fftshift(DSP_x))
xlabel("Fréquence(Hz)");
ylabel("Puissance");
title("DSP du signal modulé x(t)");
grid on;