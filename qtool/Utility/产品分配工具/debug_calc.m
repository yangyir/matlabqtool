clear all; rehash;

%% 简单平层
rate = 0.2;
flatcal = FlatOnly(0.2);
flatcal.calc;
flatcal.plotReturn;

%% 平层+水线
line = 0.08;
flatwatercal = FlatWaterLine(line, rate);
flatwatercal.calc;
flatwatercal.plotReturn;

%% 平层+分段
seg1 = 0.1;
segrate1 = 0.2;
seg2 = 0.3;
segrate2 = 0.8;
flagsegcal = FlatSegment;
flagsegcal.check_and_fill_threshold(0.1, 0.3, 0.2);
flagsegcal.check_and_fill_threshold(0.3, 1, 0.8);
flagsegcal.calc;
flagsegcal.plotReturn;

%% 简单安全垫
cushioncal = CushionBase(0.2, 0.5);
cushioncal.calc;
cushioncal.plotReturn;
cushioncal.plotYield;

%% 安全垫+水线
cushionwaterline = CushionWaterLine(0.2, 0.2, 0.5);
cushionwaterline.set_x_axes_range(-0.5, 0.5);
cushionwaterline.calc;
cushionwaterline.plotReturn;
cushionwaterline.plotYield;

%% 安全垫+多分段
cushionseg = CushionSegment(0.2);
cushionseg.check_and_fill_threshold(0, 0.1, 0.2);
cushionseg.check_and_fill_threshold(0.1, 0.3, 0.5);
cushionseg.check_and_fill_threshold(0.3, 0.5, 0.8);
cushionseg.calc;
cushionseg.plotYield;
cushionseg.plotReturn;
