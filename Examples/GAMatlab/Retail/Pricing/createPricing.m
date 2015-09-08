dim = [1, 86401];
tariff = ones(dim);

len = floor(dim(2)/24);
% pr = price(8,:);
pr = [0*ones(1,12) 1*ones(1,4) 0*ones(1,8)];
for i = 1:24
    tariff((i-1)*len+1:i*len) = pr(i);
end

tariff(end) = tariff(end-1);

