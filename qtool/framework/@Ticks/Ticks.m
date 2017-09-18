classdef Ticks < handle
% TICKS �����ࡣ���tick���ݡ�
% last T*1��bid��ask��ȡ������T*5

% 20131220����Ⱥ������
% 20131223���̸գ�����qtool\framework\
%     ��ȶ�����յ������Ƿ�Ӧ������
% 20140503, chenggang, ����plotind
% 20140606, chenggang, ����properties�� code2��date��date2
% 20140618, chenggang, ��һЩproperties����hidden = true
% 20140715���̸գ�����toExcel����
% 20140726���̸գ�����[ newobj ] = getByIndex(obj, idx);
%                ����copy constructor�� [ newobj ] = getCopy(obj);
% 140801;�̸գ�����[obj] = prune(obj); �����䳬д�ģ�
% 140821;�̸գ�����expDate��
% 140827;���䳬; ������fillProfile������
% 160826; �̸գ� ��ȡͨ��L2�ɾ�����   readCSV_cleanL2_Tonglian(obj,  filename );
% 160826; �̸գ������� tranCnt �� �ۼƽ��ױ��� 
% 160827; �̸գ� ��askV��bidV��ΪaskQ��bidQ��������Ů����Ϊ
%                 ԭaskV��bidV������������Ϊ���ɼ�
% 160828; �̸գ� �����������ҵ� ���㺯���Ͳ��ź��� play_absolute_levels( b, s_itk, e_itk  )
%      [ paxis, defense, mark ] = generate_absolute_leves(obj);
%     function [ ] = play_absolute_levels( b, s_itk, e_itk  )
% 160903; �̸գ� ����������ϴ��һЩ�������������� cleasing_XXXXXXXX()
%             [] = cleasing_emptyLast(obj);
%             [] = cleasing_emptyPQ(obj);
%             function [] = cleasing(obj)
% 160905���̸գ�������askA��bidA��Ϊ�˷���
% 170712, �̸գ�������midP��abs�����Ǽ���ֵ; ���� function [] = calc_midp_abs(obj)



%% **************  �����򣬿ɼ� ********************************
properties(SetAccess = 'public', GetAccess = 'public', Hidden = false)
    %% ����
    code;       % ��׼����
    code2@char;      % �ı����
    type@char;       %TODO: restricted to 'future', 'stock', 'etf', 'option'
    levels;     %���鵵����1��5��10��etc.
    latest;      %���µ�Tick��ţ���ʵʱ���ݸ���ʱʹ��
    expDate@double;    % �����գ���735766������future��option������

     
    
    %% �������� D*1 ����
    % ���յ�����    
    date@double;   % ����
    date2@char;  % �ı�    
    preSettlement; % ǰ�ս���ۣ�����гֲֹ�ҹ���������������������㶢��ӯ��
    settlement;  % ���ս���ۣ�����future������
    
    %% ʱ�����У��� T*1 vectors
    % ����Сʱ�䵥λ������
    time@double; % as double, such as 735496.961201
    time2; %as int32 explicit, such as 230407
    last;
    volume;   %�ۻ���, �ɡ���
    amount;   %�ۻ�����Ԫ
    openInt;  %�ۻ���    
    tranCnt;  %�ۻ��ɽ�����    
    
    %% ʱ�����У��� T*levels vectors
    bidP; %���
    bidQ; %����
    bidA; %��amount��Ԫ

    askP; %����
    askQ; %����    
    askA; %���amount��Ԫ
    
    
    %% ������
    midP;   % ( askP1 + bidP1 ) / 2  
    abs;    %  ask-bid spread
    
    

end

%% **************  ��������򣬲��ɸ��� ******************************
properties (SetAccess = 'private', GetAccess = 'public', Hidden = false)

    % ��������ã�����
    headers;  % data�ı�ͷ
    data;   % ʱ������
    data2;  % ������Ϣ

        
end


