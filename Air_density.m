clc;
clear;


p = 101325; %Pressure %[PASCAL]
g_c_air = 287.05; %gas constant for air % [JOULE KG^-1 K^-1]
d = p/(t*g_c_air); %density %[KG M^-3]

%%
clc;
clear;
g_c_air = 287.05; %gas constant for air % [JOULE KG^-1 K^-1]
%t = 100:20:600; %Temperature %[KELVIN]
t = 55.5556; %Temperature %[KELVIN]
p1 = 0.1:0.001:1.2;
p = p1.*6894.76;
%Temperature %[KELVIN]
table = zeros(numel(t)+1,numel(p)+1);
table(1,2:end) = p1;
table(2:end,1) = t;
for i = 2:1:numel(t)+1
    for ii = 2:1:numel(p)+1
        table(i,ii) = p(ii-1)/(t(i-1)*g_c_air);
    end
end