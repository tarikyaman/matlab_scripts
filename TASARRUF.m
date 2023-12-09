clc;
clear;
load("r_general.mat");
ref_2_1_tasarruf = 100.*(results_general(:,1)-results_general(:,2))./results_general(:,1);
ref_3_1_tasarruf = 100.*(results_general(:,1)-results_general(:,3))./results_general(:,1);
ref_4_1_tasarruf = 100.*(results_general(:,1)-results_general(:,4))./results_general(:,1);
ref_3_2_tasarruf = 100.*(results_general(:,2)-results_general(:,3))./results_general(:,2);
ref_4_2_tasarruf = 100.*(results_general(:,2)-results_general(:,4))./results_general(:,2);
