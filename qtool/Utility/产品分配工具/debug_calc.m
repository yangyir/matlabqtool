clear all; rehash;

%% ��ƽ��
rate = 0.2;
flatcal = FlatOnly(0.2);
flatcal.calc;
flatcal.plotReturn;

%% ƽ��+ˮ��
line = 0.08;
flatwatercal = FlatWaterLine(line, rate);
flatwatercal.calc;
flatwatercal.plotReturn;

%% ƽ��+�ֶ�
seg1 = 0.1;
segrate1 = 0.2;
seg2 = 0.3;
segrate2 = 0.8;
flagsegcal = FlatSegment;
flagsegcal.check_and_fill_threshold(0.1, 0.3, 0.2);
flagsegcal.check_and_fill_threshold(0.3, 1, 0.8);
flagsegcal.calc;
flagsegcal.plotReturn;

%% �򵥰�ȫ��
cushioncal = CushionBase(0.2, 0.5);
cushioncal.calc;
cushioncal.plotReturn;
cushioncal.plotYield;

%% ��ȫ��+ˮ��
cushionwaterline = CushionWaterLine(0.2, 0.2, 0.5);
cushionwaterline.set_x_axes_range(-0.5, 0.5);
cushionwaterline.calc;
cushionwaterline.plotReturn;
cushionwaterline.plotYield;

%% ��ȫ��+��ֶ�
cushionseg = CushionSegment(0.2);
cushionseg.check_and_fill_threshold(0, 0.1, 0.2);
cushionseg.check_and_fill_threshold(0.1, 0.3, 0.5);
cushionseg.check_and_fill_threshold(0.3, 0.5, 0.8);
cushionseg.calc;
cushionseg.plotYield;
cushionseg.plotReturn;
