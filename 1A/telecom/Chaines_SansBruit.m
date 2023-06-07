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
bits = randi([0 1],1, Nbits);

%% Chaine 1

% Mapping 1
Symboles1 = zeros(1,length(bits));
Symboles1(bits==1) = V;
Symboles1(bits==0) = -V;

% Suréchantillonage
Tsbin =Tb ;
Nsbin = floor(Tsbin / Te);
surech1 = zeros(1,Nsbin);
surech1(1) = 1;
Xk1 = kron(Symboles1,surech1);

% Mise en forme: 
h1 = ones(1,Nsbin);
Signal_Filtre1 = filter(h1,1,Xk1);

% Filtre de récéption
hr1 = h1;
Signal_z1SB = filter(hr1,1,Signal_Filtre1);

%% Chaine 2

% Mapping 2
Symboles2 = zeros(1,length(bits));
Symboles2(bits==1) = V;
Symboles2(bits==0) = -V;

% Suréchantillonage
Tsbin =Tb ;
Nsbin = floor(Tsbin / Te);
surech2 = zeros(1,Nsbin);
surech2(1) = 1;
Xk2 = kron(Symboles2,surech2);

%Mise en forme: 
h2 = ones(1,Nsbin);
Signal_Filtre2 = filter(h2,1,Xk2);

% Filtre de récéption
hr2 = ones(1,Nsbin/2);
Signal_z2SB = filter(hr2,1,Signal_Filtre2);

%% Chaine 3

% Mapping 3
bits4aires = reshape(bits, 2,length(bits)/2);
Vecteur = bi2de(bits4aires.');

Symboles3(Vecteur==0) = -3*V;
Symboles3(Vecteur==1) = -V;
Symboles3(Vecteur==2) = V;
Symboles3(Vecteur==3) = 3*V;

% Suréchantillonage
Ts4air =2*Tb ;
Ns4air = floor(Ts4air / Te);
surech3 = zeros(1,Ns4air);
surech3(1) = 1;
Xk3 = kron(Symboles3,surech3);

%Mise en forme: 
h3 = ones(1,Ns4air);
Signal_Filtre3 = filter(h3,1,Xk3);

% Filtre de récéption
hr3 = h3;
Signal_z3SB = filter(hr3,1,Signal_Filtre3);


%% Teb sans bruits:
%% pour la chaine 1:

% echantillonage à t0=Ts 
z_ech1 = Signal_z1SB(Nsbin : Nsbin : end ); 

%prise de décision
Seuil = 0;
SymboleDecide1 = zeros(1,length(z_ech1));
SymboleDecide1(z_ech1>Seuil) = V;
SymboleDecide1(z_ech1<-Seuil) = -V;
bits_estimes1=zeros(1,Nbits); 
bits_estimes1(z_ech1>0) = 1;

%calcul du teb
TEB1 = sum(bits ~=bits_estimes1)/Nbits ;

%% pour la chaine 2:

%echantillonage à t0=Ts/2
z_ech2 = Signal_z2SB(Nsbin/2: Nsbin : end ); 

%prise de décision
Seuil = 0;
SymboleDecide2 = zeros(1,length(z_ech2));
SymboleDecide2(z_ech2>Seuil) = V;
SymboleDecide2(z_ech2<-Seuil) = -V;
bits_estimes2=zeros(1,Nbits); 
bits_estimes2(z_ech2>0) = 1;

%calcul du TEB
TEB2 = sum(bits ~=bits_estimes2)/Nbits ;

%% pour la chaine 3:

% echantillonage à t0=Ts4air
z_ech3 = Signal_z3SB(Ns4air: Ns4air : end); 

%Decision
SeuilBas = -2*Ns4air;
SeuilHaut = 2*Ns4air;
SeuilMilieu = 0;

SymboleDecide3 = zeros(1,length(z_ech3));
SymboleDecide3(z_ech3>SeuilHaut) = 3*V;
SymboleDecide3((z_ech3>SeuilMilieu) & (z_ech3<=SeuilHaut)) = V;
SymboleDecide3((z_ech3<=SeuilMilieu) & (z_ech3>=SeuilBas)) = -V;
SymboleDecide3(z_ech3<=SeuilBas) = -3*V;

% TEB3
compteur=1;
bits_estimes3=zeros(1,Nbits);
taille = length(SymboleDecide3);
for  j=1:taille
    valeur = SymboleDecide3(j);
    if valeur==-3*V
        bits_estimes3(1,compteur)=0;
        bits_estimes3(1,compteur+1)=0;
    elseif valeur==-V
        bits_estimes3(1,compteur)=1;
        bits_estimes3(1,compteur+1)=0;
    elseif valeur==V
        bits_estimes3(1,compteur)=0;
        bits_estimes3(1,compteur+1)=1;
    elseif valeur==3*V
        bits_estimes3(1,compteur)=1;
        bits_estimes3(1,compteur+1)=1;
    end
    compteur = compteur+2;
end
TEB_estime3 = sum(bits ~=bits_estimes3)/Nbits ;

%% Diagramme oeuil sans bruit:
% Diagramme de l'oeuil chaine 1 sans bruit
diagramme_oeuil_1SB = reshape(Signal_z1SB,Nsbin,floor(length(Signal_z1SB)/Nsbin)) ; 
figure(1);
plot(diagramme_oeuil_1SB);
xlabel("Temps(s)");
ylabel("Amplitude");
title("Diagramme de l'oeuil de la chaine 1 sans bruit");
grid on;

% Diagramme de l'oeuil chaine 2 sans bruit
diagramme_oeuil_2SB = reshape(Signal_z2SB,Nsbin,floor(length(Signal_z2SB)/Nsbin)) ; 
figure(2);
plot(diagramme_oeuil_2SB);
xlabel("Temps(s)");
ylabel("Amplitude");
title("Diagramme de l'oeuil de la chaine 2 sans bruit");
grid on;

% Diagramme de l'oeuil chaine 3 sans bruit
diagramme_oeuil_3SB = reshape(Signal_z3SB,Ns4air,floor(length(Signal_z3SB)/Ns4air)) ; 
figure(3);
plot(diagramme_oeuil_3SB);
xlabel("Temps(s)");
ylabel("Amplitude");
title("Diagramme de l'oeuil de la chaine 3 sans bruit");
grid on;

