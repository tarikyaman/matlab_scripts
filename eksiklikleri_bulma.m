clc;
clear;
load("wspace.mat")
T_index = "";
T_str = "";
d = 0;
for i = 1:numel(asil_list)
    eleman = asil_list(i);
    dog = sum(eleman == ref_3_list);
    if dog ~= 1 
        d = d + 1;
        T_index(d,1) = i;
        T_str(d,1) = asil_list(i);
    end
end
exp_ref_3 = [string(T_index),T_str];
