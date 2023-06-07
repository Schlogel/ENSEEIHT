
% Nettoyer l'interface
clc;
clear all;
close all;

% Constantes

%Frequence d'echantillonage
Fe = 24000;
%fréquence porteuse
fp=2000;
% Debit binaire
Rb = 3000;
% Temps bianire
Tb = 1/Rb;
% Temps symbole
Ts = Tb;
% Nombre de bits
Nbits = 10000;
% Temps d'echantillonage 
Te = 1/Fe;
% Nombres de symboles 
Ns = floor(Ts / Te);
%Roll off
alpha = 0.35;
% Span
L = 8;
% retard 
retard = L*Ns/2;
% amplitude
V = 1;
 %%
%--------------------------------------------------------------------------
% chaine en transposition en frequence
%--------------------------------------------------------------------------

%% Debut de modulation
% Génération des bits
bits = randi([0 1],1, Nbits);

% Répartitions en deux vecteurs
bitPhase = bits(1:2:end);
bitQuadrature = bits(2:2:end);

% Mapping binaire de ak
SymbolesPha = zeros(1,length(bitPhase));
SymbolesPha(bits==1) = V;
SymbolesPha(bits==0) = -V;

% Mapping binaire de bk
SymbolesQua = zeros(1,length(bitQuadrature));
SymbolesQua(bits==1) = V;
SymbolesQua(bits==0) = -V;

% Calcul des deux canaux
ak = 2 * bitPhase - 1;
bk = 2 * bitQuadrature - 1;

% % Zero padding
% ak = [ak zeros(1, retard)];
% bk = [bk zeros(1, retard)];

% Calcul de dk
dk = ak + 1j*bk;

% Suréchantillonage
Tsbin = Tb ;
Nsbin = floor(Tsbin / Te);
surech = zeros(1,Nsbin - 1);
surech(1) = 1;
Xk = kron(dk,[1 zeros(1,Nsbin-1)]);
 
% Filtre de mise en forme
h = rcosdesign(alpha,L,Nsbin); %%peut etre alpha/2

%Ajout du zero padding sur le Xk
Signal_Filtre = filter(h,1,[Xk zeros(1,retard)]);           %%fliplr h?

% Suppression du zero padding
xe = Signal_Filtre(retard+1:end);
xe_reel = real(xe);
xe_imag = imag(xe);

%% tracé de signaux
figure(1);
subplot(2,1,1);plot(xe_reel);
xlabel("Temps(s)");
ylabel("Amplitude");
title("signaux g´en´er´es sur les voies en phase");
grid on;
subplot(2,1,2);plot(xe_imag);
xlabel("Temps(s)");
ylabel("Amplitude");
title("signaux g´en´er´es sur les voies en quadrature");
grid on;

% DSP de la partie reel et imaginaire du signal
XE_REEL = fft(xe_reel, 1024);
XE_IMAG = fft(xe_imag, 1024);
Frequence = linspace(-Fe,Fe,length(XE_REEL));

%% traces des DSP de ces signaux
figure(3);
subplot(2,1,1);semilogy(Frequence,fftshift(abs(XE_REEL)));
xlabel("Fréquence(Hz)");
ylabel("Puissance");
title("DSPI");
grid on;
subplot(2,1,2);semilogy(Frequence,fftshift(abs(XE_IMAG)));
xlabel("Fréquence(Hz)");
ylabel("Puissance");
title("DSPQ");
grid on;


%% Calcul de x(t) : signal qui va entrer au canal
Temps = 0:Te:(length(xe)-1)*Te;
x = real(xe .* exp(1i*2*pi*fp*Temps));

figure(2);
plot(Temps,x);
xlabel("Temps(s)");
ylabel("Amplitude");
title("signal transmis sur fréquence porteuse");
grid on;

%% DENSITE SPECTRALE: 

% densite spectrale du signal transmis sur frequence porteuse.
X = fft(x,1024);
figure(4);
semilogy(Frequence,fftshift(abs(X)));
xlabel("Fréquence(Hz)");
ylabel("Puissance");
title(" densité spectrale de puissance du signal transmis sur fr´equence porteuse");
grid on;

%% Démodulation sans bruit
xcos = x.*cos(2*pi*fp*Temps);
xsin = x.*sin(2*pi*fp*Temps);

% Signal à démoduler en bande de base
Signal_complex = xcos - 1i*xsin;

% Filtre de réception
hr = h;
Signal_z = filter(hr,1,[Signal_complex zeros(1,retard)]);
Signal_z = Signal_z(retard+1:end);
% Echantillonage
z_ech = Signal_z(1 : Nsbin : end ); 
z_ech_R = real(z_ech);
z_ech_I = imag(z_ech);