%% ********** ������������ʱ��ɾ���������� ***************
 properties (SetAccess = 'public', GetAccess = 'public', Hidden = true)
     % �������� D*1 ����
     open;
     high;
     low;
     close;
     dayVolume;
     dayAmount;
     %settlement; %���ս���ۣ���δ�����ݣ����ã�
     
     % �Ѹ���ΪaskQ��bidQ
     bidV; %����
     askV; %����
     
 end
 
  %% Constructor, �ǳ��������д�����
 methods(Access = 'public', Static = false, Hidden = false)
     function [obj] = Ticks(obj)
         obj.latest = 0;
         
     end
     
     % ��Ϊ��handle�࣬��Ҫcopy constructor������ָ�븳ֵ
     [ newobj ] = getCopy(obj);

 end
 %% ����
 methods(Access = 'public', Static = false, Hidden = false)
     %�����
     [obj] = merge(obj,ts2);
     
     % ��װ�ɱ��Bars
     [bs]  = toBars(obj, slice_seconds, slice_start);
          
     % ��Index����ȡһЩ����, �÷������� b = a(a>0)
     [ newobj ] = getByIndex(obj, idx);
     
     % ��profileָ�루Ҳ��Ticks�ࣩ��עĳһ����棬Ĭ��ΪtkIndex = obj.latest
     % ע�⣺�˺�����getByIndex��ͬ����������obj��ֻ�����е���ע��
     [ ] = fillProfile( obj, profileTicks, tkIndex );
     
     % ��ȥobj.latest֮��Ĳ��֣�����
     [obj] = prune(obj);
     
     % ��5����10�����ݷ������������ϵ��
     [ paxis, defense, mark ] = generate_absolute_leves(obj);
     
     
     %% ��ͼ������     
          
     % ����չʾ��˫�ᣬ����y1����last
     [ ] = playYY( obj, y2, xwin, y1win, step, pausesec, t_start, t_end);

     % ����չʾ����������Ĺҵ����
     [ ] = play_absolute_levels(obj, s_itk, e_itk);
     
     % ��ͼ���̿������Ĭ��ֻ��һ��tick
     [] = plotPankou(obj, cur, pre_win, post_win );
     
     % ��ͼ��ask - last - bidͼ�����䳣�ã��ֲ�
     [] = plotLocalALB( obj, stk, etk );
     
     % ��ͼ�� stk:etk�ֲ���Histogram����������Ͳ���ͼ������hist��
     [N, X, R, cumR] = localHist(obj, stk, etk, type, grids);
     
     % ��ͼ����last���ݣ�idx�����ϱ�ʶ
     [ output_args ] = plotind( obj, idx, drawtype);
    
 end
     
     
  %% �������
 methods(Access = 'public', Static = false, Hidden = false)
    % ������ݵķ���
    [data, headers, data2]  = toTable( obj, headers );
    [obj]                   = toExcel(obj, filename, sheetname1, sheetname2);

            
     % ������õ�CVS���ݡ���ͨ������
      [ obj ]     = readCSV_cleanL2_Tonglian(obj,  filename );
      
     % 
     [ obj ] = pushOneTick(obj, onetick)
      
 end
 
 
 %% ������ϴ�ķ���
 methods(Access = 'public', Static = false, Hidden = false)
     
     [] = cleasing_emptyLast(obj);
     [] = cleasing_emptyPQ(obj);
     
     function [] = cleasing(obj)         
        cleasing_emptyLast(obj);
        cleasing_emptyPQ(obj);
        
     end
         
     
     function [obj] = calc_midp_abs(obj)
         obj.midP = ( obj.askP(:,1) + obj.bidP(:,1) )  / 2;
         obj.abs  = obj.askP(:,1) - obj.bidP(:,1) ;
     end
     
 end
 
 
 %% ʵʱ�����õ��࣬ ǰ׺��rt_
  methods(Access = 'public', Static = false, Hidden = false)
     
     [ ] =  rt_NewTicks( obj, T , levels);
     
    
         
     
 end
    
 %% ********** static����  *****************
 methods(Static = true)
     
     %         [ts1] = merge(ts1,ts2);
     
 end
end



