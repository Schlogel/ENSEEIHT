%Nettoyer l'interface
clc;
clear all;
close all;

%Constantes
Fe = 24000;
Rb = 6000;
Tb = 1/Rb;
Nbits = 10000;
Te = 1/Fe;
V = 1;
alpha = 0.2 ;
L = 8;
bits = randi([0 1],1, Nbits);

%% Chaine avec correction d'erreur de phase et avec bruit

% Mapping
Symboles = zeros(1,length(bits));
Symboles(bits==1) = V;
Symboles(bits==0) = -V;

% Suréchantillonage
Tsbin = Tb ;
Nsbin = floor(Tsbin / Te);
surech = zeros(1,Nsbin);
surech(1) = 1;
Xk = kron(Symboles,surech);

% Filtre de mise en forme: 
h = ones(1,Nsbin);
Signal_Filtre = filter(h,1,Xk);

EbN0dB = 0:6;
N = length(EbN0dB);

% Puissance du signal
Px = mean(abs(Signal_Filtre).^2);

TEB_Sim40_1 = zeros(1,N);
TEB_Sim100_1 = zeros(1,N);

Esti_Phi40 = zeros(1,N);
Esti_Phi100 = zeros(1,N);

for index = 1:N

    % Canal AWGN
    Px = mean(abs(Signal_Filtre).^2);
    Sigma2N = (Px*Nsbin)/(2*log2(2)*10^(EbN0dB(index)/10)) ;
    BruitR = sqrt(Sigma2N) * randn(1, length(Xk));
    BruitI = sqrt(Sigma2N) * randn(1, length(Xk));
    Signal_Bruitee = Signal_Filtre + BruitR + 1j*BruitI;
    
    % Erreur de phase
    Signal_Bruitee40 = Signal_Bruitee * exp(1j*40*pi/180);
    Signal_Bruitee100 = Signal_Bruitee * exp(1j*100*pi/180);
    
    % Filtre de récéption
    hr = flip(h);
    Signal_z = filter(hr,1,Signal_Bruitee40);
    Signal_z100 = filter(hr,1,Signal_Bruitee100);
    
    % Echantillonage à t0=Ts 
    z_ech = Signal_z(Nsbin : Nsbin : end); 
    z_ech100 = Signal_z100(Nsbin : Nsbin : end); 

    % Estimation erreur
    Esti_Phi40 = (1/2)*angle(sum(z_ech.^2));
    Esti_Phi100 = (1/2)*angle(sum(z_ech100.^2));
    
    % Correction erreur
    Signal_z40_c = Signal_z * exp(-1j * Esti_Phi40);
    Signal_z100_c = Signal_z100 * exp(-1j * Esti_Phi100);

    % Echantillonage à t0=Ts du signal corrigé
    z_ech40_c = Signal_z40_c(Nsbin : Nsbin : end); 
    z_ech100_c = Signal_z100_c(Nsbin : Nsbin : end);
    
    % Recupération partie réel
    xe_reel = real(z_ech40_c);
    xe_reel100 = real(z_ech100_c);
    
    % Prise de décision
    Seuil = 0;
    
    SymboleDecide = zeros(1,length(xe_reel));
    SymboleDecide(xe_reel>Seuil) = V;
    SymboleDecide(xe_reel<-Seuil) = -V;
    bits_estimes = zeros(1,Nbits); 
    bits_estimes(xe_reel>0) = 1;
    
    SymboleDecide100 = zeros(1,length(xe_reel100));
    SymboleDecide100(xe_reel100>Seuil) = V;
    SymboleDecide100(xe_reel100<-Seuil) = -V;
    bits_estimes100=zeros(1,Nbits); 
    bits_estimes100(xe_reel100>0) = 1;
    
    % Calcul du teb
    TEB_Sim40_1(1, index) = sum(bits ~=bits_estimes)/Nbits;
    TEB_Sim100_1(1, index) = sum(bits ~=bits_estimes100)/Nbits;

end


%% Chaine sans correction d'erreur de phase et avec bruit

% Mapping
Symboles = zeros(1,length(bits));
Symboles(bits==1) = V;
Symboles(bits==0) = -V;

% Suréchantillonage
Tsbin = Tb ;
Nsbin = floor(Tsbin / Te);
surech = zeros(1,Nsbin);
surech(1) = 1;
Xk = kron(Symboles,surech);

% Filtre de mise en forme: 
h = ones(1,Nsbin);
Signal_Filtre = filter(h,1,Xk);

EbN0dB = 0:6;
N = length(EbN0dB);

% Puissance du signal
Px = mean(abs(Signal_Filtre).^2);

TEB_Sim40_2 = zeros(1,N);
TEB_Sim100_2 = zeros(1,N);