% Décision
    symboles_decides_real1 = sign(z_ech_R);
    symboles_decides_Im1 = sign(z_ech_I);
% Demapping
    bits_real1 = (symboles_decides_real1 + 1)/2;
    bits_Im1 = (symboles_decides_Im1 + 1)/2;
    bits_decides1 = zeros(1,Nbits);
    bits_decides1(1:2:end) = bits_real1;
    bits_decides1(2:2:end) = bits_Im1;

%Calcul du Teb
nb_erreur1 = length(find(bits~=bits_decides1));
TEB_1 = nb_erreur1/(Nbits); 
fprintf("TEB de la chaine sur fréquence porteuse sans bruit est : %f\n",TEB_1);
 
%% Canal avec bruit
 EbN0dB = 0:6;
 N = length(EbN0dB);
 Px = mean(abs(x).^2);
 TEB_EXP_QPSK = zeros(1,N);
 
 for i=1:N
     Sigma2N = (Px*Nsbin)/(2*log2(4)*10^(EbN0dB(i)/10));
     bruit = sqrt(Sigma2N) * randn(1, length(x));
     signal_Bruite = x + bruit;
     % Démodulation sans bruit
     xcos = 2*signal_Bruite.*cos(2*pi*fp*Temps);
     xsin = 2*signal_Bruite.*sin(2*pi*fp*Temps);
     
     % Signal à démoduler en bande de base
     Signal_complex = xcos - 1i*xsin;
     
     % Filtre de réception
     hr = h;
     Signal_z = filter(hr,1,[Signal_complex zeros(1,retard)]);
     Signal_z = Signal_z(retard+1:end);
  
     % Echantillonage
     z_ech = Signal_z(1 : Nsbin : end ); 
     z_ech_R = real(z_ech);
     z_ech_I = imag(z_ech);
     % decision
    symboles_deci = zeros(1,length(dk));
    for j=1:length(z_ech_I)
    
                if (z_ech_R(j) < 0 && z_ech_I(j) < 0)
                        symboles_deci(j) = -1 - 1i;
                end
                if (z_ech_R(j) >= 0 && z_ech_I(j) >= 0)
                        symboles_deci(j) = 1 + 1i;
                end
                if (z_ech_R(j)< 0 && z_ech_I(j) > 0)
                        symboles_deci(j) = -1 + 1i;
                end
                 if (z_ech_R(j) >= 0 && z_ech_I(j) <= 0)
                        symboles_deci(j) = 1 - 1i;
                 end
            end
        % Calcul du iéme TEB
        nb_erreur2 = length(find(dk~=symboles_deci));
        TEB_EXP_QPSK(1,i)= nb_erreur2/(Nbits); % TEB= TES/2 avec Nbits=2*length(dk)
     
 end
% Calcul du TEB théorique avec qfunc:nb_erreur3
TEB_TH_QPSK = qfunc(2*sqrt( 10 .^ ([0 : 6] / 10)) );
%Tracé du TEB theorique et du TEB experimental.
 figure(5);
semilogy(EbN0dB, TEB_EXP_QPSK,'*b-');
 hold on;
 semilogy(EbN0dB, TEB_TH_QPSK,'sr-');
 hold off;
 title("TEB estimé et théorique de la chaine sur fréquence porteuse");
 legend({'TEB_{estime}','TEB_{Theorique}'});
 xlabel("Eb/N0 (dB)");
 ylabel("TEB");

 %%
%--------------------------------------------------------------------------
% chaine passe-bas équivalente
%--------------------------------------------------------------------------

%% Question 1

 %Signal généré sur les voies en phase: 
 xe_reel = real(xe);
 %Signal généré sur les voies en quadrature: 
 xe_imag = imag(xe);
 %tracé
% en phase
figure(6);
subplot(2,1,1);plot(xe_reel);
xlabel("Temps(s)");
ylabel("Amplitude");
title("signaux générés sur les voies en phase");
grid on;
%en quadrature
subplot(2,1,2);plot(xe_imag);
xlabel("Temps(s)");
ylabel("Amplitude");
title("signaux générés sur les voies en quadrature");
grid on;
%% Question 2
% densité spectrale de puissance de l'enveloppe complexe associée signal transmis sur frequence porteuse.
Xe = fft(xe,1024);
figure(8);
semilogy(Frequence,fftshift(abs(Xe)));
xlabel("Fréquence(Hz)");
ylabel("Puissance");
title(" densité spectrale de puissance de l'enveloppe complexe");
grid on;
Xe_DSP = periodogram(xe);
X_DSP = periodogram(x);
%% Question 3
%Les tracés comparatifs de la DSP de l'enveloppe complexe et celle du
%signal sur frequence porteuse.

