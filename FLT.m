function FIRSTLAYERTHICKNESS = FLT(L,b,n)
FIRSTLAYERTHICKNESS = L*(b^((1/(n-1)))-1)/(b^((n/(n-1)))-1);
end

