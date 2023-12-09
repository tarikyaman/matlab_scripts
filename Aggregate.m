clc;
clear;

syms T
cp_ag(T) = -9e-4*T^2 + 1.512*T + 630.7;
cp_bit(T) = 7.1e-3*T^2 + 2.441*T + 1834.7;
fplot(cp_ag,[30 160])
xlabel('Sıcaklık [Celcius]')
ylabel('Özgül Isı [J KG^-1 K^-1]')
title('Aggregate Özgül Isı [30C - 160C]')
xlim([0 400])
ylim([0 1500])
hold on 
fplot(cp_ag,[160 300],'r')
xline(270)
xline(300)
yline(double(cp_ag(270)))
yline(double(cp_ag(300)))
kazanim_kg = double(int(cp_ag,T,270,300)); %kg başına joule
kazanim_ton = double(int(cp_ag,T,270,300))*1000; %ton başına joule