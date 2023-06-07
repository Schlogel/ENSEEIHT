clc;
clear all;
close all;


F0 = 1180;
F1 = 980;

fc = 6000;
Fe = 48000;

Phi0 = rand*2*pi;
Phi1 = rand*2*pi;
theta0=rand*2*pi ;
theta1=rand*2*pi ;


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



%% 6 Demodulation FSK
% 6.1 Demodulation sans dephasage: 
%signal modulé:
x_mod = (1 - NRZ) .* cos(2*pi*F0*Temps) + NRZ .* cos(2*pi*F1*Temps);

% signal module bruite:
SNR = 50;
Px1 = mean(abs(x_mod).^2);
Pb1 = Px1 / (10^(SNR/10));
bruit = sqrt(Pb1)*randn(1,length(x_mod));

x_mod_bruit = x_mod+ bruit;



%Démodulation FSK 
Integrersignal0= cos(2*pi*F0*Temps).*x_mod_bruit; % signal à integrer associé à F0
Integrersignal1= cos(2*pi*F1*Temps).*x_mod_bruit; %  signal à integrer associé à F1 

Y0_Sans_Phase=reshape(Integrersignal0,Ns,length(Integrersignal0)/Ns);
Y1_Sans_Phase=reshape(Integrersignal1,Ns,length(Integrersignal1)/Ns);

Integrale_Sans_Phase0=sum(Y0_Sans_Phase);
Integrale_Sans_Phase1=sum(Y1_Sans_Phase);% calcul d'integrale avec discretisation 

signal_Mod_Sans_Phase= Integrale_Sans_Phase1 - Integrale_Sans_Phase0; %signal démodulé suivant le modele FSK




% Detection de la fréquence qui domine: 
bits_estimes_FSK1=zeros(1,Nbits); 
bits_estimes_FSK1(signal_Mod_Sans_Phase > 0 ) = 1;
% TEB
TEB1 = sum(bits ~=bits_estimes_FSK1)/length(bits);

%%
%6.2 Demodulation avec dephasages 
%Modulation de frequence: 
x_module_dephasage = (1 - NRZ) .* cos(2*pi*F0*Temps+Phi0) + NRZ .* cos(2*pi*F1*Temps+Phi1);

% signal module bruite: 
SNR =50;
Px2 = mean(abs(x_module_dephasage).^2);
Pb2 = Px2 / (10^(SNR/10));

bruit = sqrt(Pb2)*randn(1,length(x_module_dephasage));
x_module_dephasage_br = x_module_dephasage+ bruit;
% signal demodulé bruité:


Integrersignalcos0= cos(2*pi*F0*Temps+theta0).*x_module_dephasage_br; % signal à integrer associé à F0 (cos)
Integrersignalsin0= sin(2*pi*F0*Temps+theta0).*x_module_dephasage_br; % signal à integrer associé à F0 (sin)

Integrersignalcos1= cos(2*pi*F1*Temps+theta1).*x_module_dephasage_br; %  signal à integrer associé à F1 (cos)
Integrersignalsin1=sin(2*pi*F1*Temps+theta1).*x_module_dephasage_br; %  signal à integrer associé à F1 (sin)

Y0_Phase_cos=reshape(Integrersignalcos0,Ns,length(Integrersignal0)/Ns);
Y0_Phase_sin=reshape(Integrersignalsin0,Ns,length(Integrersignal0)/Ns); %signal to be integered
Y1_Phase_cos=reshape(Integrersignalcos1,Ns,length(Integrersignal1)/Ns);
Y1_Phase_sin=reshape(Integrersignalsin1,Ns,length(Integrersignal1)/Ns);

Integrale0_Phasecos=sum(Y0_Phase_cos,1).^2;
Integrale0_Phasesin=sum(Y0_Phase_sin,1).^2;
Integrale1_Phasecos=sum(Y1_Phase_cos,1).^2;
Integrale1_Phasesin=sum(Y1_Phase_sin,1).^2;% calcul d'integrale avec discretisation 

signal_Mod_Phase= (Integrale1_Phasecos+Integrale1_Phasesin)-(Integrale0_Phasecos+Integrale0_Phasesin); %signal démodulé suivant le modele FSK

% Bits decodes: 
bits_estimes_FSK2=zeros(1,Nbits); 
bits_estimes_FSK2(signal_Mod_Phase > 0 ) = 1;

% TEB: 
TEB2= sum(bits ~= bits_estimes_FSK2)/length(bits);
 
%% 6.2.2 reconstitution d'images: 
