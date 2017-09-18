clear
clc
rehash;

%%

con.a = 1;
con.b = 2;

c = Conf;
c.config.b = 3;
c.config.c = 4;


c.mergewith(con)


%% “ª∞„…Ë÷√
% c.setRootPath;
c.setRootPath('D:\work\root\');
c.recalcPaths;
c.addPaths;