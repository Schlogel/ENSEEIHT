%reconstitution d'images: 

function [signal_demoduler]= Demoduler_Images(x)
F0 = 1180;
F1 = 980;
Fs= 300;
Fe = 48000;
Te= 1 / Fe;
Ts =1 /Fs ; 
Ns = floor(Ts / Te);

Phi0 = rand*2*pi;
Phi1 = rand*2*pi;
theta0=rand*2*pi ;
theta1=rand*2*pi ;
Nbrbits=length(x)/Ns; 
Temps = 0:Te:(Ns*Nbrbits-1)*Te;


%bit 0: 
Integrale_Imagecos0=sum(reshape(x.*cos(2*pi*F0*Temps+theta0),Ns,Nbrbits )).^2;
Integrale_Imagesin0=sum(reshape(x.*sin(2*pi*F0*Temps+theta0),Ns,Nbrbits )).^2;
%bits 1
Integrale_Imagecos1=sum(reshape(x.*cos(2*pi*F1*Temps+theta1),Ns,Nbrbits )).^2;
Integrale_Imagesin1=sum(reshape(x.*sin(2*pi*F1*Temps+theta1),Ns,Nbrbits )).^2;

% finish
signal_demoduler=(Integrale_Imagesin1 + Integrale_Imagecos1)-(Integrale_Imagecos0+Integrale_Imagesin0)> 0 ;
end
