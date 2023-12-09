clc;
clear;
close all;

% Bias Type : --- -- - -- ---

L = 100; %length of the side
B = 5; %Bias Factor
NoD = 1000; %Number of Division
B = 1/B;

if mod(NoD,2) == 1

Growth_Rate = B^(2/(NoD-1));
M = ones(NoD,1);
for i = 1:1:(NoD+1)/2
    M(i,1) = (L/(2*(((Growth_Rate^((NoD-1)/2)) - 1)/(Growth_Rate-1)) + Growth_Rate^((NoD-1)/2)))*(Growth_Rate^(i-1));
end
M(((NoD+1)/2)+1:end,1) = flip(M(1:((NoD+1)/2)-1,1));

elseif mod(NoD,2) == 0
    
Growth_Rate = B^(2/(NoD-2));
M = ones(NoD,1);
for i = 1:1:(NoD/2)
    M(i,1) = (L*(Growth_Rate-1)/(2*((Growth_Rate^(NoD/2))-1)))*(Growth_Rate^(i-1));
end
M(((NoD)/2)+1:end,1) = flip(M(1:((NoD)/2),1));
end

C = ones(NoD+1,1);

C(end,1) = L;
for i = NoD:-1:1
    C(i,1) = C(i+1,1)-M(i,1);
end
%%
fig1 = figure(1);
fig1.Position = [192 108 1536 864];
plot(C,zeros(NoD+1,1),'-*r')
title_str = sprintf('Bias Type : --- -- - -- --- , Total Length : %5.3f , NoD : %d , Bias Factor : %5.3f , Max-Size : %5.3f , Min-Size : %5.3f',L,NoD,1/B,max(M),min(M));
title(title_str)
xlim([0 L])
xline(C,'LineWidth',0.01)
%exportgraphics(fig1,'figure1.png','Resolution',300)
%%
Table = zeros(NoD,4);
Table(:,1) = transpose(1:1:NoD);
Table(:,2) = M;
Table(:,3) = C(1:(end-1),1);
Table(:,4) = C(2:end,1);
fid = fopen('Bias_Table.txt','wt');
fprintf(fid,'Bias Type : |--- -- - -- ---|\nBias Factor : %5.5f\nTotal Length : %5.5f\nNumber of Division : %d\n\n',B,L,NoD);
fprintf(fid,'|%-20s||%-20s||%-20s||%-20s|\n\n','Element No','Length','Start Point','End Point');
fprintf(fid,'|%-20d||%-20.10f||%-20.10f||%-20.10f|\n',transpose(Table));
fclose(fid);
