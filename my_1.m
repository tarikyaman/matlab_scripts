clc;
clear;

base_son = "İç Sıva";
base_on = "Dalmaçyalı Dekoratif Son Kat Mineral Kaplama 1,5mm";
ic_siralar = ["Dalmaçyalı Isı Yalıtım Sıvası","Dalmaçyalı Double Carbon EPS","Kaba Sıva","Yatay Delikli Tuğla"];
L_ic_siralar = [0.0040,0.12,0.02,0.1350];
base_L_son = 0.0080;
base_L_on = 0.0015;


eks = ["PCM RT 18","PCM RT 21","PCM RT 22","PCM RT 24","PCM RT 25","PCM RT 28"];
ek_L = [0.001:0.001:0.01,0.012:0.002:0.030];
d = 0;
str = "";
base_txt = "#degisen_1  #degisen_2  #1  #1-Auto-calculate  #.04  #.13  #19.87  #2.152  #5.13  #5.54  #  #degisen_3  #degisen_4  #degisen_5  #degisen_6  #degisen_7  #degisen_8  #degisen_9  #1  #1  #1  #1  #1  #1  #1  #1  #1  #1  #1  #1  #1  #degisen_10  #degisen_11  #degisen_12  #degisen_13 #degisen_14  #degisen_15  #degisen_16  #.2  #.2  #.2  #.2  #.2  #.2  #.2  #.2  #.2  #.2  #.2  #.2  #.2  #7  #  #1  #1  #1  #1  #1  #1  #1  #1  #1  #1  #1  #1  #1  #1  #1  #1  #1  #1  #1  #1  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #5.447  #5.447  #.184  #0  #  #315  #0  #12.04.2023 01:59:19  #1-Auto-calculate  #1-Auto-calculate  #1-Auto-calculate  #1-Auto-calculate  #  #1-Layers  #1-Auto-calculate  #1  #8  #87.528  #0  #1-Exterior  #  #  #0  #0  #0  #0  #0  #0  #0  #11  #0  #2.5  #293  #0  #1  #1-D  #.3  #.99  #1.264  #1-Auto-calculate  #1-Default  #0  #15  #5  #15  #10  #1  #1  #1  #1-Isolation par l'intérieur  #  #0-Marquage CE système 1+  #1-Simple  #1  #1  #3-Integrated Surface Outside Face  #1  #1  #0  #  #0  #0  #12632256";
%materyaller dıştan içe
%degisen_1 ürün sıra no 
%degisen_2 ürün_adı
%degisen_3_9 tabaka_kodu 
%
%RT18 - 10003
%RT21 - 10002
%RT22 - 10004
%RT24 - 10005
%RT25 - 10006
%RT28 - 10001
%Dalmaçyalı Dekoratif Son Kat Mineral Kaplama 1,5mm - 5158
%Dalmaçyalı Isı Yalıtım Sıvası - 5158
%Dalmaçyalı Double Carbon EPS - 85
%Kaba Sıva - 5162
%Yatay Delikli Tuğla - 5191
%İç Sıva - 5158
%degisen_10_16 tabaka_kalınlığı . ile başlamalı
for pcm_sirasi = 1:numel(ic_siralar)+1
    for ii = 1:numel(eks)
        for iii = 1:numel(ek_L)
            d = d + 1;
            secilen_pcm = eks(ii);
            secilen_pcm_length = ek_L(iii);
            if pcm_sirasi == 1
                takim = [secilen_pcm,ic_siralar];
                takim_L = [secilen_pcm_length,L_ic_siralar];
            elseif pcm_sirasi == 5
                takim = [ic_siralar,secilen_pcm];
                takim_L = [L_ic_siralar,secilen_pcm_length];
            else
                takim_1 = ic_siralar(1:pcm_sirasi-1);
                takim_1_L = L_ic_siralar(1:pcm_sirasi-1);
                takim_2 = secilen_pcm;
                takim_2_L = secilen_pcm_length;
                takim_3 = ic_siralar(pcm_sirasi:end);
                takim_3_L = L_ic_siralar(pcm_sirasi:end);
                takim = [takim_1,takim_2,takim_3];
                takim_L = [takim_1_L,takim_2_L,takim_3_L];
            end
            son_takim =[base_on,takim,base_son];
            son_takim_L = [base_L_on,takim_L,base_L_son];
            table(8*d-7:8*d-1,1) = transpose(son_takim);
            table_L(8*d-7:8*d-1,1) = transpose(son_takim_L);
        end
    end
end
T = [string(table),string(table_L)];
