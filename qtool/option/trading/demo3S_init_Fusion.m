%% Example Title
% Summary of example objective
% �˳��������������

clear all; rehash;
delete(timerfindall);
pause(2);

%% ��ʼ����counter�� book
% counter, ���ʼ������ 
% c_opt = CounterXSpeed.GuangDaOpt;
% c_etf = CounterXSpeed.GuangDaETF;
c_opt = CounterCTP.huaxi_opt;
c_etf = CounterCTP.huaxi_etf;

c_opt.login;
c_etf.login;

%% ��ʼ����quote, volsurf�� �ֹ�


%% ��ʼ����quote, volsurf�� ��qms

% ����qms

% cloud_doc_dir = 'C:\������';
cloud_doc_dir = 'C:\Users\Rick Zhu\Documents\Synology Cloud\������';
% cloud_doc_dir = 'D:';
fn = '\qtool\option\optionClass\OptInfo.xlsx';
file_path = [cloud_doc_dir, fn];

fut_fn = [cloud_doc_dir, '\qtool\option\optionClass\FutureInfo.xlsx'];
stk_fn = [cloud_doc_dir, '\qtool\option\optionClass\StockInfo.xlsx'];

qms_ = QMS_Fusion;
% qms_.loginXSpeed();
qms_.loginCTP();
qms_.init(file_path, fut_fn, stk_fn);

% 
% qms_.init_test(opt_fn, fut_fn, stk_fn);
% qms_.run_h5_test();
% pause(30);

vs = qms_.impvol_surface_;

%% ��ȡ���յ�book
b1 = Book;
b1.xlsfn = [cloud_doc_dir,'\������\qtool\option\trading\book_fusion_test_xspeed.xlsx'];
% b1 = Book;
% % bookfn = 'F:\FANTUANXIAOT\5.���Ʒ�\optionStraddleTrading\book_straddle.xlsx';
% b1.xlsfn = [cloud_doc_dir,'\intern\5.���Ʒ�\optionStraddleTrading\book_straddle_2034.xlsx'];
% % b1.xlsfn = [cloud_doc_dir,'C:\Users\Rick Zhu\Documents\Synology Cloud\intern\7.�콭\test_code\book_straddle_2034_bkup.xlsx'];
% b1.fromExcel();
% [pa] = b1.read_position_xspeed_counter(c_opt);
% b1.positions = pa;
b1.load_book_from_counter(c_opt);
QMS_Fusion.set_quoteopt_ptr_in_position_array(b1.positions, qms_.optquotes_);
b1.positions.print;
% ��Position����������
b1.update_position_structure;

%% �������ռ�����
bm = BookMonitor(b1);
% ���÷���Ԥ����ֵ
bm.dollarDelta = 20000;
bm.dollarVega = 10000;
rm = RiskMonitor;
rm.attachMonitor(bm);

%% ���ص�QMS���Զ�����
qms_.check_risk_handler = @rm.check;

%% book3 �����²�����

% b3 = Book;
% bookfn2 = 'D:\intern\5.���Ʒ�\optionStraddleTrading\book_straddle_2016_3�½���.xlsx';
% b3.fromExcel(bookfn2);
% b3.positions.print;
% QMS.set_quoteopt_ptr_in_position_array(b3.positions, q)
% 
% b3.virtual_settlement;
%% --------------------------------------------------------------------- 

        
        