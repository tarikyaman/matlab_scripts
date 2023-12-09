clc;
clear;
T_min = 16;
T_max = 30;
T_interval = 2;
T_opt_min_row = 18:1:26;
T_opt_interval = 1:1:4;
index = 0;
Table = ones(1,4);
base_txt = sprintf("#no_no  #name_name  #1  #False  #1  #  #0  #0  #0  #0  #0  #0  #0  #1  #0  #10  #1  #heating_set  #cooling_set  #5  #0  #0  #0  #0  #0  #0  #16777415  #0  #0  #DesignBuilder  #heating_set_back  #cooling_set_back  #0, 0, 0  #0,0,0  #0, 0, 0  #0, 0, 0  #0, 0, 0  #0, 0, 0  #0, 0, 0  #0, 0, 0  #0, 0, 0  #0, 0, 0  #0, 0, 0  #1  #1  #1  #1  #1  #7  #1  #1  #2  #2  #24  #315  #10  #-1  #0  #0  #  #0  #0  #0  #0  #.2  #.2  #1-Electricity from grid  #0  #.2  #1-Electricity from grid  #0  #.2  #1-Electricity from grid  #0  #.2  #0  #39  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #0  #100  #-1  #0  #  #  #  #  #0  #0  #0  #0  #.5  #0  #  #  #7  #7  #0  #0  #0  #0  #  #100  #100  #100  #100  #1  #0  #0  #16-Bureaux  #0-Logement  #0-Bureau  #0-Petit magazin de vente inférieure à 300m2  #0-Salle de jeux (hors restauration et bureau)  #0-Salle de classe  #0  #0-Chambre sans cuisine avec salle d'eau  #0-Salle de sport  #0-Salle de sport  #0-Salle de conférence  #0-Chambre sans cuisine avec salle de bain  #0-Aire de production  #0-Chambre sans cuisine avec salle d'eau  #0-Bureau standard  #0-Chambre sans cuisine avec salle de bain  #0-Chambre sans cuisine avec salle de bain  #0-Bureau standard  #0-Chambre sans cuisine avec salle de bain  #0-Chambre sans cuisine avec salle de bain  #0-Bureau standard  #0-Bureau standard  #0-Salle de restauration  #0-Salle de restauration  #0-Salle de restauration  #0-Salle de restauration  #0-Salle de restauration  #0  #0-Salle de classe  #0-Douches Collectives  #1-General  #1-General  #1-General  #0  #0  #0  #0  #0  #0  #8035  #1-Generic summer and winter clothing  #1  #.5  #.0000000382      ");
fid = fopen('temp_config.txt','wt');
for i = 1:numel(T_opt_interval)
      T_ek = T_opt_interval(i);
    for ii = 1:numel(T_opt_min_row)
        T_opt_min = T_opt_min_row(ii);
        T_opt_max = T_opt_min + T_ek;
        T_min_row = T_min:T_interval:T_opt_min-T_interval;
        T_max_row = T_opt_max+T_interval:T_interval:T_max;
        for iii = 1:numel(T_min_row)
            for iv = 1:numel(T_max_row)
                index = index + 1;
                Table(index,1:4) = [T_min_row(iii) T_opt_min T_opt_max T_max_row(iv)];
                txt_v1 = regexprep(base_txt,"\<no_no\>",sprintf('%s',string(double(13000+index))));
                txt_v2 = regexprep(txt_v1,"\<name_name\>",sprintf('02temp_vals_%d_%d_%d_%d',Table(index,1:4)));
                txt_v3 = regexprep(txt_v2,"\<heating_set_back\>",sprintf('%d',Table(index,1)));
                txt_v4 = regexprep(txt_v3,"\<heating_set\>",sprintf('%d',Table(index,2)));
                txt_v5 = regexprep(txt_v4,"\<cooling_set\>",sprintf('%d',Table(index,3)));
                txt_v6 = regexprep(txt_v5,"\<cooling_set_back\>",sprintf('%d',Table(index,4)));
                fprintf(fid,'%s\n',txt_v6);
            end
        end
    end
end
%fid = fopen('temp_config.txt','wt');
%fprintf(fid,'%3.1f %3.1f %3.1f %3.1f\n',transpose(Table));
fclose(fid);
close all;
