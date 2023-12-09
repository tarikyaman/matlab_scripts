function BIAS(L,L1,n)
digits(128);
if n < L/L1 && L > L1 && n>1 
b0 = 1+2e-10;
b1 = 9.007199254740992e+12;
Bias = (b0+b1)/2;

acc0 = L*(b0^((1/(n-1)))-1)/(b0^((n/(n-1)))-1) - L1;
accmid = L*(Bias^((1/(n-1)))-1)/(Bias^((n/(n-1)))-1) - L1;
acc1 = L*(b1^((1/(n-1)))-1)/(b1^((n/(n-1)))-1) - L1;
error = abs(accmid);
d = 0;
while error > 10^-20
    d = d + 1;
    if d < 10000
    if acc0*accmid < 0
        b1 = Bias;
        Bias = (b0+b1)/2;
        acc0 = L*(b0^((1/(n-1)))-1)/(b0^((n/(n-1)))-1) - L1;
        accmid = L*(Bias^((1/(n-1)))-1)/(Bias^((n/(n-1)))-1) - L1;
        acc1 = L*(b1^((1/(n-1)))-1)/(b1^((n/(n-1)))-1) - L1;
        error = abs(accmid);
    elseif accmid*acc1 < 0
        b0 = Bias;
        Bias = (b0+b1)/2;
        acc0 = L*(b0^((1/(n-1)))-1)/(b0^((n/(n-1)))-1) - L1;
        accmid = L*(Bias^((1/(n-1)))-1)/(Bias^((n/(n-1)))-1) - L1;
        acc1 = L*(b1^((1/(n-1)))-1)/(b1^((n/(n-1)))-1) - L1;
        error = abs(accmid);
    end
    elseif d >= 100
        error = 10^-21;
    end
    
end
fprintf('Bias : %20.16f\n\n',Bias);
else
    fprintf('Degerleri düzenleyiniz - Geçersiz değer veya hesaplama sınırı aşıldı\n\n');
end
end