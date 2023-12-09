clc;
clear;

X = 0:1/10:10;

A = zeros(1,numel(X));
for i = 1:1:numel(X)
    x = X(i);
    if x <= 5
        A(i) = 1.75-0.75*cos((0.2*x - 1.0)*pi);
    else
        A(i) = 1.25-0.25*cos((0.2*x - 1.0)*pi);
    end
end
Y = (A./pi).^(1/2);
Y_mmeters = Y.*2.54;
X_mmeters = X.*2.54;
Table = transpose([X_mmeters;Y_mmeters]);
Table = [ones(size(Table,1),1),Table];
dlmwrite('coords.txt',Table,'delimiter','\t','precision',6)