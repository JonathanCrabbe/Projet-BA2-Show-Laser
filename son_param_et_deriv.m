

%Un sample est un "point" du graphe de l'onde sonore

bps = 16;       % bits per sample (pr�cision des samples)
sps = 8000;     % sample rate (samples/s)
nsecs = 5;      % dur�e du son

nsamples = sps*nsecs;  %Pas d'�chantillonage 

time = linspace(0, nsecs, nsamples); %Cr�ation de l'axe temps

fin = columns(time);


%Param�tres miroirs:

alpha = pi/4; %Angle miroir1 - verticale
beta = pi/4; %Angle miroir2 - verticale
gamma = pi/6; %Inclinaison dispositif
D = 2.5;  %Distance miroir2 - �cran                                     (m)

%Param�tres dynamiques:

In1 = 10;  %Inertie du miroir1 selon son axe de rotation          (kg * m�)
In2 = 10;  %Inertie du miroir2 selon son axe de rotation          (kg * m�)
r1 = 0.2;  %Rayon spire bobinage galvo1                                 (m)
r2 = 0.2;  %Rayon spire bobinage galvo2                                 (m)
N1 = 200;  %Nombre de spires par bobine  galvo1 
N2 = 200;  %Nombre de spires par bobine  galvo2
k1 = 5;    %Constante de raideur ressort galvo1                       (N*m)
k2 = 5;    %Constante de raideur ressort galvo2                       (N*m)
Br1 = 7;   %Champ magn�tique rotor1                                     (T)
Br2 = 7;   %Champ magn�tique rotor2                                     (T)
Vrot1 = 5; %Volume total rotor1                                       (m^3)
Vrot2 = 5; %Volume total rotor2                                       (m^3)
c1 = 0;    %Coefficient de frottement dynamique galvo1              (N*M*s)
c2 = 0;    %Coefficient de frottement dynamique galvo1              (N*M*s)




%Param�tres circuits:

%{

Inutile en r�gime stationnaire:

L1 = 5;  %Inductance galvo1
L2 = 5;  %Inductance galvo2
R1 = 1;  %R�sistance galvo1
R2 = 1;  %R�sistance galvo2
S1 = 1;  %Surface subissant le flux magn�tique dans le galvo1
S2 = 1;  %Surface subissant le flux magn�tique dans le galvo2
G1 = 1;  %Gain ampli op1
G2 = 1;  %Gain ampli op2

%}

Rm1 = 5; %R�sistance d�terminante 1 (Ohm)
Rm2 = 5; %R�sistance d�terminante 2 (Ohm)
mu0 = 4*pi*10^(-7);  %Permitivit� relative du vide 


%Param�trisation de la courbe


x = cos(2*pi*40*time);
y = sin(2*pi*40*time);



%Evolution temporelle des deux angles (r�sultats cin�matique miroirs):

theta1 = (cos(gamma)/2*D) *x;
theta2 = (((cos(gamma))^2)/2*D) *y;  


%Evolution temporelle des intensit�s dans les galvos (r�sultats dynamique):

%Calcul des d�riv�es premi�res (approximations):

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


%Calcul des d�riv�es secondes (approximations):

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


%D�finition des intensit�s:

C1 = r1 ./ 2* Br1 * Vrot1 * N1 * cos(theta1)*(4/5)^(3/2);
I1 = C1.*(In1*d2_theta1 + c1*d1_theta1 + k1*theta1);                         

C2 = r2 ./ 2* Br2 * Vrot2 * N2 * cos(theta2)*(4/5)^(3/2);
I2 = C2.*(In2*d2_theta2 + c2*d1_theta2 + k2*theta2);


%Signaux �� envoyer (r�sultats r�solution circuits):


%{

Potentiellement inutile si on simplifie l'ED du crcuit

%Calcul des d�riv�es premi�res (approximations):

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

%}

%Sauvegarde des signaux

signal1 = Rm1 * I1 ;  %Signal galvo1

signal2 = Rm2 * I2 ;  %Signal galvo2

%Normalisation des signaux (valeurs en output entre 0 et 1)

M1 = max(signal1(1,:));
M2 = max(signal2(1,:));
signal1 = signal1/M1;
signal2 = signal2/M2;


vecteur = [signal1'  signal2'];  %Cr�ation de la matrice contenant les signaux


wavwrite(vecteur, sps, bps, 'audio.wav');   %Ecriture du fichier sons