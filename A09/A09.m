% Marcos Vinicius Firmino Pietrucci
% 10914211
% Assigment 9

%Defining the exponential rates in minutes
tscan = 2;
tnight = 18;  
tsun = 3;
tcloudy = 8;  %Related to Down states

%Given the times we can calculate the rates!
scan_r = 1/tscan;
night_r = 1/tnight;
sun_r = 1/tsun;
cloudy_r = 1/tcloudy;

%Defining the weather probability
prob_night = 0.5;
prob_sun = 0.3333;
prob_cloud = 0.1637;

%Generating the states vectors
%The order: SCAN-NIGHT-SUNNY-CLOUDY
SCAN = [0, scan_r*prob_night, scan_r*prob_sun, scan_r*prob_cloud];
q1 = -sum(SCAN(2:4));
SCAN(1) = q1;

NIGHT = [night_r, -night_r, 0, 0];
SUNNY = [sun_r, 0,-sun_r, 0];
CLOUD = [cloudy_r, 0, 0, -cloudy_r];


%Creating the infentesimal generator
Q = [SCAN;NIGHT;SUNNY;CLOUD];

%Calculating the steady state probability of the system
Qp = [Q(:, 1:3), ones(4,1)];

pi_lim = [0,0,0,1] *inv(Qp);

%Reward vector related to power consumption
alpha_power = [12, 0.1, 0.1, 0.1];
avg_powCom = pi_lim *alpha_power';

%Reward matrix related to power consumption
%The order: SCAN-NIGHT-SUNNY-CLOUDY
reward_m = []

