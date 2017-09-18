%% Example Title
% Summary of example objective
% 退出行情服务器连接
mktlogout

clear all; rehash;
delete(timerfindall);
pause(2);

%% 初始化：counter， book
% counter, 多初始化几个 
% c34 = CounterHSO32.hequn2038_2034_opt;
% c34.login;
% c34.printInfo;

c2 = CounterHSO32.hequn2038_2016_opt;
c2.login;
c2.printInfo;


% c2601 = CounterHSO32.hequn2038_2601_opt;
% c2601.login;
% c2601.printInfo;

%% 初始化：quote, volsurf： 手工
% % 生成所有的quoteOpt，并用M2TK挂上
% fn = 'D:\intern\optionClass\@OptInfo\OptInfo.xlsx';
% fn = 'D:\intern\5.吴云峰\optionStraddleTrading\OptInfo_323.xlsx';
% [q, m2c, m2p] =  QuoteOpt.init_from_sse_excel( fn );
% stra.quote          = q;
% stra.m2tkCallQuote  = m2c;
% stra.m2tkPutQuote   = m2p;
% 
% QMS.set_quoteopt_ptr_in_position_array(b3.positions, q)
% 
% 
% 
% % 启动H5行情
% % 打开H5行情，必须在counter连接初始化后
% cd('D:\intern\5.吴云峰\optionStraddleTrading\')
% pause(3)
% mktlogin
% pause(3)
% while 1
%     [p, mat] = getCurrentPrice('510050', '1');
%     [mktopt,~] = getCurrentPrice('10000346', '3');
%     % getCurrentPrice('510050', '1');
%     % getCurrentPrice('10000346', '3');
%     if p(1) > 0
%         break;
%     else
%         disp('行情有问题');
%         pause(1)
%     end
% end
% 
% 
% % 建立volsurface
% vs = VolSurface;
% vs.init_from_sse_excel
% % 更新当前的日期
% vs.currentDate = today;
% % 更新当前的行情
% % w = windmatlab;
% % vs.update_VolSurface( 'w'  ,w );
% pause(3);
% vs.update_VolSurface( 'h' );
% vs.plot
% stra.volsurf  = vs;


%% 初始化：quote, volsurf： 用qms

% 启动qms


% cloud_doc_dir = 'C:\Users\Rick Zhu\Documents\Synology Cloud';
cloud_doc_dir = 'D:';
fn = '\intern\5.吴云峰\optionStraddleTrading\OptInfo.xlsx';
opt_fn = [cloud_doc_dir, fn];

fut_fn = [cloud_doc_dir, '\intern\5.吴云峰\optionStraddleTrading\FutureInfo.xlsx'];
stk_fn = [cloud_doc_dir, '\intern\5.吴云峰\optionStraddleTrading\StockInfo.xlsx'];

qms_ = QMS;
qms_.init(opt_fn, fut_fn, stk_fn);


% 
% qms_.init_test(opt_fn, fut_fn, stk_fn);
% qms_.run_h5_test();


% pause(30);

vs = qms_.impvol_surface_;

%% 读取昨日的book
% b1 = Book;
% % bookfn = 'F:\FANTUANXIAOT\5.吴云峰\optionStraddleTrading\book_straddle.xlsx';
% b1.xlsfn = [cloud_doc_dir,'\intern\5.吴云峰\optionStraddleTrading\book_straddle_2034.xlsx'];
% % b1.xlsfn = [cloud_doc_dir,'C:\Users\Rick Zhu\Documents\Synology Cloud\intern\7.朱江\test_code\book_straddle_2034_bkup.xlsx'];
% b1.fromExcel();
% b1.positions.print;
% QMS.set_quoteopt_ptr_in_position_array(b1.positions, qms_.optquotes_);
% 



b2 = Book;
% 从自己的excel里读取
b2.xlsfn = 'D:\intern\5.吴云峰\optionStraddleTrading\book_straddle_2016.xlsx';
b2.fromExcel();
b2.positions.print;


% % 从恒生O32输出文件里读取
% b2 = Book;
% fn = 'C:\Users\Trader6\Desktop\综合信息查询_组合证券.xls';
% b2.readExcel_HSO32_outfile(fn);
% b2.positions.print;

% 在book里挂行情
QMS.set_quoteopt_ptr_in_position_array(b2.positions, qms_.optquotes_);


% b3 = Book;
% b3.xlsfn = 'D:\intern\5.吴云峰\optionStraddleTrading\book_straddle_2601.xlsx';
% b3.fromExcel();
% b3.positions.print;
% % 在book里挂行情
% QMS.set_quoteopt_ptr_in_position_array(b3.positions, qms_.optquotes_);

% b_kq2016 = Book;
% % b_kq2016.xlsfn = 'I:\5.吴云峰\optionStraddleTrading\book_kuaqi_2016.xlsx';
% 
% b_kq2016.xlsfn = 'D:\intern\5.吴云峰\optionStraddleTrading\book_kuaqi_2016.xlsx';
% b_kq2016.fromExcel();
% b_kq2016.positions.print;
% % 在book里挂行情
% QMS.set_quoteopt_ptr_in_position_array(b_kq2016.positions, qms_.optquotes_);

%% 初始化：CounterS BookS QuoteS 基于Delta对冲
%{
% 初始化标的资产的BookS
bs = Book;
bs.xlsfn = 'F:\COMMUNICATION\qtool\option\trading\book_straddle_etf.xlsx';
bs.fromExcel();
bs.positions.print;

% 初始化CounterS
% 初始化quoteS
quoteS = qms_.stkmap_.mp('510050');
%}

%% qita
% QMS.set_quoteopt_ptr_in_position_array(b2.positions, q)
% b2.virtual_settlement;
% b2.toExcel(bookfn2)
% pa = b2.positions;
% pa.removeByIndex(1)
% pa.print
% b2.calc_m2m_pnl_etc; pa

%% book3 供线下测试用

% b3 = Book;
% bookfn2 = 'D:\intern\5.吴云峰\optionStraddleTrading\book_straddle_2016_3月交割.xlsx';
% b3.fromExcel(bookfn2);
% b3.positions.print;
% QMS.set_quoteopt_ptr_in_position_array(b3.positions, q)
% 
% b3.virtual_settlement;
%% --------------------------------------------------------------------- 
%% 生成OptionOne， 供策略挂
% TODO：成为qms_的一部分？ 未必？因为有仓位和entrust
% 
% m2c = qms_.callQuotes_;
% m2p = qms_.putQuotes_;
% L = length(m2c.xProps);
% 
% m2cOne = m2c.getCopy;
% % m2cOne.data = nan( size(m2c.data) );
% m2cOne.data = OptionOne;
% 
% m2pOne = m2p.getCopy;
% m2pOne.data = OptionOne;
% 
% % oo = nan;
% for iT = 1:4
%     for iK = 1:L
%         cq = m2c.data(iT, iK); 
%         cOne = OptionOne;
%         cOne.quote = cq;
%         m2cOne.data(iT, iK) = cOne;
%         eval( ['oo.optone' cq.code ' = cOne;'] );
%         
%          pq = m2c.data(iT, iK);
%          pOne = OptionOne;
%          pOne.quote = pq;
%          m2pOne.data(iT, iK) = pOne;
%          eval( ['oo.optone' pq.code ' = pOne;'] );
% 
%     end
% end

        
        