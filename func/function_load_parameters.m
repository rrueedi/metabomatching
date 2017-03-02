function ps = function_load_parameters(dir_source)
% FUNCTION_LOAD_PARAMETERS Read parameter file
ps.param.dir_source = dir_source;
fn = fullfile(ps.param.dir_source,'parameters.in.tsv');
number_fields = {...
    'n_show',...
    'dsh',...
    'decorr_lambda',...
    'snp',...
    'p_significant',...
    'p_suggestive'};
defaults = { ...
    'variant','1c';...
    'mode','peak';...
    'scoring','chisq';...
    'reference','hmdb';...
    'decorr_lambda',1;...
    'n_show',8;...
    'p_significant',5e-8};
if exist(fn,'file');
    pr = fun_read(fn,'%s%s');
    for j = 1:length(pr{1})
        if ismember(pr{1}{j},number_fields)
            ps.param.(pr{1}{j})=str2double(pr{2}{j});
        else
            ps.param.(pr{1}{j})=pr{2}{j};
        end
    end
else
    fprintf('|   no parameter file, using defaults\n---\n');
end
%
%
% ##### ASSIGN DEFAULTS #####
for i = 1:size(defaults,1)
    if ~isfield(ps.param,defaults{i,1})
        ps.param.(defaults{i,1}) = defaults{i,2};
    end
end
if ~isfield(ps.param,'dsh')
    if strcmp(ps.param.mode,'peak');
        ps.param.dsh=0.025;
    else
        ps.param.dsh=0.010;
    end
end
if ismember(ps.param.variant,{'pm','pm1c','pm2c'}) && ...
        ~isfield(ps.param,'p_suggestive')
    ps.param.p_suggestive=1e-4;
end