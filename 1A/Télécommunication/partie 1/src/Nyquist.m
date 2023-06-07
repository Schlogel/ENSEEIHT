

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
Te = 1 / Fe;
bits = randi([0 1],1, Nbits);

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
hr = h1;
g= conv(h1,hr);
z=filter(g,1,Xk1);

%% III.1 Etude sans canal de propagation
% g la convolution de h1 et hr
figure (1);
plot(g);
xlabel("Temps(s)");
ylabel("Amplitude");
title("Signal g");
grid on;

%  z la convolution de xk1 et g 
temps = [0:Te:(length(z)-1)*Te];
figure(2);
plot(temps,z);
xlabel("Temps(s)");
ylabel("Amplitude");
title("Signal passé par le demodulateur bdb");
grid on;


% explication: g verifie le critére de nyquist pour le choix de t0=Ts



%diagramme de l'oeuil 
diagramme_oeuil = reshape(z,Nsbin,floor(length(z)/Nsbin)) ; 
figure(3);
plot(diagramme_oeuil);
xlabel("Temps(s)");
ylabel("Amplitude");
title("Diagramme de l'oeuil");
grid on;

% explication du choix de l'instant d'echantillonage à partir du diagramme
% de l'oeuil

% echantillonage à t0=Ts 
figure(4);
z_ech = z(Nsbin : Nsbin : end ) ; 
plot(z_ech);
xlabel("Temps(s)");
ylabel("Amplitude");
title("z échantilloné");
grid on;

%% Decision
Seuil = 0;
SymboleDecide = zeros(1,length(z_ech));
SymboleDecide(z_ech>Seuil) = V;
SymboleDecide(z_ech<-Seuil) = -V;

%% echantilloner à n0+mNs avec n0=3
n0=3 ; 
z_ech2 = z(n0 : Nsbin : end ) ; 

%tracé de z_ech2
figure(5);
plot(z_ech2);
xlabel("Temps(s)");
ylabel("Amplitude");
title("z échantilloné à n0+mNs");
grid on;

%% Estimation du TEB du signal échantilloné 
% TEB1
bits_estimes1=zeros(1,Nbits); 
bits_estimes1(z_ech>0) = 1;
TEB1 = sum(bits ~=bits_estimes1)/Nbits ;

% TEB2
bits_estimes2=zeros(1,Nbits); 
bits_estimes2(z_ech2>0) = 1;
TEB2 = sum(bits ~=bits_estimes2)/Nbits ;

%% III.2 Etude avec canal de propagation sans bruit

%% Avec BW = 8000 Hz
ordre = 101; 
BW = 8000;
retard= floor((ordre-1)/2);
Temps = [-(ordre-1)*Te/2:Te:(ordre-1)*Te/2];
hc = BW * sinc(BW*Temps);

%tracé la réponse impulsionelle golbale de la chaine de transmission
hglobal = conv(g,hc); 
temps = [0:Te:(length(hglobal)-1)*Te];
figure(6);
plot(temps, hglobal);
xlabel("Temps(s)");
ylabel("Amplitude");
title("Réponse impulsionelle globale de la chaine de transmission BW=8000");
grid on;

% diagramme de l'oeuil de filtres
% du coup quand on choisit BW=8000, on a une bande de la reponse en
% frequence (|H1*Hr|) qui est plus large que celle de |Hc| donc en gros on arrive à reconnaitre le mapping du signal (2 choix distincts sur le diagramme de l'oeuil)
%alors que quand je choisis une bande |H1*Hr| plus restreinte pour BW=1000,
%on a un diagramme de l'oeuil mélangé dcp  on arrive pas à retrouver le
%mapping et à retrouver le signal de départ.


r_filtre = filter(hc,1,[Signal_Filtre1 zeros(1,retard)]);
z2 = filter(hr,1,r_filtre(1,retard+1:end));
diagramme_oeuil2 = reshape(z2,Nsbin,floor(length(z2)/Nsbin)); 
figure(7);
plot(diagramme_oeuil2);
xlabel("Temps(s)");
ylabel("Amplitude");
title("Diagramme de l'oeuil avec le filtre du canal BW=8000");
grid on;

%tracé les reponses fréquencielles |H1*Hr| et |Hc|
H1 = fft(h1,1024);
Hr = fft(hr,1024);
Hc = fft(hc,1024);
G= abs(H1.*Hr);

Frequence = linspace(-BW,BW,length(Hc));
figure(8);
semilogy(Frequence,fftshift(G/max(G)));
hold on;
semilogy(Frequence,fftshift(abs(Hc/max(Hc))));
hold off;
xlabel("Fréquance(Hz)");
ylabel("Amplitude");
title("Réponses fréquentielles des filtres BW=8000");
legend({'|H1*Hr|','|Hc|'});

% echantillonage à t0=Ts 
z_ech8000 = z2(Nsbin : Nsbin : end ) ; 

% Decision
Seuil = 0;
SymboleDecide8000 = zeros(1,length(z_ech8000));
SymboleDecide8000(z_ech8000>Seuil) = V;
SymboleDecide8000(z_ech8000<-Seuil) = -V;

% Estimation du TEB du signal échantilloné 
bits_estimes8000=zeros(1,Nbits); 
bits_estimes8000(z_ech8000>0) = 1;
TEB8000 = sum(bits ~=bits_estimes8000)/Nbits ;

%% Avec BW=1000
BW2 = 1000;
hc2 = BW2 * sinc(BW2*Temps);

%tracé la réponse impulsionelle golbale de la chaine de transmission
hglobal2 = conv(g,hc2); 
figure(9);
plot(hglobal2);
xlabel("Temps(s)");
ylabel("Amplitude");
title("Réponse impulsionelle globale de la chaine de transmission BW=1000");
grid on;


r_filtre2 = filter(hc2,1,[Signal_Filtre1 zeros(1,retard)]);
z22 = filter(hr,1,r_filtre2(1,retard+1:end));
diagramme_oeuil2 = reshape(z22,Nsbin,floor(length(z22)/Nsbin)); 
figure(10);
plot(diagramme_oeuil2);
xlabel("Temps(s)");
ylabel("Amplitude");
title("Diagramme de l'oeuil avec le filtre du canal BW=1000");
grid on;

%tracé les reponses fréquencielles |H1*Hr| et |Hc|
Hc2 = fft(hc2,1024);
G2= abs(H1.*Hr);

Frequence2 = linspace(-BW2,BW2,length(Hc2));
figure(11);
semilogy(Frequence2,fftshift(G2/max(G2)));
hold on;
semilogy(Frequence2,fftshift(abs(Hc2/max(Hc2))));
hold off;
xlabel("Fréquence(Hz)");
ylabel("Amplitude");
title("Réponses fréquentielles des filtres BW2=1000");
legend({'|H1*Hr|','|Hc|'});

% echantillonage à t0=Ts 
z_ech1000 = z22(Nsbin : Nsbin : end ) ; 

% Decision
Seuil = 0;
SymboleDecide1000 = zeros(1,length(z_ech1000));
SymboleDecide1000(z_ech1000>Seuil) = V;
SymboleDecide1000(z_ech1000<-Seuil) = -V;

% Estimation du TEB du signal échantilloné 
bits_estimes1000 = zeros(1,Nbits); 
bits_estimes1000(z_ech1000>0) = 1;
TEB1000 = sum(bits ~=bits_estimes1000)/Nbits ;

% on remarque que pour BW=8000 --> on a TEB=0 donc pas d'erreurs car pas
% d'interférences entre symboles alors que pour BW=1000 interference pro
% max et dcp TEB>0







