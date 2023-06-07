%--------------------------------------------------------------------------
% ENSEEIHT - 1SN - Télécommunications
% partie 2: Etudes de chaines de transmission sur frequence porteuse.
clear;
close all;
clc;


%% Modulation 8-PSK

%Les données: 

%fréquence porteuse
Fp=2000;
%Fréquence d'echantillonnage
Fe=6000;
%Roll off
alpha=0.35;
%Temps d'echantillonnage
Te=1/Fe;
%Rythm symbole
Rs = 2000;
%Temps symbole
Ts=1/Rs;
%nombre de bits: 
nb_bits=10000;
%Ns
Ns=floor(Ts/Te);
%L
L=8;
%retard
retard=L*Ns/2;
M = 8;

%% Implantation de la chaine sans bruit

% Q1: MOdulation 8-PSK

% Génération de l’information binaire 
bits = randi([0, M- 1], 1, nb_bits);

% Utilisation de la fonction pskmod
dk = pskmod(bits, M, pi / M);
ak = real(dk);
bk = imag(dk);

% Constellations en sortie du mapping 
figure(1);
plot(ak,bk,'ored','linewidth',3);
title('Figure 3 : Constellations en sortie du mapping de la chaine 8-PSK');
xlim([-2 2]);
ylim([-2 2]);

%La partie reel I et imaginaire Q
diracI = kron(ak, [1 zeros(1, Ns - 1)]);
diracQ = kron(bk, [1 zeros(1, Ns - 1)]);

% réponse impulsionnelle du filtre de mise en forme
h = rcosdesign(alpha, L, Ns);

%Reel et imaginaire apres filtrage
REEL = filter(h, 1, [diracI zeros(1, retard)]);
IMAG = filter(h, 1, [diracQ zeros(1, retard)]); 

%Suppression de retard
REEL = REEL(retard + 1 : end);
IMAG = IMAG(retard + 1 : end);

%Signal transmis
x =  REEL + 1i * IMAG;

figure;
subplot(211);
plot(REEL);
title('composante en phase');
xlabel('temps en s');
ylabel('I');
subplot(212);
plot(IMAG);
title('composante en quadrature');
xlabel('temps en s');
ylabel('Q');

% Affichage de la DSP du signal émis:
figure;
DSP=(1/length(x))*abs(fft(x,2^nextpow2(length(x)))).^2;
plot(linspace(0,100,length(DSP)),fftshift(DSP));
title('DSP du signal émis pour 8PSK');
ylabel('DSP');
xlabel('fréquence en Hz');

%% Sortie de filtre reception
hr = h;

% signal  à sortie de filtre de reception
x_R_FILTRE = filter(hr, 1, [x zeros(1,retard)]);
x_R_FILTRE = x_R_FILTRE(retard + 1 : end);
x_FILTRE_REEL=real(x_R_FILTRE );

% Afficher le signal 
figure ;
plot(x_FILTRE_REEL);
title('signal en sortie de filtre de reception');
xlabel('Temps en s');
ylabel('x_FILTRE_REEL');

% Echantillonnage du signal
z_8PSK = x_R_FILTRE(1 : Ns : end);

% Detecteur à seuil
bits_decides_8PSK = pskdemod(z_8PSK, M, pi / M);

% Calcul du TEB
TEB_8PSK = length(find(bits_decides_8PSK ~= bits)) / length(bits)

%% chaine avec bruit

TES = zeros(1,7);
TEB_8PSK = zeros(1,7);

for i = 0 : 6

    % L'ajout du bruit blanc gaussien
    SIGMA = mean(abs(x) .^ 2);
    Puissance = SIGMA * Ns  / (2 * log2(M) * 10 .^ (i / 10));
    bruit_reel = randn(1, length(x));
    bruit_imag = randn(1, length(x)); 
    Bruit = (sqrt(Puissance) * bruit_reel) + 1i * (sqrt(Puissance) * bruit_imag);
    Signal_Bruite = x + Bruit;

    % Filtrage de réception
    x_R_FILTRE= filter(hr, 1, [Signal_Bruite zeros(1,retard)]);
    x_R_FILTRE = x_R_FILTRE(retard + 1 : end);

    % Signal échantilloné
    z_8PSK = x_R_FILTRE(1 : Ns : end);
    
    %tracé des constellations pour diff valeurs EBN0db
    figure;
    plot(real(z_8PSK),imag(z_8PSK),'ored','linewidth',3);
    xlim([-2 2]);
    ylim([-2 2]);
    title('Constellations en sortie de l échantillonneur');


    % Detecteur à seuil
    bits_decides_8PSK = pskdemod(z_8PSK, M, pi / M);

    % Calcul du TES
    TES(i + 1) = length(find(bits_decides_8PSK ~= bits)) / length(bits);

    % Calcul du TEB
    TEB_8PSK(i + 1) = TES(i + 1) / log2(M);
end
%% Introduction du canal avec bruit

EbN0dB=[0:6];
% Comparaison entre TEB théorique et estimé
figure;
semilogy(EbN0dB, TEB_8PSK, '*b-');
hold on
semilogy(EbN0dB, (2 / 3) * qfunc(sqrt(6*10.^([0 : 6] / 10)) * sin(pi / M)),'sr-');
grid
title('Comparaison entre le TEB théorique et estimé pour 8PSK');
legend('TEB estimé','TEB théorique');
ylabel('TEB');
xlabel('Eb/N0(dB)');

