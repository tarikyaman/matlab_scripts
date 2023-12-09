clc;
clear;

base_son = "5158";
base_on = "5158";
ic_siralar = ["5158","85","5162","5191"];
L_ic_siralar = [0.0040,0.12,0.02,0.1350];
L_ic_siralar_s = string(L_ic_siralar);
for L_ic_siralar_index = 1:numel(L_ic_siralar_s)
    L_ic_siralar_s(L_ic_siralar_index) = strrep(L_ic_siralar_s(L_ic_siralar_index),"0.0",".0");
end

base_L_son = 0.0080;
base_L_son_s = ".0080";
base_L_on = 0.0015;
base_L_on_s = ".0015";



eks = ["10003","10002","10004","10005","10006","10001"];
eks_2 = ["PCM_RT_18","PCM_RT_21","PCM_RT_22","PCM_RT_24","PCM_RT_25","PCM_RT_28"];

ek_L = [0.001:0.001:0.01,0.012:0.002:0.030];
ek_Ls = string(ek_L);
for ek_index = 1:numel(ek_Ls)
    ek_Ls(ek_index) = strrep(ek_Ls(ek_index),"0.0",".0");
end

ek_L_2 = ek_L.*1000;
d = 0;
str = "";
base_txt = "#degisen_1  #degisen_2  #1  #1-Auto-calculate  #.04  #.13  #19.87  #2.152  #5.13  #5.54  #  #degisen_3  #degisen_4  #degisen_5  #degisen_6  #degisen_7  #degisen_8  #degisen_9  #1  #1  #1  #1  #1  #1  #1  #1  #1  #1  #1  #1  #1  #degisen_10  #degisen_11  #degisen_12  #degisen_13 #degisen_14  #degisen_15  #degisen_16  #.2  #.2  #.2  #.2  #.2  #.2  #.2  #.2  #.2  #.2  #.2  #.2  #.2  #7  #  #1  #1  #1  #1  #1  #1  #1  #1  #1  #1  #1  #1  #1  #1  #1  #1  #1  #1  #1  #1  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #1-Auto-calculate  #1-Auto-calculate  #1-Auto-calculate  #0  #  #315  #0  #12.04.2023 01:59:19  #1-Auto-calculate  #1-Auto-calculate  #1-Auto-calculate  #1-Auto-calculate  #  #1-Layers  #1-Auto-calculate  #1  #8  #87.528  #0  #1-Exterior  #  #  #0  #0  #0  #0  #0  #0  #0  #11  #0  #2.5  #293  #0  #1  #1-D  #.3  #.99  #1.264  #1-Auto-calculate  #1-Default  #0  #15  #5  #15  #10  #1  #1  #1  #1-Isolation par l'intérieur  #  #0-Marquage CE système 1+  #1-Simple  #1  #1  #3-Integrated Surface Outside Face  #1  #1  #0  #  #0  #0  #12632256";
%materyaller dıştan içe
%degisen_1 ürün sıra no
%degisen_2 ürün_adı
%degisen_3_9 tabaka_kodu
%degisen_10_16 tabaka_kalinlik
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
fid = fopen('PCM_CONFIGS.txt','wt');
for pcm_sirasi = 1:numel(ic_siralar)+1
    for ii = 1:numel(eks)
        for iii = 1:numel(ek_L)
            d = d + 1;
            secilen_pcm = eks(ii);
            secilen_pcm_length = ek_Ls(iii);
            if pcm_sirasi == 1
                takim = [secilen_pcm,ic_siralar];
                takim_L = [secilen_pcm_length,L_ic_siralar_s];
            elseif pcm_sirasi == 5
                takim = [ic_siralar,secilen_pcm];
                takim_L = [L_ic_siralar_s,secilen_pcm_length];
            else
                takim_1 = ic_siralar(1:pcm_sirasi-1);
                takim_1_L = L_ic_siralar_s(1:pcm_sirasi-1);
                takim_2 = secilen_pcm;
                takim_2_L = secilen_pcm_length;
                takim_3 = ic_siralar(pcm_sirasi:end);
                takim_3_L = L_ic_siralar_s(pcm_sirasi:end);
                takim = [takim_1,takim_2,takim_3];
                takim_L = [takim_1_L,takim_2_L,takim_3_L];


            end
            son_takim =[base_on,takim,base_son];
            son_takim_L = [base_L_on_s,takim_L,base_L_son_s];
            table(8*d-7:8*d-1,1) = transpose(son_takim);
            table_L(8*d-7:8*d-1,1) = transpose(son_takim_L);
            txt_v1 = regexprep(base_txt,"\<degisen_1\>",string(double(13000+d)));
            txt_v2 = regexprep(txt_v1,"\<degisen_2\>",sprintf('PCM_DUVAR_SIRA_%d_KALINLIK_%s_%s',pcm_sirasi+1,string(double(ek_L_2(iii))),eks_2(ii)));
            txt_v3 = regexprep(txt_v2,"\<degisen_3\>",son_takim(1));
            txt_v4 = regexprep(txt_v3,"\<degisen_4\>",son_takim(2));
            txt_v5 = regexprep(txt_v4,"\<degisen_5\>",son_takim(3));
            txt_v6 = regexprep(txt_v5,"\<degisen_6\>",son_takim(4));
            txt_v7 = regexprep(txt_v6,"\<degisen_7\>",son_takim(5));
            txt_v8 = regexprep(txt_v7,"\<degisen_8\>",son_takim(6));
            txt_v9 = regexprep(txt_v8,"\<degisen_9\>",son_takim(7));
            txt_v10 = regexprep(txt_v9,"\<degisen_10\>",string(son_takim_L(1)));
            txt_v11 = regexprep(txt_v10,"\<degisen_11\>",string(son_takim_L(2)));
            txt_v12 = regexprep(txt_v11,"\<degisen_12\>",string(son_takim_L(3)));
            txt_v13 = regexprep(txt_v12,"\<degisen_13\>",string(son_takim_L(4)));
            txt_v14 = regexprep(txt_v13,"\<degisen_14\>",string(son_takim_L(5)));
            txt_v15 = regexprep(txt_v14,"\<degisen_15\>",string(son_takim_L(6)));
            txt_v16 = regexprep(txt_v15,"\<degisen_16\>",string(son_takim_L(7)));
            fprintf(fid,'%s\n',txt_v16);
        end
    end
end
T = [string(table),string(table_L)];