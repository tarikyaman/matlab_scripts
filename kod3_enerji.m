% Define constants
T0 = 15; % ambient temperature in C
P0 = 1; % ambient pressure in bar
r = 10; % pressure ratio of gas turbine
n_t = 0.85; % isentropic efficiency of gas turbine
LHV = 50; % lower heating value of natural gas in MJ/kg
T4 = 500; % exhaust gas temperature at HRSG inlet in C
P4 = 1; % exhaust gas pressure at HRSG inlet in bar
T5 = 100; % exhaust gas temperature at HRSG outlet in C
P5 = 0.9; % exhaust gas pressure at HRSG outlet in bar
T6 = 140; % steam temperature at HRSG outlet in C
P6 = 3; % steam pressure at HRSG outlet in bar
n_h = 0.9; % isentropic efficiency of HRSG
W_e = 6; % electric power demand of plant in MW
Q_p = 30; % process heat demand of plant in MJ/s

% Convert units to SI
T0 = T0 + 273.15; % K
P0 = P0 * 100000; % Pa
LHV = LHV * 1000000; % J/kg
T4 = T4 + 273.15; % K
P4 = P4 * 100000; % Pa
T5 = T5 + 273.15; % K
P5 = P5 * 100000; % Pa
T6 = T6 + 273.15; % K
P6 = P6 * 100000; % Pa
W_e = W_e * 1000000; % W
Q_p = Q_p * 1000000; % W

% Define air and gas properties
cp_a = 1005; % specific heat of air at constant pressure in J/kg.K
cp_g = 1150; % specific heat of exhaust gas at constant pressure in J/kg.K
gamma_a = 1.4; % ratio of specific heats of air
gamma_g = 1.33; % ratio of specific heats of exhaust gas
R_a = 287; % gas constant of air in J/kg.K
R_g = 260; % gas constant of exhaust gas in J/kg.K

% Calculate gas turbine performance
T2s = T0 * r^((gamma_a - 1) / gamma_a); % isentropic temperature at compressor outlet in K
T2 = T0 + (T2s - T0) / n_t; % actual temperature at compressor outlet in K
W_c = cp_a * (T2 - T0); % compressor work per unit mass flow rate of air in J/kg
T3 = T2 + LHV / cp_g; % temperature at combustor outlet in K
W_t = cp_g * (T3 - T4); % turbine work per unit mass flow rate of exhaust gas in J/kg
W_net = W_t - W_c; % net work per unit mass flow rate of exhaust gas in J/kg
m_dot_g = W_e / W_net; % mass flow rate of exhaust gas in kg/s

% Calculate HRSG performance
m_dot_s = Q_p / (n_h * cp_g * (T4 - T5)); % mass flow rate of steam in kg/s
T7s = T6 - cp_g / cp_a * (T4 - T5); % isentropic temperature at HRSG outlet in K
T7 = T6 - n_h * (T6 - T7s); % actual temperature at HRSG outlet in K

% Display results
fprintf('Mass flow rate of exhaust gas: %.2f kg/s\n', m_dot_g);
fprintf('Mass flow rate of steam: %.2f kg/s\n', m_dot_s);
fprintf('Temperature at HRSG outlet: %.2f C\n', T7 - 273.15);
fprintf('Net work per unit mass flow rate of exhaust gas: %.2f kJ/kg\n', W_net / 1000);
fprintf('Heat input per unit mass flow rate of exhaust gas: %.2f kJ/kg\n', LHV / 1000);
fprintf('Thermal efficiency of gas turbine: %.2f %%\n', W_net / LHV * 100);
fprintf('Overall efficiency of cogeneration system: %.2f %%\n', (W_e + Q_p) / (m_dot_g * LHV) * 100);

% Plot T-s diagram
s0 = R_a * log(P0 / P0) - cp_a * log(T0 / T0); % entropy at state 0 in J/kg.K
s1 = s0; % entropy at state 1 in J/kg.K
s2s = s1; % isentropic entropy at state 2 in J/kg.K
s2 = cp_a * log(T2 / T0) - R_a * log(P0 / (r * P0)); % entropy at state 2 in J/kg.K
s3 = s2; % entropy at state 3 in J/kg.K
s4 = cp_g * log(T4 / T3) - R_g * log(P4 / P4); % entropy at state 4 in J/kg.K
s5 = s4; % entropy at state 5 in J/kg.K
s6s = s5 + cp_g / cp_a * (s2 - s1); % isentropic entropy at state 6 in J/kg.K
s6 = cp_a * log(T6 / T7) - R_a * log(P6 / P6); % entropy at state 6 in J/kg.K
s7s = s6; % isentropic entropy at state 7 in J/kg.K
s7 = s6 - n_h * (s6 - s7s); % entropy at state 7 in J/kg.K

% Plotting T-s diagram
s = [s0, s1, s2s, s2, s3, s4, s5, s6s, s6, s7s, s7];
T = [T0, T0, T2s, T2, T3, T4, T4, T6, T6, T7, T7];
plot(s, T);
xlabel('Entropy (J/kg.K)');
ylabel('Temperature (K)');
title('T-s Diagram');