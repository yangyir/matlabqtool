%% main ����ʵ�������¼���

% ��������
%     s()����
%     ��������span��universe
%     �������
% 
% ��ʲô��
%     1���������ݾ���
%     2������s()ֵ
%     3�����к������Ի���ƽ��������һ����
%     4���õ�pos����trade����
%     5��չʾ�ز���
% 
% �������
%     �ز���
%     �ز�ָ��
%     �ز���ͼ
%
% ------------------------------
% �̸գ�140915
% �̸գ�140920������data1��data2��С����
% �̸գ�140923�������˶Բ��ɽ��׹�Ʊ�Ĵ���������������λ����
% �̸գ�141009������

%%
% clear;

tic
%% �������
% ʱ����
sDay = '2012-01-01';
eDay = '2013-12-31';

% ��Ʊuniverse��δ�ظ�һ��ָ�����ܸ㶨
universe = '000300.SH';
% stockArr = DH_E_S_IndexComps(universe,sDay,0);
% universe = '������ȯ���';
% stockArr = DH_E_S_SELLTARGET(1,sDay,1);


% ���Ի�
% neutralizeMethod = '';
neutralizeMethod = 'ȫ�г�';
% neutralizeMethod = '����һ��';
% neutralizeMethod = '�������';
% neutralizeMethod = '����һ��';
% neutralizeMethod = '���Ŷ���';
% neutralizeMethod = '֤���һ��';
% neutralizeMethod = '֤������';



% ָ��ƽ����alpha�����Ϊ�������൱�ڲ���ָ��ƽ������
expSmoothAlpha = 0.6;

% ָ��˥����days�����Ϊ�������൱�ڲ�˥��
expDecayDays  = 10;

% ��β�ٷֱȣ�[0,0.5]����ͷ�ضϣ�ȡ��ߺ���͵�truncatePct
truncatePct = 0.5;

% ��߲�λ����������ֹ������󣬻��λ���ڼ���,[0,1] 
maxPosition = 0.1;


% ����ʱ�䣬'���̻���'��'β�̻���'���ز�ʱʹ�ò�ͬ�۸�
tradeTime = '���̻���';  % t�վ��� -��t+1������  
% tradeTime = 'β�̻���';  % t�վ��� -��t��β�� ����ʱ��ʵ��û��close��

% �Ƿ�����ȡ���ݣ���δ�ı�span��universe��������ȡ��
% 0 - ������load��Ҳ������fetch ����ʡʱ�䣩
% 1 - ����load  ***.mat����ҹ�������棬�������ȴ���ü��׻�����
% 2 - ����dhfetch���иı��Ҫ��������������
fetchData1Flag = 0; % basicData
fetchData2Flag = 0; % customerData


%% ȡ��������
Main15_basicData;

%% ȡ�������ݡ����û���������
Main20_customerData;

%% ���㲿��
% ����sֵ, �����sֵ��Ӱ�����������

sMat  = nan(NUMday, NUMasset);

for col = 1:NUMasset   
    
    code = stockArr(col);
    
    
    %% �������ݼ���
    flds = fields(data1);
    for i = 1:length(flds)
        fld = flds{i};
        varname = fld(1:end-3);
        eval( [varname '=data1.(fld)(:,col);'] );
    end
    
    %% �������ݼ���
    
    if exist('data2','var')
        flds = fields(data2);
        for i = 1:length(flds)
            fld = flds{i};
            varname = fld(1:end-3);
            eval( [varname '=data2.(fld)(:,col);'] );
        end
    end

        
    %% ����д��ʽ�ĵط�
    % д�ɹ���Ҳ���ԣ�һ��Ҫ�ǵ���󷵻� s = ****;
    % д�ɺ���Ҳ���ԣ������鷳��Ҫ������   
    s_entry;     
    
    
       
    %% ����score
    sMat(:,col)  = s;
end



