clc;
clear;

eq = @(x) (100*(x^(1/99) - 1))/(x^(100/99) - 1) - 0.999;
x0 = 2;
x1 = x0;
x2 = x0;
X0(1,1:2) = [x0,eq(x0)];
X1(1,1:2) = [x1,eq(x1)];
X2(1,1:2) = [x2,eq(x2)];
dval = 0.1;
if abs(eq(x0)) < 1e-10
    Val = x0;
elseif eq(x1) > 0
    i = 1;
    while eq(x1) > 0
        i = i + 1;
        x1 = x1 + dval;
        X1(i,1:2) =  [x1,eq(x1)];
        if i > 10
            if X1(i,2) > X1(i-1,2)
                ii = 0;
                while eq(x1) > 0
                    ii = ii + 1;
                    x1 = x1 - dval;
                    if x1 <= 1
                        interval = [1,X1(i+ii-1,1)];
                        break
                    end
                    X1(i+ii,1:2) =  [x1,eq(x1)];
                end
            end
        end
    end    
elseif eq(x2) < 0
    iii = 1;
    while eq(x2) < 0
        iii = iii + 1;
        x2 = x2 - dval;
        if x1 <= 1
            interval = [1,X2(i+ii-1,1)];
            break
        end
        X2(iii,1:2) =  [x2,eq(x2)];
        if X2(iii,2) < X2(iii-1,2)
            iiii = 0;
            while eq(x2) < 0
                iiii = iiii + 1;
                x2 = x2 + dval;
                X2(iii+iiii,1:2) =  [x2,eq(x2)];
            end
        end
    end
end