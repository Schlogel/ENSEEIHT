%Nettoyer l'interface
clc;
clear all;
close all;

% Donéées
F0 = 6000;
F1 = 2000;
fc = 4000;
Fe = 48000;

Phi0 = rand*2*pi;
Phi1 = rand*2*pi;

Rb = 300;
Te = 1 / Fe;
Tb = 1 / Rb;
Ts = Tb;
Ns = floor(Ts / Te);
Nbits = 300;
bits = randi([0 1],1, Nbits);
NRZ = kron(bits,ones(1,Ns));
ordre = 61;
retard = (ordre-1)/2;

Temps = 0:Te:(Ns*Nbits-1)*Te;

cons = 2*fc / Fe;
Ech61 = [-(ordre-1)/2:(ordre-1)/2];


%Signal en entrée du canal(modulé sans bruit)
x = (1 - NRZ) .* cos(2*pi*F0*Temps + Phi0 ) + NRZ .* cos(2*pi*F1*Temps + Phi1 ); %Les bits 1 sont conservé par le passe bas, et les 0 par le passe haut

%% 4
%Differents parametres du bruit 
SNR = 50;
Px= mean(abs(x).^2);
Pb = Px / (10^(SNR/10));
bruit = sqrt(Pb)*randn(1,length(x));
TEB5=50;

% x_bruit est mon signal x avec un bruit.
x_bruit= x+bruit; 

DSP = fft(x,2048);

%% 5
%5.1 
%Réponse impulsionnelle du filtre passe-bas suivie de sa transformé de
%Fourier
hipb = cons * sinc(cons*Ech61);
HIPB = fft(hipb,length(DSP));

%%
%5.2.1
%Réponse impulsionnelle d'un filtre passe-haut suivie de sa transformé de
%Fourier
hiph = - hipb;
hiph((ordre-1)/2 +1) = 1 - cons;
HIPH = fft(hiph,length(DSP));

%%
%5.2.2 
% signal filtré 

f = linspace(-Fe/2,Fe/2,length(hiph));

figure (7);
semilogy(f,fftshift((hiph.^2)/ordre));

%%
%5.3
%Filtrage de x par le passe-bas et par le passe haut
signal_fPB = filter(hipb,1,x);
signal_fPH = filter(hiph,1,x);

%Représentation des signaux filtrés
figure (1);
subplot(2,1,1);plot(Temps,signal_fPH)
xlabel("Temps(s)");
ylabel("signal_fPH(t)");
title("Signal x filtré par le passe-haut");
grid on;
subplot(2,1,2);plot(Temps,signal_fPB)
xlabel("Temps(s)");
ylabel("signal_fPB(t)");
title("Signal x filtré par le passe-bas");
grid on;
%%
%5.4.1
%Représentation de la réponse impulsionnelle du filtre passe-bas avec sa TF
figure (2);
subplot(2,1,1);plot(Ech61,hipb)
xlabel("Temps(s)");
ylabel("hipb(t)");
title("Réponse impulsionnelle du filtre passe-bas");
grid on;
subplot(2,1,2);semilogy(linspace(-Fe/2,Fe/2,length(HIPB)),fftshift(abs(HIPB)));
xlabel("Fréquence(Hz)");
ylabel("HIPB(f)");
title("Réponse fréquentielle du filtre passe-bas");
grid on;

%Représentation de la réponse impulsionnelle du filtre passe-haut avec sa TF
figure (3);
subplot(2,1,1);plot(Ech61,hiph)
xlabel("Temps(s)");
ylabel("hiph(t)");
title("Réponse impulsionnelle du filtre passe-haut");
grid on;
subplot(2,1,2);semilogy(linspace(-Fe/2,Fe/2,length(HIPH)),fftshift(abs(HIPH)));
xlabel("Fréquence(Hz)");
ylabel("HIPH(f)");
title("Réponse fréquentielle du filtre passe-haut");
grid on;

%%
%5.4.2
%Calcul de la DSP de x
DSPx = pwelch(x,[],[],[],Fe,"twosided");

%Représentation de la DSP de x avec la TF du filtre passe-haut
figure (4);
semilogy(linspace(-Fe/2,Fe/2,length(DSPx)),fftshift(abs(DSPx)));
hold on;
semilogy(linspace(-Fe/2,Fe/2,length(HIPH)),fftshift(abs( (1/ordre) * (HIPH.^2) )))
hold off;
title("Représentation du filtre passe-haut (en fréquence) avec la DSP de x");
xlabel("Fréquence(Hz)");
legend({'DSP(x)','HIPH(f)'})
ylabel("Amplitude");

%Représentation de la DSP de x avec la TF du filtre passe-bas
figure (5);
semilogy(linspace(-Fe/2,Fe/2,length(DSPx)),fftshift(abs(DSPx)));
hold on;
semilogy(linspace(-Fe/2,Fe/2,length(HIPB)),fftshift(abs( (1/ordre) * (HIPB.^2) )))
hold off;
title("Représentation du filtre passe-bas (en fréquence) avec la DSP de x");
xlabel("Fréquence(Hz)");
legend({'DSP(x)','HIPB(f)'})
ylabel("Amplitude");

%%
%5.4.3
%Calcul de la DSP du signal en sortie du filtre passe-haut
DSP_fPH = fft(signal_fPH,2048);

