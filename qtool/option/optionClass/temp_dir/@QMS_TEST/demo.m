function [] = demo()
% QMS demo 
delete(timerfindall);
mktlogout
clear all; rehash;

% cloud_doc_dir = 'C:\Users\Rick Zhu\Documents\Synology Cloud';
cloud_doc_dir = 'D:';
fn = '\intern\5.Œ‚‘∆∑Â\optionStraddleTrading\OptInfo.xlsx';
file_path = [cloud_doc_dir, fn];
qms_ = QMS_TEST;
qms_.init(file_path);

pause(30);

vs = qms_.impvol_surface_;
vs.plot();

% pause(100);

% qms_.release();

end