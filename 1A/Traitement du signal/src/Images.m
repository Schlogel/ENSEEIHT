%application de la fonction Démoduler_Images sur les signaux issus d'images
%de fichieri.mat avec i allant de 1 à 6
load("fichier1.mat");
image1 =reconstitution_image(Demoduler_Images(signal));
load("fichier2.mat");
image2=reconstitution_image(Demoduler_Images(signal));
load("fichier3.mat");
image3=reconstitution_image(Demoduler_Images(signal));
load("fichier4.mat");
image4=reconstitution_image(Demoduler_Images(signal));
load("fichier5.mat");
image5=reconstitution_image(Demoduler_Images(signal));
load("fichier6.mat");
image6=reconstitution_image(Demoduler_Images(signal));
image_reconstituee=[image6 image1 image5;image2 image4 image3];
figure (16); 
image(image_reconstituee); 