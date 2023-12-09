Pressure = 1:10:300; %kPa
TC = -270:2:500; %Celcius Degree
TK = TC + 273;
Table = zeros(numel(TK)+1,numel(Pressure)+1);
Table(2:end,1) = transpose(TC);
Table(1,2:end) = Pressure;
for i = 2:1:numel(TK)+1
    for ii = 2:1:numel(Pressure)+1
    Table(i,ii) = (10^3)*(Pressure(ii-1))/(287.058*TK(i-1));
    end
end