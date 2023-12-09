clc;
clear;

syms L b n ind positive
F_ind(L,b,n,ind) = (b^(((ind-1)/(n-1))))*(L*(b^((1/(n-1)))-1)/(b^((n/(n-1)))-1));
F_1(L,b,n) = L*(b^((1/(n-1)))-1)/(b^((n/(n-1)))-1);
assume(L > F_1(L,b,n));
L_1 = 0.99999;
L_m = 100;
n_m = 100;
b_m = 1.2;
%b_m = 
assume(L>L_1);
assume(b > 0);
assume(n>=2);
B = double(vpasolve(F_1(L_m,b,n_m) == L_1,b));
N = double(vpasolve(F_1(L_m,b_m,n) == L_1,n));
Length = double(vpasolve(F_1(L,b_m,n_m) == L_1,L));