%script test_sonore1 

%Un sample est un "point" du graphe de l'onde sonore

bps = 16;       % bits per sample (précision des samples)
sps = 8000;     % sample rate (samples/s)
nsecs = 8;      % durée du son

nsamples = sps*nsecs;  %Pas d'échantillonage 

time = linspace(0, nsecs, nsamples); %Création de l'axe temps

freq = 440 ;
vecteur = [sin(time*2*pi*freq) ; ones(1,nsamples)];  %Création du signal voulu


wavwrite(vecteur, sps, bps, 'audio.wav');   %Ecriture du fichier son