clear all; rehash;
x = 1.95:0.05:2.35;

y1 = [100, 0, 1000, 1311, 525, 600, 0, 0, 0];
y2 = [0, 0, 0, 0, 123, 233, 1000, 1300, 2000];

bpcombined = [y1(:), y2(:)];

figure
hb = bar(x, bpcombined, 'grouped');
set(hb(1), 'FaceColor', 'r')
set(hb(2), 'FaceColor', 'b')


% [hAx, h1, h2] = plotyy(x, y1, x + 0.01, y2, 'bar');
% set(h1,  'FaceColor', 'r')
% set(h2,  'FaceColor', 'b')