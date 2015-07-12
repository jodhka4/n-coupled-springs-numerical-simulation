% A numerical simulation of n springs coupled linearly
% picture: |---m---m---m--- ... ---m---m|
% where --- means spring, m means mass
% we let the position of the nth mass from the left be xn
% system of n coupled equations:
% 
% mx1'' = -kx1 + k(x2 - x1)
% mx2'' = -k(x2 - x1) + k(x3 - x2)
% ...
% mx_n'' = -k(x_n - x_(n-1)) - kx_n
% 
% -----------------------------------------------------------
% Create all the variables
% All the information on each mass is stored in the structure M
% e.g. M.m1.mass is the mass of the first mass from the left
% each mass's k value corresponds to the spring on the LEFT of the mass,
% which means that an extra spring constant for the furthest right spring
% has to be defined - called klast


clear
close all

%------------------------------------------------
% Booleans to determine what the program will do ('user input' here)

PlotMotion = false;              % plot the position-time graph of each mass
PlotFourier = false;            % plot the fourier transform of the entire position-time wave of later specified masses
PlotMaxfreq = false;             % plot the maximum frequency of the fourier transform of position-time over time
PlotSpectro = false;            % plot the spectrogram of later specified masses
AnimateFourier = false;         % show the time evolution of the fourier transform of later specified masses

%------------------------------------------------


n = 16;                       % number of masses
klast = 250;                  % spring constant of furthest right spring

% preallocate the memory for the structure by defining the last element
M(n).x = 0;                   % position [m]
M(n).xp = 0;                  % velocity [m/s]
M(n).mass = 0.1;              % mass [kg]
M(n).k = 250;                 % spring constant [N/n]

% fill every other value in the structure
for h = 1:n
    M(h).x = 0;               % position [m]
    M(h).xp = 0;              % velocity [m/s]
    M(h).mass = 0.1;          % mass [kg]
    M(h).k = 250;             % spring constant [N/n]
end


% set initial conditions by changing either position or velocity
M(1).x = 1;

% get a vector with the initial conditions
initial = zeros(1, 2*n);
initial(1, 1:2:length(initial)) = [M.x];
initial(1, 2:2:length(initial)) = [M.xp];

% integration time
t0 = 0;
dt = 0.0001;
tf = 3;

%------------------------------------------------

% solve the ODE
[t, y] = ode45(@NcoupledFunction, (t0:dt:tf), initial, [], n, klast, M);

% graph any quantities
GraphMotion(t,y,n, PlotMotion)

% plot any fourier/spectrograms
Spectro(y, t, t0, tf, [1, 16], PlotFourier, PlotMaxfreq, PlotSpectro, AnimateFourier)












