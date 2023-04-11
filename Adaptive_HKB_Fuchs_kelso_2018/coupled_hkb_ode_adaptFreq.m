function xdot = coupled_hkb_ode_adaptFreq(t,x)
% bimanual rhythmic HKB

% variables d'�tats des oscillateurs :
% explication pour le premier des oscillateurs (eq (1 & 2))
% L'�quation initiale est du second ordre (acc�l�ration)
% on utilise une nouvelle variable, x(2)
% d�finit par eq(2) : xdot(2) = x(1)
% qui permet de r��crire HKB avec seulement des d�riv�es de premier ordre
% x(1) est la d�riv�e de x(2), donc
% la d�riv�e de x(1) est la d�riv�e
% seconde de x(2), c�d : dx1/dt = acc�l�ration = "xdot(1)"
% xdot(1) = acc�l�ration
% xdot(2) = vitesse = aussi x(1)
% c�d : x(1) = vitesse
% x(2) = position
% param�tres :
% delta = coef de Raleigh = facteur (x(1)cubic) dans Nordham et al. 2018 beta
% gamma = coef de VDP = facteur(x(1).x(2)carr�) Nordham et al. 2018 alpha
% epsi = coef de raideur = facteur x(1) Nordham et al. 2018 gamma
%

% Adaptation fr�quences :
% on agit sur le param�tre identifi� classiquement par "omega"
% Nb: L'usage de cette lettre vient de l'�quation d'onde
% dans laquelle omega est la pulsation (rad/sec)
% x(t) = A.cos(omega.t +phi)
% pour avoir l'acc�l�ration (origine = syst�me m�canique, d'o� on a inertie
% et  forces, donc acc�l�ration seconde loi Newton) :
% on d�rive cos() et on multiplie par omega (d�rivation fct compos�es
% d�riv�e de F(G(x) : la fct F contient la fct G qui est fct de x, ici
% (Nb : dans l'�quation d'onde notre x est le temps not� t)
% F = cos()
% G = omega.t + phi
% d�riv�e de F(G(x) = d�riv�e de G par rapport � t * d�riv�e de F par rapport � G
% Vitesse: dx/dt = - omega.A.sin(omega.t+phi)
% rebelote :
% Acc�l�ration: d2x/dt2 = omega.omega.A*(cos.t+phi)
% d'o� l'apparition d'un omega carr�

% oscillator parameters
gamma = 2;% VDP
delta = 1;% Rayleigh
epsi = 2;% negative linear damping
% Second coupling parameter
B = 0.5;

global A1 A2 trial_duration epsi1 epsi2;

if t < 1/3*trial_duration
    CHI = 0;
else if t >= 1/3*trial_duration && t < 2/3*trial_duration
        CHI = 1;
    else CHI = 0;  
    end % if condition : CHI changes with time
end

% CHI = 1;

xdot(1) = - delta * x(1)^3 - (x(5)^2) * x(2) - gamma * x(1) * x(2)^2 ...
+ epsi * x(1) + CHI  * (A1 + B * (x(2) - x(4))^2)*(x(1) - x(3)); % eq (1)

xdot(2) = x(1); % eq(2)


xdot(3) = - delta * x(3)^3 - (x(6)^2) * x(4) - gamma * x(3) * x(4)^2 ...
    + epsi * x(3) + CHI  * (A2 + B * (x(4) - x(2))^2)*(x(3) - x(1)); 

xdot(4) = x(3);

xdot(5) = CHI * epsi1 * x(1)*x(4);
xdot(6) = CHI * epsi2 * x(3)*x(2);


xdot = xdot';