%% ���Ի� 
switch neutralizeMethod
    case {'����һ��'}
        industry = industry_sw1;
    case {'�������'}
        industry = industry_sw2;
    case {'����һ��'}
        industry = industry_zx1;
    case {'����һ��'}
        industry = industry_zx2;
    case {'֤���һ��'}
        industry = industry_zjh1;
    case {'֤������'}
        industry = industry_zjh2;
    case {'ȫ�г�'}
        industry = [];
        % ȫ�г����Ի���������������ֵ���Ի�
        sMat = sMat - nanmean(sMat,2)*ones(1,NUMasset);
    otherwise  % ���������Ի�
        industry = [];
end


% �������ҵ���Ի�������Ǻ��鷳�����飬��Ҫ�ǣ�������ҵ�Ƿ��б仯��
% foreach ��ҵ
%   ����ҵ��ֵ����ȥ��ҵ��ֵ
if ~isempty(industry)
for i = 1:NUMasset
    induCodes(i) = str2double( industry{i,1} );
end
[uniInduCodes, ia] = unique(induCodes);
uniInduCodes2 = industry(ia, 2);
for i = 1:length(uniInduCodes)
    % ��ҵ��Ϣ
    thisInduCode = induCodes(i);
    uniInduCodes2(i)
    
    % ��ȡ��ҵ�й�Ʊ��Ӧindex
    idx = find( induCodes == thisInduCode );
    
    
    % ��ҵ�����Ի����� ��ȥ��ҵ��ֵ
    indAvg = nanmean( sMat(:,idx), 2 );
    sMat(:,idx) = sMat(:,idx) -  indAvg * ones(1, length(idx));
    % ֮ǰnan�ĵط�����0
end
    
end

% ֮ǰnan�ĵط�����0
sMat( isnan(sMat) ) = 0;
 
%% ƽ����
% ��ָ��ƽ��
% for col = 1:NUMasset
%      s = sMat(:,col);
%      s1 = mv.expSmooth(s,expSmoothAlpha);
%      sMat(:,col) = s1;    
% end

% ָ��˥��ƽ������ָ��ƽ��������һ����˼
for col = 1:NUMasset
    s = sMat(:,col);
    s1 = mv.expDecay(s, expDecayDays);
    sMat(:,col) = s1;
end


%% �ض�
% ˫��ضϣ�ֻȡ��ߺ���͵�truncatePct
for row = 1:NUMday
    srow = sMat(row,:);
    yLow = prctile(srow, truncatePct*100);
    yHi  = prctile(srow, 100-truncatePct*100);
    srow( srow < yHi & srow > yLow) = 0;
    sMat(row,:) = srow;
end



 
%% ��һ��--long only
% % ���ﲻ�ԣ�Ӧ�������ڣ��������
% sMat    = sMat.* tradableMat ;
% 
% % ����
% ss      = sum(sMat, 2);
% pos_pct = sMat ./ ( ss*ones(1,NUMasset) );


%% ��һ������long short
[pos_pct, posL_pct, posS_pct]  = guiyihua(sMat);


%% ��߲�λ���ƣ���ʱֻ��warning
% [m, i] = max(pos_pct,[],2);
% if max(m) > maxPosition
%     fprintf('��λ���ޣ�%0.2f > %0.2f\n', max(m), maxPosition);
% end
% 
% 
% 
% %% У���������ɽ��׵Ĺ�Ʊ�����뽻��
% % ���ɽ��׵Ĺ�Ʊ�������䣬�ɽ��׵Ĺ�Ʊ�ط���ɽ��׵Ľ��
% 
% 
% % 
% % for dt = 3:NUMday
% %     
% %     
% %     
% % end
% 
% 
% 
% 
% %% �ز��� - �֣���Ҫ��������ֵ
% % ����ģʽ
% switch tradeTime
%     case '���̻���'
%         rMat = data1.retrn2Mat;
%     case 'β�̻���'
%         rMat = data1.retrnMat;
%     otherwise
%         rMat = data1.retrn2Mat;
% end
% 
% 
% 
% pnlraw_ret  = zeros(NUMday,1);  
% pnlnet_ret  = zeros(NUMday,1);
% ts_fee      = zeros(NUMday,1);  % ����������
% ts_turnover    = zeros(NUMday,1);
% ts_navRaw      = zeros(NUMday,1);  % ��ĩ��ֵ
% ts_navRaw(1)   = 1;
% for dt = 3:NUMday
%     dateArr(dt,:);
%     
%     d_pos_pct = pos_pct(dt-1,:) - pos_pct(dt-2,:);
%     fee   = sum(abs(d_pos_pct))/2 * 0.0015;
%     
%     pnlraw_ret(dt)  = rMat(dt,:) * pos_pct(dt-1,:)';
%     pnlnet_ret(dt)  = pnlraw_ret(dt) - fee;
%     ts_fee(dt)      = fee;
%     ts_turnover(dt)    = sum(abs(d_pos_pct))/2;
% end
% 
% pnlraw_ret( isnan(pnlraw_ret) ) = 0;

