%% Example Title
% Summary of example objective
% �˳��������������

clear all; rehash;
delete(timerfindall);
mdlogout
pause(2);

%% ��ʼ����counter�� book
% counter, ���ʼ������ 
c_opt  = CounterCTP.huaxi_opt3;
c_opt2 = CounterCTP.huaxi_opt4;
% c_etf = CounterCTP.HuaXiETFTest;
c_opt.login;
c_opt2.login;

%% ��ʼ����quote, volsurf�� �ֹ�


%% ��ʼ����quote, volsurf�� ��qms

% ����qms

% cloud_doc_dir = 'D:';
cloud_doc_dir = 'F:\COMMUNICATION\qtool\option\optionClass\';
% cloud_doc_dir = 'D:';
fn = 'OptInfo.xlsx';
file_path = [cloud_doc_dir, fn];
fut_fn = [cloud_doc_dir, 'FutureInfo.xlsx'];
stk_fn = [cloud_doc_dir, 'StockInfo.xlsx'];

qms_ = QMS_CTP;
qms_.init(file_path, fut_fn, stk_fn);

% 
% qms_.init_test(opt_fn, fut_fn, stk_fn);
% qms_.run_h5_test();

% pause(30);

vs = qms_.impvol_surface_;

%% ��ȡ���յ�book
% b1 = BookCTP;
% b1.xlsfn = [cloud_doc_dir,'\intern\7.�콭\test_book.xlsx'];

%% 1
b1 = Book;
% bookfn = 'F:\FANTUANXIAOT\5.���Ʒ�\optionStraddleTrading\book_straddle.xlsx';
b1.xlsfn = 'F:\COMMUNICATION\qtool\option\trading\book_straddle_ctp.xlsx';
% % b1.xlsfn = [cloud_doc_dir,'C:\Users\Rick Zhu\Documents\Synology Cloud\intern\7.�콭\test_code\book_straddle_2034_bkup.xlsx'];
b1.fromExcel();
b1.positions.print;

%% 2
b2 = Book;
% bookfn = 'F:\FANTUANXIAOT\5.���Ʒ�\optionStraddleTrading\book_straddle.xlsx';
b2.xlsfn = 'F:\COMMUNICATION\qtool\option\trading\book_straddle_ctp2.xlsx';
% % b1.xlsfn = [cloud_doc_dir,'C:\Users\Rick Zhu\Documents\Synology Cloud\intern\7.�콭\test_code\book_straddle_2034_bkup.xlsx'];
b2.fromExcel();
b2.positions.print;


QMS_Fusion.set_quoteopt_ptr_in_position_array(b1.positions, qms_.optquotes_);
QMS_Fusion.set_quoteopt_ptr_in_position_array(b2.positions, qms_.optquotes_);

%% book3 �����²�����

% b3 = Book;
% bookfn2 = 'D:\intern\5.���Ʒ�\optionStraddleTrading\book_straddle_2016_3�½���.xlsx';
% b3.fromExcel(bookfn2);
% b3.positions.print;
% QMS.set_quoteopt_ptr_in_position_array(b3.positions, q)
% 
% b3.virtual_settlement;
%% --------------------------------------------------------------------- 

        
        