for index = 1:N

    % Canal AWGN
    Px = mean(abs(Signal_Filtre).^2);
    Sigma2N = (Px*Nsbin)/(2*log2(2)*10^(EbN0dB(index)/10)) ;
    BruitR = sqrt(Sigma2N) * randn(1, length(Xk));
    BruitI = sqrt(Sigma2N) * randn(1, length(Xk));
    Signal_Bruitee = Signal_Filtre + BruitR + 1j*BruitI;
    
    % Erreur de phase
    Signal_Bruitee40 = Signal_Bruitee * exp(1j*40*pi/180);
    Signal_Bruitee100 = Signal_Bruitee * exp(1j*100*pi/180);
    
    % Filtre de récéption
    hr = flip(h);
    Signal_z = filter(hr,1,Signal_Bruitee40);
    Signal_z100 = filter(hr,1,Signal_Bruitee100);
    
    % Echantillonage à t0=Ts 
    z_ech = Signal_z(Nsbin : Nsbin : end); 
    z_ech100 = Signal_z100(Nsbin : Nsbin : end); 
    
    % Recupération partie réel
    xe_reel = real(z_ech);
    xe_reel100 = real(z_ech100);
    
    % Prise de décision
    Seuil = 0;
    
    SymboleDecide = zeros(1,length(xe_reel));
    SymboleDecide(xe_reel>Seuil) = V;
    SymboleDecide(xe_reel<-Seuil) = -V;
    bits_estimes = zeros(1,Nbits); 
    bits_estimes(xe_reel>0) = 1;
    
    SymboleDecide100 = zeros(1,length(xe_reel100));
    SymboleDecide100(xe_reel100>Seuil) = V;
    SymboleDecide100(xe_reel100<-Seuil) = -V;
    bits_estimes100=zeros(1,Nbits); 
    bits_estimes100(xe_reel100>0) = 1;
    
    % Calcul du teb
    TEB_Sim40_2(1, index) = sum(bits ~=bits_estimes)/Nbits;
    TEB_Sim100_2(1, index) = sum(bits ~=bits_estimes100)/Nbits;

end

%% Chaine sans erreur de phase et avec bruit

% Mapping
Symboles = zeros(1,length(bits));
Symboles(bits==1) = V;
Symboles(bits==0) = -V;

% Suréchantillonage
Tsbin = Tb ;
Nsbin = floor(Tsbin / Te);
surech = zeros(1,Nsbin);
surech(1) = 1;
Xk = kron(Symboles,surech);

% Filtre de mise en forme: 
h = ones(1,Nsbin);
Signal_Filtre = filter(h,1,Xk);

EbN0dB = 0:6;
N = length(EbN0dB);

% Puissance du signal
Px = mean(abs(Signal_Filtre).^2);

TEB_Sim_3 = zeros(1,N);

for index = 1:N

    % Canal AWGN
    Px = mean(abs(Signal_Filtre).^2);
    Sigma2N = (Px*Nsbin)/(2*log2(2)*10^(EbN0dB(index)/10)) ;
    BruitR = sqrt(Sigma2N) * randn(1, length(Xk));
    BruitI = sqrt(Sigma2N) * randn(1, length(Xk));
    Signal_Bruitee = Signal_Filtre + BruitR + 1j*BruitI;
    
    % Filtre de récéption
    hr = flip(h);
    Signal_z = filter(hr,1,Signal_Bruitee);
    
    % Echantillonage à t0=Ts 
    z_ech = Signal_z(Nsbin : Nsbin : end);
    
    % Recupération partie réel
    xe_reel = real(z_ech);
    
    % Prise de décision
    Seuil = 0;
    
    SymboleDecide = zeros(1,length(xe_reel));
    SymboleDecide(xe_reel>Seuil) = V;
    SymboleDecide(xe_reel<-Seuil) = -V;
    bits_estimes = zeros(1,Nbits); 
    bits_estimes(xe_reel>0) = 1;
    
    % Calcul du teb
    TEB_Sim_3(1, index) = sum(bits ~=bits_estimes)/Nbits;

end

figure(1);
semilogy(EbN0dB, TEB_Sim40_1,'*b-');
hold on;
semilogy(EbN0dB, TEB_Sim40_2,'sr-');
semilogy(EbN0dB, TEB_Sim_3);
hold off;
grid on;
title("Comparaison du TEB des différentes chaines avec phi = 40°");
legend({'TEB avec correction de phase','TEB sans correction de phase', 'TEB sans erreur de phase'});
xlabel("Eb/N0 (dB)");
ylabel("TEB");

figure(2);
semilogy(EbN0dB, TEB_Sim100_1,'*b-');
hold on;
semilogy(EbN0dB, TEB_Sim100_2,'sr-');
semilogy(EbN0dB, TEB_Sim_3);
hold off;
grid on;
title("Comparaison du TEB des différentes chaines avec phi = 100°");
legend({'TEB avec correction de phase','TEB sans correction de phase', 'TEB sans erreur de phase'});
xlabel("Eb/N0 (dB)");
ylabel("TEB");