%% ��ͼ
pnlraw_ret_cmpd = cumprod( pnlraw_ret+1)-1;
pnlraw_ret_smpl = cumsum(pnlraw_ret);
pnlnet_ret_cmpd = cumprod( pnlnet_ret+1)-1;
pnlnet_ret_smpl = cumsum(pnlnet_ret);

hfig202 = figure(202); hold off;
plot(pnlraw_ret_cmpd, 'b');
hold on;
% plot(pnlraw_ret_smpl, 'b-');
plot(pnlnet_ret_cmpd, 'r');
% plot(pnlnet_ret_smpl, 'r-');
% legend('raw pnl: compound', 'raw pnl: simple', 'net pnl: compound', 'net pnl:simple');
legend('rawPNL','netPNL');
title('�ֹ����ۻ�PNL %');
grid on;



hfig210 = figure(210);hold off;
bar(ts_turnover);
title(sprintf('�ֹ����ջ����ʣ���ֵ%0.0f%%',mean(ts_turnover)*100));


%% �ز�������ϸ�����ɽ��׵Ĺ�ƱdeltaPos == 0
% pos_pct  = guiyihua(sMat, 'long short', data1.tradableMat);
pos_pct  = guiyihua(sMat);

% ͳһ�������̻��ּ���
% ����ģʽ
switch tradeTime
    case '���̻���'
        rMat = data1.retrn2Mat;
        price = data1.openMat;
    case 'β�̻���'
        rMat = data1.retrnMat;
    otherwise
        rMat = data1.retrn2Mat;
end


pnlraw_ret  = zeros(NUMday,1);  
pnlnet_ret  = zeros(NUMday,1);
ts_fee      = zeros(NUMday,1);  % ����������
ts_turnover = zeros(NUMday,1);
ts_pnl      = zeros(NUMday,1);
ts_navRaw   = zeros(NUMday,1);  % ��ĩ��ֵ
ts_navRaw(1:2)   = 1;
ts_navNet   = zeros(NUMday,1);  % ��ĩ��ֵ
ts_navNet(1:2)   = 1;


pos_Money   = zeros(NUMday, NUMasset); % �ʽ��λ
pos         = zeros(NUMday, NUMasset); % ������λ����ȷ)
dPos        = zeros(NUMday, NUMasset); % ���ף�������λ�仯
pos_lot     = zeros(NUMday, NUMasset); % ������λ���֣�
dPos_lot    = zeros(NUMday, NUMasset); % 

% һ��һ����
for dt = 3:NUMday-1
    % ��ʱվ��dt-1�����̺󣨻�dt-1������ǰ����Ҳ��dt�տ���ǰ
    % ����dt�ճֲ֣���dt���̼ۻ�dt-1���̼ۣ����ͻ���
    % �������
%     dateArr(dt,:);
    open        = data1.openMat(dt,:);
