clc;
clear;

syms T
cp(T) = (23.55055 + 6.89498*1e-3*T - 2.95229*1e-6*T^2 + 1.78088*1e-9*T^3 - 84616.4/T^2)/(0.0635);
T_datas = 300:1:1000;
Q = zeros(numel(T_datas)-1,1);
Q(1,1) = NaN;
m = 1000;
for i = 2:numel(T_datas)
    Q(i,1) = m*double(int(cp,T,T_datas(i-1),T_datas(i)));
end
L1 = transpose(T_datas(1:end-1));
L2 = transpose(T_datas(2:end));
L3 = Q(2:end);   
Table = [L1,L2,L3];
fid = fopen('copper.txt','wt');
fprintf(fid,'%-30s%-30s%-30s\n\n','Başlangıç Sıcaklığı (Kelvin)','Bitiş Sıcaklığı (Kelvin)','Gerekli Enerji Miktarı (Joule)');
fprintf(fid,'%-30d%-30d%-30d\n',transpose(Table));
fclose(fid);