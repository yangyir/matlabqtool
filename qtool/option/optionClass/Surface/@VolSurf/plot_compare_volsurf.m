function [ hFig ] = plot_compare_volsurf(obj, t, type, varargin)
% ���ڱȽϵ�VolSurf�Ա���ͼ
%Import
% t �Ƚ�����ʱ��� 1 2 3 4
% type �Ƚ����� pre mean own
% varargin �����������

assert(ismember(t, 1:length(obj.smiles_)));
assert(ismember(type, {'pre', 'mean', 'own'}))

% ʹ����ֵ
if strcmp(type, 'pre')
    hFig = figure;
    ax = axes;
    % ��ȡ��ֵsurf
    pre_surf = varargin{1};
    
    % ��ǰ��Surface
    x_max_ = max(obj.smiles_(t).x_value_);
    x_min_ = min(obj.smiles_(t).x_value_);
    x_ = x_min_:(x_max_ - x_min_)/60:x_max_;
    x_(abs(x_) < 1e-6) = [];
    idx = find(x_ >= 0);
    if isempty(idx)
        x_ = [0, x_];
    else
        less_ = x_(1:idx - 1);
        more_ = x_(idx:end);
        x_ = [less_, 0, more_];
    end
    zero_idx_ = x_ == 0;
    vol_surf_ = obj.smiles_(t).calculate(x_);
    vol_surf_ = vol_surf_ - vol_surf_(zero_idx_);
    
    plot(x_, vol_surf_, 'b*-')
    
    % ����Surf
    x_max_ = max(pre_surf.smiles_(t).x_value_);
    x_min_ = min(pre_surf.smiles_(t).x_value_);
    x_ = x_min_:(x_max_ - x_min_)/60:x_max_;
    x_(abs(x_) < 1e-6) = [];
    idx = find(x_ >= 0);
    if isempty(idx)
        x_ = [0, x_];
    else
        less_ = x_(1:idx - 1);
        more_ = x_(idx:end);
        x_ = [less_, 0, more_];
    end
    zero_idx_ = x_ == 0;
    vol_surf_ = pre_surf.smiles_(t).calculate(x_);
    vol_surf_ = vol_surf_ - vol_surf_(zero_idx_);
    
    hold on 
    plot(x_, vol_surf_, 'r*-')
   
    legend({sprintf('%dT', t); 'pre'}, 'Location', 'best')
    xlabel('M-shift', 'FontWeight', 'bold')
    ylabel('iv', 'FontWeight', 'bold')
    title(ax, [obj.des, ' VolSurf Compare'], 'FontWeight', 'bold')
    
    % ���ߵ���ͼ
    ylim_ = get(ax, 'YLim');
    zero_line_ = min(ylim_):(max(ylim_) - min(ylim_))/50:max(ylim_);
    plot(zeros(1, length(zero_line_)), zero_line_, '--')
    set(ax, 'FontWeight', 'bold')
    grid on;
    hold off
elseif strcmp(type, 'mean')
    
    
else
    
end




end