%     tradable    = data1.tradableMat(dt,:);
    tradable    = ones(1, NUMasset);
    
    % nav(dt) �ô��տ��̼ۼ��㣨�������̼ۼ��㣩
    % pos_pct(dt-1,:) ��dt�յĲ�λ�����ٷֱȲ�λ��dt-1�ռ����
    % pos_Money(dt,:), pos(dt,:) ��dt�յĲ�λ��dt�ղ������

    % ͣ�ƹ�Ʊ�����н��ף�pos���䣬�ط���
    navLongRe   = ts_navLongRaw(dt-1) - sum(pos(dt-1,:) .* (1-tradable) .* open);
    navRebalance = ts_navRaw(dt-1) - sum( pos(dt-1,:) .* (1-tradable) .* open );
    pos_Money(dt, tradable==1) = navRebalance * pos_pct(dt-1, tradable==1);
    pos_Money(dt, tradable==0) = pos(dt-1, tradable==0) .* open(tradable==0);
    
    pos(dt,:)       = pos_Money(dt,:) ./ open;
    dPos(dt,:)      = pos(dt,:) - pos(dt-1,:);

    % ���ֲ�Ӧ�ı�navRaw
    nav1 = sum(open.*pos(dt-1,:));
    nav2 = sum(open.*pos(dt,:));
    fprintf('����ǰnav��%0.2f�����ֺ�nav��%0.2f\n', nav1, nav2);
    
    
    % �ǵ�ͣ��Ʊ�����н��ף�pos���䣬posMoney��
    
    
    % ���߰����롢�����ֱ���fee
    ts_turnover(dt) = sum(abs(dPos(dt,:).* open))/2;
    ts_fee(dt)      = sum(abs(dPos(dt,:).* open))/2 * 0.0015;
    % pnl(dt) �ô��տ��̼ۼ��㣨�������̼ۼ��㣩
    ts_pnl(dt)      = sum(data1.openMat(dt+1,:) .* pos(dt,:)) - sum(open.*pos(dt,:));
    
    % nav
    ts_navRaw(dt)  = ts_navRaw(dt-1) + ts_pnl(dt);
    ts_navNet(dt)  = ts_navNet(dt-1) + ts_pnl(dt) - ts_fee(dt);
    
    % return
    d_pos_pct = pos_pct(dt-1,:) - pos_pct(dt-2,:);
    fee   = sum(abs(d_pos_pct))/2 * 0.0015;
    
    pnlraw_ret(dt)  = rMat(dt,:) * pos_pct(dt-1,:)';
    pnlnet_ret(dt)  = pnlraw_ret(dt) - fee;
%     ts_fee(dt)      = fee;
%     ts_turnover(dt)    = sum(abs(d_pos_pct))/2;
%     pnlraw_ret(dt)  = ts_navRaw(dt)/ts_navRaw(dt-1) - 1 ;
%     pnlnet_ret(dt)  = ts_navNet(dt)/ts_navNet(dt-1) - 1;
%     
    % ����ֹ�������ԭʼֵ�������룬�ø�Ȩ�ۼ��㣩����ĩ���㣬���ճ��ֲ�

    fprintf('%s, �ɽ���nav%0.1f%%\n',    dateArr(dt,:), navRebalance/ts_navRaw(dt-1)*100);

end


pnlraw_ret( isnan(pnlraw_ret) ) = 0;



figure(2); hold off
plot(ts_navRaw-1,'b');
hold on;
plot(ts_navNet-1, 'r');
legend('rawPNL','netPNL');
title('ϸ�����ۻ�PNL %');
grid on;   
%% ����ָ�꣺sharpe ratio�������ʣ��س�ˮƽ��


%% ��ͼ
pnlraw_ret_cmpd = cumprod( pnlraw_ret+1)-1;
pnlraw_ret_smpl = cumsum(pnlraw_ret);
pnlnet_ret_cmpd = cumprod( pnlnet_ret+1)-1;
pnlnet_ret_smpl = cumsum(pnlnet_ret);

hfig202 = figure(202); hold off;
plot(pnlraw_ret_cmpd, 'b');
hold on;
% plot(pnlraw_ret_smpl, 'b-');
plot(pnlnet_ret_cmpd, 'r');
% plot(pnlnet_ret_smpl, 'r-');
% legend('raw pnl: compound', 'raw pnl: simple', 'net pnl: compound', 'net pnl:simple');
legend('rawPNL','netPNL');
title('�ֹ����ۻ�PNL %');
grid on;



hfig210 = figure(210);hold off;
bar(ts_turnover);
title(sprintf('�ֹ����ջ����ʣ���ֵ%0.0f%%',mean(ts_turnover)*100));


%% �����word�ĵ�����������
% Main55_printWordl;


%% ģ���̽�� - ϸ�����Ǹ���ʵ������
% ���磬��������ͣ�򲻽�����ͣ�������������ھ޴�ʱ����
