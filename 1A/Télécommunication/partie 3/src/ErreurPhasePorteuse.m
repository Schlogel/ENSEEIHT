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

%% Chaine sans erreur de phase et sans bruit

% Mapping
Symboles = zeros(1,length(bits));
Symboles(bits==1) = V;
Symboles(bits==0) = -V;

% Suréchantillonage
Tsbin =Tb ;
Nsbin = floor(Tsbin / Te);
surech = zeros(1,Nsbin);
surech(1) = 1;
Xk = kron(Symboles,surech);

% Mise en forme: 
h = ones(1,Nsbin);
Signal_Filtre = filter(h,1,Xk);

% Filtre de récéption
hr = flip(h);
Signal_zSB = filter(hr,1,Signal_Filtre);

% Echantillonage à t0=Ts 
z_ech = Signal_zSB(Nsbin : Nsbin : end); 
figure(1);
plot(real(z_ech), imag(z_ech),'ored','LineWidth',3);
xlim([-8 8]);
ylim([-8 8]);
title("Constellation en sortie de l'echantilloneur pour une chaine sans erreur et sans bruit");

% Recupération partie réel
xe_reel = real(z_ech);

% Prise de décision
Seuil = 0;
SymboleDecide = zeros(1,length(xe_reel));
SymboleDecide(xe_reel>Seuil) = V;
SymboleDecide(xe_reel<-Seuil) = -V;
bits_estimes=zeros(1,Nbits); 
bits_estimes(xe_reel>0) = 1;

% Calcul du teb
TEB = sum(bits ~=bits_estimes)/Nbits ;

%% Chaine avec erreur de phase et sans bruit

% Mapping
Symboles = zeros(1,length(bits));
Symboles(bits==1) = V;
Symboles(bits==0) = -V;

% Suréchantillonage
Tsbin =Tb ;
Nsbin = floor(Tsbin / Te);
surech = zeros(1,Nsbin);
surech(1) = 1;
Xk = kron(Symboles,surech);

% Mise en forme: 
h = ones(1,Nsbin);
Signal_Filtre = filter(h,1,Xk);

% Erreur de phase
Signal_Filtre40 = Signal_Filtre * exp(1j*40*pi/180);
Signal_Filtre100 = Signal_Filtre * exp(1j*100*pi/180);
Signal_Filtre180 = Signal_Filtre * exp(1j*180*pi/180);

% Filtre de récéption
hr = flip(h);
Signal_zSB40 = filter(hr,1,Signal_Filtre40);
Signal_zSB100 = filter(hr,1,Signal_Filtre100);
Signal_zSB180 = filter(hr,1,Signal_Filtre180);

% Echantillonage à t0=Ts 
z_ech40 = Signal_zSB40(Nsbin : Nsbin : end);
z_ech100 = Signal_zSB100(Nsbin : Nsbin : end); 
z_ech180 = Signal_zSB180(Nsbin : Nsbin : end); 

figure(2);
plot(real(z_ech40), imag(z_ech40),'ored','LineWidth',3);
xlim([-8 8]);
ylim([-8 8]);
title("Constellation avec Phi = 40°, avec erreur et sans bruit");
figure(3);
plot(real(z_ech100), imag(z_ech100),'ored','LineWidth',3);
xlim([-8 8]);
ylim([-8 8]);
title("Constellation avec Phi = 100°, avec erreur et sans bruit");
figure(4);
plot(real(z_ech180), imag(z_ech180),'ored','LineWidth',3);
xlim([-8 8]);
ylim([-8 8]);
title("Constellation avec Phi = 180°, avec erreur et sans bruit");

% Recupération partie réel
xe_reel40 = real(z_ech40);
xe_reel100 = real(z_ech100);
xe_reel180 = real(z_ech180);

% Prise de décision
Seuil = 0;

SymboleDecide40 = zeros(1,length(xe_reel40));
SymboleDecide40(xe_reel40>Seuil) = V;
SymboleDecide40(xe_reel40<-Seuil) = -V;
bits_estimes40=zeros(1,Nbits); 
bits_estimes40(xe_reel40>0) = 1;

SymboleDecide100 = zeros(1,length(xe_reel100));
SymboleDecide100(xe_reel100>Seuil) = V;
SymboleDecide100(xe_reel100<-Seuil) = -V;
bits_estimes100=zeros(1,Nbits); 
bits_estimes100(xe_reel100>0) = 1;

SymboleDecide180 = zeros(1,length(xe_reel180));
SymboleDecide180(xe_reel180>Seuil) = V;
SymboleDecide180(xe_reel180<-Seuil) = -V;
bits_estimes180=zeros(1,Nbits); 
bits_estimes180(xe_reel180>0) = 1;


% Calcul du teb
TEB40 = sum(bits ~=bits_estimes40)/Nbits;
TEB100 = sum(bits ~=bits_estimes100)/Nbits;
TEB180 = sum(bits ~=bits_estimes180)/Nbits;

%% Chaine avec erreur de phase et avec bruit

