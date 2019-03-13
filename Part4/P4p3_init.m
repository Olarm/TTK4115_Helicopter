% FOR HELICOPTER NR 3-10
% This file contains the initialization for the helicopter assignment in
% the course TTK4115. Run this file before you execute QuaRC_ -> Build 
% to build the file heli_q8.mdl.

% Oppdatert h�sten 2006 av Jostein Bakkeheim
% Oppdatert h�sten 2008 av Arnfinn Aas Eielsen
% Oppdatert h�sten 2009 av Jonathan Ronen
% Updated fall 2010, Dominik Breu
% Updated fall 2013, Mark Haring
% Updated spring 2015, Mark Haring


%%%%%%%%%%% Calibration of the encoder and the hardware for the specific
%%%%%%%%%%% helicopter
Joystick_gain_x = 1;
Joystick_gain_y = -1;


%%%%%%%%%%% Physical constants
g = 9.81; % gravitational constant [m/s^2]
l_c = 0.46; % distance elevation axis to counterweight [m]
l_h = 0.66; % distance elevation axis to helicopter head [m]
l_p = 0.175; % distance pitch axis to motor [m]
m_c = 1.92; % Counterweight mass [kg]
m_p = 0.72; % Motor mass [kg]

V_s = 7.3;
K_f = g*(2*m_p*l_h-m_c*l_c)/(V_s*l_h);
J_p = 2*m_p*l_p^2;
J_e = m_c*l_c^2+2*m_p*l_h^2;
J_lam = m_c*l_c^2 + 2*m_p*(l_h^2 + l_p^2);
K1 = l_p*K_f/J_p;
K2 = l_h*K_f*V_s/J_e;
K3 = -g*(2*m_p*l_h - m_c*l_c)/J_lam;
V_star = (2*m_p*g*l_h-m_c*g*l_c)/(l_h*K_f);

% 5.4.3
%system from 5.3.3
Aa = [0 1 0 0 0; 0 0 0 0 0; 0 0 0 0 0; 1 0 0 0 0; 0 0 1 0 0];
Ba = [0 0; 0 K1; K2 0; 0 0; 0 0];
Ca = [1 0 0 0 0; 0 0 1 0 0];
Qa = [10 0 0 0 0; 0 1 0 0 0; 0 0 1000 0 0; 0 0 0 0.1 0; 0 0 0 0 0.8];
Ra = [0.5 0; 0 0.1];
Ka = lqr(Aa,Ba,Qa,Ra);

% Estimator
A = [0 1 0 0 0 0; 0 0 0 0 0 0; 0 0 0 1 0 0; 0 0 0 0 0 0; 0 0 0 0 0 1; K3 0 0 0 0 0];
B = [0 0 ; 0 K1; 0 0; K2 0; 0 0; 0 0];
C = [0 0 1 0 0 0; 0 0 0 0 1 0];
Q = [1 0 0 0 0 0; 0 1 0 0 0 0; 0 0 100 0 0 0; 0 0 0 10 0 0; 0 0 0 0 10 0; 0 0 0 0 0 1];
R = [1 0; 0 1];

poles = [-250, -90, -70,  -120, -3, -1];
L = place(A',C',poles)';