figure(9);
plot(fftshift(Xe_DSP),'g');hold on
plot((X_DSP),'r');
ylabel('DSP');
title('Figure 9 : Comparaison la densité spectrale de puissance des deux chaines');
legend('Chaine sur fréquence porteuse','Chaine passe-bas équivalente');

%% Canal avec bruit: 
EbN0dB = 0:6;
N = length(EbN0dB);
Px = mean(abs(xe).^2);
TEB_EXP_QPSK_EQ = zeros(1,N);

 for i=1:N
    Sigma2N = (Px*Nsbin)/(2*log2(4)*10^(EbN0dB(i)/10));
    bruit_reel=sqrt(Sigma2N) * randn(1, length(xe));
    bruit_imag=sqrt(Sigma2N) * randn(1, length(xe));
    bruit = bruit_reel + 1j*bruit_imag;
    signal_Bruite = xe + bruit;
    
    % Filtre de réception
    hr = h;
    Signal_z3 = filter(hr,1,[signal_Bruite zeros(1,retard)]);
    Signal_z3 = Signal_z3(retard+1:end);
    % Echantillonage
    z_ech3 = Signal_z3(1 : Nsbin : end ); 
    
    %tracé des constellations pour diff valeurs EBN0db
    figure(i+9);
    plot(real(z_ech3),imag(z_ech3),'ored','linewidth',3);
    xlim([-2 2]);
    ylim([-2 2]);
    title('Constellations en sortie de l échantillonneur');   
    z_ech_R3 = real(z_ech3);
    z_ech_I3 = imag(z_ech3);

    % Décision
    symboles_deci_3 = zeros(1,length(dk));
    for j=1:length(z_ech_I3)
        if (z_ech_R3(j) < 0 && z_ech_I3(j) < 0)
                symboles_deci_3(j) = -1 - 1i;
        end
        if (z_ech_R3(j) >= 0 && z_ech_I3(j) >= 0)
                symboles_deci_3(j) = 1 + 1i;
        end
        if (z_ech_R3(j)< 0 && z_ech_I3(j) > 0)
                symboles_deci_3(j) = -1 + 1i;
        end
         if (z_ech_R3(j) >= 0 && z_ech_I3(j) <= 0)
                symboles_deci_3(j) = 1 - 1i;
         end
    end
    % Calcul du iéme TEB
    nb_erreur3 = length(find(dk~=symboles_deci_3));
    TEB_EXP_QPSK_EQ(1,i)= nb_erreur3/(Nbits); %  TEB=TES/2 et Nbits=2*length(dk)
 end


%% Question 4
   % En sortie du Mapping 
    figure(17);
    plot(real(dk),imag(dk),'ored','linewidth',1);
    title(' Constellations en sortie du mapping');
    xlim([-2 2]);
    ylim([-2 2]);
%% Question 5
% Calcul du TEB théorique avec qfunc:
 TEB_TH_QPSK_EQ = (qfunc(sqrt(2*10.^(EbN0dB/10))));
%Tracé du TEB theorique et du TEB experimental.
 figure(19);
semilogy(EbN0dB, TEB_EXP_QPSK_EQ,'*b-');
 hold on;
 semilogy(EbN0dB, TEB_TH_QPSK_EQ,'sr-');
 hold off;
 title("TEB estimé et théorique de la chaine passe bas équivalente.");
 legend({'TEB_{estime}','TEB_{Theorique}'});
 xlabel("Eb/N0 (dB)");
 ylabel("TEB");

 %Figure facultative pour comaprer les modulateurs 8PSK et QPSK 
 figure(21);
 semilogy([0:6], TEB_EXP_QPSK_EQ,'*b-');
 grid;
 title("TEB estimés des modulateurs QPSK et 8PSK de la chaine passe bas équivalente.");
 legend({'TEB_{estime}'});
 xlabel("Eb/N0 (dB)");
 ylabel("TEB");
 %% Question 6 : Comparaison du TEB: chaine passe bas equivalent avec TEB sur frequence porteuse

%Tracé du TEB theorique et du TEB experimental.
figure(20);
semilogy(EbN0dB, TEB_EXP_QPSK_EQ,'*b-');
hold on;
semilogy(EbN0dB, TEB_EXP_QPSK,'sr-');
hold off;
title("TEB sur chaine passe bas équivalent et TEB sur fréquence porteuse");
legend({'TEB_{EXP_EQ}','TEB_{EXP_FP}'});
xlabel("Eb/N0 (dB)");
ylabel("TEB");