% Mapping
Symboles = zeros(1,length(bits));
Symboles(bits==1) = V;
Symboles(bits==0) = -V;

% Suréchantillonage
Tsbin =Tb ;
Nsbin = floor(Tsbin / Te);
surech = zeros(1,Nsbin);
surech(1) = 1;
Xk = kron(Symboles,surech);

% Mise en forme: 
h = ones(1,Nsbin);
Signal_Filtre = filter(h,1,Xk);

EbN0dB = 0:6;
N = length(EbN0dB);

% Puissance du signal
Px = mean(abs(Signal_Filtre).^2);

TEB_Sim0 = zeros(1,N);
TEB_Sim40 = zeros(1,N);
TEB_Sim100 = zeros(1,N);

for index = 1:N

    % Canal AWGN
    Px = mean(abs(Signal_Filtre).^2);
    Sigma2N = (Px*Nsbin)/(2*log2(2)*10^(EbN0dB(index)/10)) ;
    BruitR = sqrt(Sigma2N) * randn(1, length(Xk));
    BruitI = sqrt(Sigma2N) * randn(1, length(Xk));
    Signal_Bruitee = Signal_Filtre + BruitR + 1j*BruitI;
    
    % Erreur de phase
    Signal_Bruitee0 = Signal_Bruitee;
    Signal_Bruitee40 = Signal_Bruitee * exp(1j*40*pi/180);
    Signal_Bruitee100 = Signal_Bruitee * exp(1j*100*pi/180);
    
    % Filtre de récéption
    hr = h;
    Signal_zSB0 = filter(hr,1,Signal_Bruitee0);
    Signal_zSB40 = filter(hr,1,Signal_Bruitee40);
    Signal_zSB100 = filter(hr,1,Signal_Bruitee100);
    
    % Echantillonage à t0=Ts 
    z_ech0 = Signal_zSB0(Nsbin : Nsbin : end);
    z_ech40 = Signal_zSB40(Nsbin : Nsbin : end);
    z_ech100 = Signal_zSB100(Nsbin : Nsbin : end);
    
    % Recupération partie réel
    xe_reel0 = real(z_ech0);
    xe_reel40 = real(z_ech40);
    xe_reel100 = real(z_ech100);
    
    % Prise de décision
    Seuil = 0;
    
    SymboleDecide0 = zeros(1,length(xe_reel0));
    SymboleDecide0(xe_reel0>Seuil) = V;
    SymboleDecide0(xe_reel0<-Seuil) = -V;
    bits_estimes0=zeros(1,Nbits); 
    bits_estimes0(xe_reel0>0) = 1;
    
    SymboleDecide40 = zeros(1,length(xe_reel40));
    SymboleDecide40(xe_reel40>Seuil) = V;
    SymboleDecide40(xe_reel40<-Seuil) = -V;
    bits_estimes40=zeros(1,Nbits); 
    bits_estimes40(xe_reel40>0) = 1;
    
    SymboleDecide100 = zeros(1,length(xe_reel100));
    SymboleDecide100(xe_reel100>Seuil) = V;
    SymboleDecide100(xe_reel100<-Seuil) = -V;
    bits_estimes100=zeros(1,Nbits); 
    bits_estimes100(xe_reel100>0) = 1;
    
    % Calcul du teb
    TEB_Sim0(1, index) = sum(bits ~=bits_estimes0)/Nbits;
    TEB_Sim40(1, index) = sum(bits ~=bits_estimes40)/Nbits;
    TEB_Sim100(1, index) = sum(bits ~=bits_estimes100)/Nbits;

end

TEB_The0 = qfunc(sqrt(2*10.^(EbN0dB/10))*cos(0));
TEB_The40 = qfunc(sqrt(2*10.^(EbN0dB/10))*cos(40*pi/180));
TEB_The100 = qfunc(sqrt(2*10.^(EbN0dB/10))*cos(100*pi/180));

figure(5);
semilogy(EbN0dB, TEB_Sim40,'*b-');
hold on;
semilogy(EbN0dB, TEB_The40,'sr-');
hold off;
grid on;
title("TEB estimé et théorique  avec phi = 40°");
legend({'TEB_{estime}','TEB_{Theorique}'});
xlabel("Eb/N0 (dB)");
ylabel("TEB");

figure(6);
semilogy(EbN0dB, TEB_Sim40,'*b-');
hold on;
semilogy(EbN0dB, TEB_Sim0,'sr-');
hold off;
grid on;
title("Comparaison du TEB avec phi = 0° et du TEB avec phi = 40°");
legend({'TEB_{estime 40°}','TEB_{estime 0°}'});
xlabel("Eb/N0 (dB)");
ylabel("TEB");

figure(7);
semilogy(EbN0dB, TEB_Sim40,'*b-');
hold on;
semilogy(EbN0dB, TEB_Sim100,'sr-');
hold off;
grid on;
title("Comparaison du TEB avec phi = 40° et du TEB avec phi = 100°");
legend({'TEB_{estime 40°}','TEB_{estime 100°}'});
xlabel("Eb/N0 (dB)");
ylabel("TEB");


