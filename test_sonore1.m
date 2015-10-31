%script test_sonore1 

%Un sample est un "point" du graphe de l'onde sonore

bps = 16;       % bits per sample (précision des samples)
sps = 8000;     % sample rate (samples/s)
nsecs = 10;      % durée du son

nsamples = sps*nsecs;  %Pas d'échantillonage 

time = linspace(0, nsecs, nsamples); %Création de l'axe temps

freq = 440 ;
signal1 = sin(time*2*pi*freq);  %Premier signal (modifiez à votre guise)
signal2 = signal1               %Second signal (modifiez à votre guise)     
vecteur = [ signal1' signal2'];  %Création du signal total


wavwrite(vecteur, sps, bps, 'audio.wav');   %Ecriture du fichier son