%Représentation du signal filtré par le passe-haut avec sa DSP
figure (6);
subplot(2,1,1);plot(Temps,signal_fPH);
title("Représentation du signal x filtré par hiph");
xlabel("Temps(s)");
ylabel("signal_fPH(t)");
subplot(2,1,2);semilogy(linspace(-Fe/2,Fe/2,length(DSP_fPH)),fftshift(abs(DSP_fPH)))
title("Représentation de la DSP du signal x filtré par hiph");
xlabel("Fréquence(Hz)");
ylabel("Amplitude");

%%
%5.5.1
%Calcul de l'énergie du signal filtré par le passe-haut
signal_matrice_fPH = reshape(signal_fPH,Ns,length(signal_fPH)/Ns);
Energie_PH = sum(signal_matrice_fPH.^2,1);
%Calcul de l'énergie du signal filtré par le passe-bas
signal_matrice_fPB = reshape(signal_fPB,Ns,length(signal_fPB)/Ns);
Energie_PB = sum(signal_matrice_fPB.^2,1);

%Calcul des seuils associés
K_PH = (max(Energie_PH)+min(Energie_PH))/2;
K_PB = (max(Energie_PB)+min(Energie_PB))/2;

% 2 vecteurs colonnes contenant des 0 et des 1: 1 si l'energie est
% superieure au seuil alors le bit vaut 1 sinon 0

%Récupération des bits provenant des signaux filtrés par rapport aux seuils
bits_estimes_PH = zeros(1,length(Energie_PH));
bits_estimes_PB = zeros(1,length(Energie_PB));
bits_estimes_PH(Energie_PH > K_PH) = 1;
bits_estimes_PB(Energie_PB > K_PB) = 1;


%%
%5.5.2
%Calcul du taux d'erreur binaire des deux signaux récupérés
TEB_PH = sum(bits_estimes_PH~=bits)/length(bits);
TEB_PB = sum(bits_estimes_PB~=bits)/length(bits);

%%
%5.6.1.a
%La valeur de TEB passe de 0 à 0,3 quand on augmente l'ordre, cela dû au
%retard du signal démodulé apres filtrage (ordre augmente => retard
%augmente)

%5.6.1.b
%Compensation du retazrd (pour récupérer uniquement les valeurs qui nous
%intéresse)
signal_fPB_modif = filter(hipb,1,[x zeros(1,retard)]);
signal_fPH_modif = filter(hiph,1,[x zeros(1,retard)]);
yfiltrefinal_PH = signal_fPH_modif(retard+1:end);
yfiltrefinal_PB = signal_fPB_modif(retard+1:end);

%Calcul des énergies associés
signal_matrice_fPH_modif = reshape(yfiltrefinal_PH,Ns,length(yfiltrefinal_PH)/Ns);
Energie_PH_final = sum(signal_matrice_fPH_modif.^2,1);
signal_matrice_fPB_modif = reshape(yfiltrefinal_PB,Ns,length(yfiltrefinal_PB)/Ns);
Energie_PB_final = sum(signal_matrice_fPB_modif.^2,1);

%Calcul des seuils
K_PH_final = (max(Energie_PH_final)+min(Energie_PH_final))/2;
K_PB_final = (max(Energie_PB_final)+min(Energie_PB_final))/2;

%Récupération des bits provenant des signaux filtrés par rapport aux seuils
bits_estimes_PH_final = zeros(1,length(Energie_PH_final));
bits_estimes_PB_final=zeros(1,length(Energie_PB_final));
bits_estimes_PH_final(Energie_PH_final > K_PH) = 1;
bits_estimes_PB_final(Energie_PB_final > K_PB) = 1;

%Calcul des taux d'erreurs binaires
TEB_PH_final = sum(bits_estimes_PH_final~=bits)/length(bits);
TEB_PB_final =sum(bits_estimes_PB_final~=bits)/length(bits);

%% 
% 5.6.2
%Fréquences de la recommandation de la V21
F0 = 1180;
F1 = 980;

%Calucl du signal modulé
x1 = (1 - NRZ) .* cos(2*pi*F0*Temps + Phi0 ) + NRZ .* cos(2*pi*F1*Temps + Phi1 );

%Compensation du retard
signal_fPB_modif2 = filter(hipb,1,[x zeros(1,retard)]);
signal_fPH_modif2 = filter(hiph,1,[x zeros(1,retard)]);
yfiltrefinal_PH2 = signal_fPH_modif(retard+1:end);
yfiltrefinal_PB2 = signal_fPB_modif(retard+1:end);

%Calcul des energies
signal_matrice_fPH_modif2 = reshape(yfiltrefinal_PH,Ns,length(yfiltrefinal_PH )/Ns);
Energie_PH_final2 = sum(signal_matrice_fPH_modif.^2,1);
signal_matrice_fPB_modif2 = reshape(yfiltrefinal_PB,Ns,length(yfiltrefinal_PB)/Ns);
Energie_PB_final2 = sum(signal_matrice_fPB_modif.^2,1);

%Calcul de seuils
K_PH_final2 = (max(Energie_PH_final)+min(Energie_PH_final))/2;
K_PB_final2 = (max(Energie_PB_final)+min(Energie_PB_final))/2;

%Récupération des bits provenant des signaux filtrés par rapport aux seuils
bits_estimes_PH_final2 = zeros(1,length(Energie_PH_final));
bits_estimes_PB_final2=zeros(1,length(Energie_PB_final));
bits_estimes_PH_final2(Energie_PH_final > K_PH) = 1;
bits_estimes_PB_final2(Energie_PB_final > K_PB) = 1;

%Calcul des taux d'erreurs binaires
TEB_PH_final2 = sum(bits_estimes_PH_final~=bits)/length(bits);
TEB_PB_final2 = sum(bits_estimes_PB_final~=bits)/length(bits);