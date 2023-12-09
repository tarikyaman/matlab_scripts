function TOTALLENGTH = LENGTH(L_1,b,n)

L0 = 2.220446049250313e-15;
L1 = 9.007199254740992e+12;

TOTALLENGTH = (L0+L1)/2;

acc0 = L0*(b^((1/(n-1)))-1)/(b^((n/(n-1)))-1) - L_1;
accmid = TOTALLENGTH*(b^((1/(n-1)))-1)/(b^((n/(n-1)))-1) - L_1;
acc1 = L1*(b^((1/(n-1)))-1)/(b^((n/(n-1)))-1) - L_1;
error = abs(accmid);
while error > 10^-10
    if acc0*accmid < 0
        L1 = TOTALLENGTH;
        TOTALLENGTH = (L0+L1)/2;
        acc0 = L0*(b^((1/(n-1)))-1)/(b^((n/(n-1)))-1) - L_1;
        accmid = TOTALLENGTH*(b^((1/(n-1)))-1)/(b^((n/(n-1)))-1) - L_1;
        acc1 = L1*(b^((1/(n-1)))-1)/(b^((n/(n-1)))-1) - L_1;
        error = abs(accmid);
    elseif accmid*acc1 < 0
        L0 = TOTALLENGTH;
        TOTALLENGTH = (L0+L1)/2;
        acc0 = L0*(b^((1/(n-1)))-1)/(b^((n/(n-1)))-1) - L_1;
        accmid = TOTALLENGTH*(b^((1/(n-1)))-1)/(b^((n/(n-1)))-1) - L_1;
        acc1 = L1*(b^((1/(n-1)))-1)/(b^((n/(n-1)))-1) - L_1;
        error = abs(accmid);
    end
end
end


