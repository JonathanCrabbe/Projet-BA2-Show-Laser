%script son_param

%Un sample est un "point" du graphe de l'onde sonore

bps = 16;       % bits per sample (précision des samples)
sps = 8000;     % sample rate (samples/s)
nsecs = 1/25;      % durée du son

nsamples = sps*nsecs;  %Pas d'échantillonage 

time = linspace(0, nsecs, nsamples); %Création de l'axe temps

alpha = pi/4; %Angle miroir1 - verticale
beta = pi/4; %Angle miroir2 - verticale
gamma = pi/6; %Inclinaison dispositif
D = 2,5  %Distance miroir2 - écran

[x y] = [cos(time) sin(time)]  %Paramétrisation de la courbe
[theta1 theta2] = [cos(gamma)*x/2D ((cos(gamma))^2) *y/2D ]  %Evolution temporelle des deux angles




signal1 = ;  %Signal galvo1

signal2 = ;  %Signal galvo2



vecteur = [signal1'  signal2' ];  %Création de la matrice contenant les signaux


wavwrite(vecteur, sps, bps, 'audio.wav');   %Ecriture du fichier son