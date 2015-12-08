

%Un sample est un "point" du graphe de l'onde sonore

bps = 16;       % bits per sample (précision des samples)
sps = 8000;     % sample rate (samples/s)
nsecs = 4;      % durée du son

nsamples = sps*nsecs;  %Pas d'échantillonage 

time = linspace(0, nsecs, nsamples); %Création de l'axe temps

fin = columns(time);


%Paramètres miroirs:

alpha = pi/4; %Angle miroir1 - verticale
beta = pi/4; %Angle miroir2 - verticale
gamma = pi/6; %Inclinaison dispositif
D = 2.5;  %Distance miroir2 - écran

%Paramètres dynamiques:

In1 = 10; %Inertie du miroir1 selon son axe de rotation
In2 = 10; %Inertie du miroir2 selon son axe de rotation
r1 = 0.2; %Rayon spire bobinage galvo1
r2 = 0.2; %Rayon spire bobinage galvo2
n1 = 10; %Densité linéique bobinage galvo1
n2 = 10; %Densité linéique bobinage galvo2
Ba1 = 5; %Champ aimant permanent galvo1
Ba2 = 5; %Champ aimant permanent galvo2
Br1 = 7; %Champ magnétique rotor1
Br2 = 7; %Champ magnaatique rotor2





%Paramètres circuits:

m1 = 2;  %Moment magnétique du miroir 1
m2 = 2;  %Moment magnétique du miroir 2
L1 = 5;  %Inductance galvo1
L2 = 5;  %Inductance galvo2
R1 = 1;  %Résistance galvo1
R2 = 1;  %Résistance galvo2
S1 = 1;  %Surface subissant le flux magnétique dans le galvo1
S2 = 1;  %Surface subissant le flux magnétique dans le galvo2
G1 = 1;  %Gain ampli op1
G2 = 1;  %Gain ampli op2

mu0 = 4*pi*10^(-7);  %Permitivité relative du vide 


%Paramétrisation de la courbe


x = cos(2*pi*440*time);
y = sin(2*pi*440*time);



%Evolution temporelle des deux angles (résultats cinématique miroirs):

theta1 = (cos(gamma)/2*D) *x;
theta2 = (((cos(gamma))^2)/2*D) *y;  


%Evolution temporelle des intensités dans les galvos (résultats dynamique):

%Calcul des dérivées premières (approximations):

d1_theta1 = zeros(1,fin);
d1_theta2 = zeros(1,fin);

d1_theta1(1,fin) = (theta1(1,fin)-theta1(1,fin-1))/(time(1,fin)-time(1,fin-1));
d1_theta2(1,fin) = (theta2(1,fin)-theta2(1,fin-1))/(time(1,fin)-time(1,fin-1));

for i = 1:fin-1

h = time(1,i+1) - time(1,i);

d1 = theta1(1,i+1) - theta1(1,i); 
d1_theta1(1,i) = d1/h;

d2 = theta2(1,i+1) - theta2(1,i);
d1_theta2(1,i) = d2/h;

end


%Calcul des dérivées secondes (approximations):

d2_theta1 = zeros(1,fin);
d2_theta2 = zeros(1,fin);

d2_theta1(1,fin) = (d1_theta1(1,fin)-d1_theta1(1,fin-1))/(time(1,fin)-time(1,fin-1));
d2_theta2(1,fin) = (d1_theta2(1,fin)-d1_theta2(1,fin-1))/(time(1,fin)-time(1,fin-1));

for i = 1:fin-1

h = time(1,i+1) - time(1,i);

d1 = d1_theta1(1,i+1) - d1_theta1(1,i); 
d2_theta1(1,i) = d1/h;

d2 = d1_theta2(1,i+1) - d1_theta2(1,i);
d2_theta2(1,i) = d2/h;

end


%Définition des intensités:

C1 = (r1*(5/4)^(3/2))./(mu0*n1*cos(theta1));
I1 = C1.*(Ba1*sin(theta1)- In1*d2_theta1*mu0/(Br1*L1*S1));                         

C2 = (r2*(5/4)^(3/2))./(mu0*n2*cos(theta2));
I2 = C2.*(Ba2*sin(theta2)- In2*d2_theta2*mu0/(Br2*L2*S2));


%Signaux à envoyer (résultats résolution circuits):

%Calcul des dérivées premières (approximations):

d1_I1 = zeros(1,fin);
d1_I2 = zeros(1,fin);

d1_I1(1,fin) = (I1(1,fin)-I1(1,fin-1))/(time(1,fin)-time(1,fin-1));
d1_I2(1,fin) = (I2(1,fin)-I2(1,fin-1))/(time(1,fin)-time(1,fin-1));

for i = 1:fin-1

h = time(1,i+1) - time(1,i);

d1 = I1(1,i+1) - I1(1,i); 
d1_I1(1,i) = d1/h;

d2 = I2(1,i+1) - I2(1,i);
d1_I2(1,i) = d2/h;

end


%Sauvegarde des signaux

signal1 = (L1*d1_I1 + R1*I1)/G1;  %Signal galvo1

signal2 = (L2*d1_I2 + R2*I2)/G2;  %Signal galvo2

%Normalisation des signaux (valeurs en output entre 0 et 1)

M1 = max(signal1(1,:));
M2 = max(signal2(1,:));
signal1 = signal1/M1;
signal2 = signal2/M2;


vecteur = [signal1'  signal2'];  %Création de la matrice contenant les signaux


wavwrite(vecteur, sps, bps, 'audio.wav');   %Ecriture du fichier sons