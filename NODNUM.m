function NoD = NODNUM(L,L1,b)
n0 = 2;
n1 = 9.007199254740992e+12;
NoD = (n0+n1)/2;

acc0 = L*(b^((1/(n0-1)))-1)/(b^((n0/(n0-1)))-1) - L1;
accmid = L*(b^((1/(NoD-1)))-1)/(b^((NoD/(NoD-1)))-1) - L1;
acc1 = L*(b^((1/(n1-1)))-1)/(b^((n1/(n1-1)))-1) - L1;
error = abs(accmid);
while error > 10^-10
    if acc0*accmid < 0
        n1 = NoD;
        NoD = (n0+n1)/2;
        acc0 = L*(b^((1/(n0-1)))-1)/(b^((n0/(n0-1)))-1) - L1;
        accmid = L*(b^((1/(NoD-1)))-1)/(b^((NoD/(NoD-1)))-1) - L1;
        acc1 = L*(b^((1/(n1-1)))-1)/(b^((n1/(n1-1)))-1) - L1;
        error = abs(accmid);
    elseif accmid*acc1 < 0
        n0 = NoD;
        NoD = (n0+n1)/2;
        acc0 = L*(b^((1/(n0-1)))-1)/(b^((n0/(n0-1)))-1) - L1;
        accmid = L*(b^((1/(NoD-1)))-1)/(b^((NoD/(NoD-1)))-1) - L1;
        acc1 = L*(b^((1/(n1-1)))-1)/(b^((n1/(n1-1)))-1) - L1;
        error = abs(accmid);
    end
end
end
