function  [sig_long, sig_short ] = Psy(bar, nDay, mDay,type)
% Psy ������
% ���㹫ʽ
% PSY=N������������/N*100
% PSYMA=PSY��M�ռ��ƶ�ƽ��
% ����N����Ϊ12�գ�����M����Ϊ6��
%
% PSYָ���ȡֵ���
% 1��PSYָ���ȡֵʼ���Ǵ���0����100֮�䣬0ֵ��PSYָ������޼�ֵ��100��PSYָ������޼�ֵ��50ֵΪ���˫���ķֽ��ߡ�
% 2��PSYֵ����50ΪPSYָ��Ķ෽����˵��N�������ǵ����������µ����������෽ռ������λ��Ͷ���߿ɳֹɴ��ǡ�
% 3��PSYֵС��50ΪPSYָ��Ŀշ�����˵��N�������ǵ�����С���µ����������շ�ռ������λ��Ͷ�����˳ֱҹ�����
% 4��PSY��50�����ǻ�����ӳ���ڹ�Ʊָ����ɼ����ǵ��������µ�������������ȣ��������ά��ƽ�⣬Ͷ�����Թ���Ϊ����
%
% Psy <25 ������ psy >75 ����
% Ӧ�÷���
% 1.һ���µ�������������չ��ǰ������(����)����ߣ��ͣ���ͨ����������Ρ��ڳ��ֵڶ��γ���(����)����ߣ��ͣ���ʱ��һ���������������ʱ��������PSYָ��������ָߵ��ܼ����ֵ����ԣ��ɸ�Ͷ���ߴ�����ԣʱ�������������롣
% 2.PSYָ����25��75֮��Ϊ��̬�ֲ���PSYָ����Ҫ��ӳ�г������ĳ���������ˣ���������ָ���ڳ�̬�����������ƶ�ʱ��һ��Ӧ�ֹ���̬�ȡ�
% 3.PSYָ�곬��75�����25ʱ�������ɼۿ�ʼ���볬����������,��ʱ��Ҫ�����䶯�򡣵�PSYָ��ٷֱ�ֵ����83�����17ʱ�������г����ֳ�����������,��λ�ص�������Ļ������ӣ�Ͷ����Ӧ��׼����������������������Ƿ���ֵڶ����źš���������ڸ����бȽ϶����
% 4.��PSYָ��ٷֱ�ֵ<10���Ǽ��ȳ������������Ļ��������ߣ���ʱΪ���ڽϼѵ����ʱ������֮�����PSYָ��ٷֱ�ֵ>90���Ǽ��ȳ��򡣴�ʱΪ��������������ʱ����
% 5.��PSY���ߺ�PSYMA����ͬʱ��������ʱ��Ϊ����ʱ�����෴����PSY������PSYMA����ͬʱ��������ʱ��Ϊ����ʱ��������PSY��������ͻ��PSYMA����ʱ��Ϊ����ʱ�����෴����PSY�������µ���PSYMA���ߺ�Ϊ����ʱ����
% 6.��PSY��������ͻ��PSYMA���ߺ󣬿�ʼ���»ص���PSYMA���ߣ�ֻҪPSY����δ�ܵ���PSYMA���ߣ��������ɼ�����ǿ��������һ��PSY�����ٶȷ�������ʱ��Ϊ����ʱ������PSY���ߺ�PSYMA����ͬʱ��������һ��ʱ���PSY����Զ��PSYMA����ʱ��һ��PSY���ߵ�ͷ���£�˵���ɼ����ǵĶ������Ľϴ�Ϊ����ʱ����
% 7.��PSY���ߺ�PSYMA�����ٶ�ͬʱ��������ʱ��Ͷ����Ӧ�ֹɴ��ǣ���PSY������PSYMA�����·�����ʱ��Ͷ����Ӧ�ֱҹ�����
% 8.��PSY���ߺ�PSYMA����ʼ�ս�֯��һ����һ���������Ȳ���Ŀռ����˶�ʱ��Ԥʾ�Źɼ۴��������ĸ���У�Ͷ����Ӧ�Թ���Ϊ����

%% Ԥ����
closePrice = bar.close;

if ~exist('nDay', 'var') || isempty(nDay), nDay = 12; end
if ~exist('mDay', 'var') || isemtpy(mDay), mDay = 6; end
if ~exist('type', 'var') || isempty(type), type = 1; end

%% ���㲽
[sig_long, sig_short] = tai.Psy(closePrice, nDay, mDay, type);

%% �ź�
if nargout == 0
    psy.psy = ind.psy(closePrice, nDay);
    bar.plotind2(sig_long+sig_short, psy, true);
    title('psy long and short');
end
end %EOF



    