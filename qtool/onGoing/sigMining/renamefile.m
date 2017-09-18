
% universe  ='000300.SH' ;
% stockList = DH_E_S_IndexComps(universe, init_date,0 );
% if isempty(stockList), error('require at least one stock'); end


a=ls('d:\huajun\focus\sigMining\cache\');
a(1:2,:)= [];
cd('d:\huajun\focus\sigMining\cache\');
init_date ='20130101' ;
last_date ='20130130' ;



nFile = size(a,1);
for iF = 1:nFile
    copyfile(a(iF,:),   [a(iF,1:10),'_',init_date,'_',last_date,'.mat']);
    delete(a(iF,:));
end
