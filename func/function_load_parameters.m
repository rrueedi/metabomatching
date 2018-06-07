function ps = function_load_parameters(dir_source,fn)
% FUNCTION_LOAD_PARAMETERS Read parameter file
ps.param.dir_source = dir_source;
if nargin<2
    fn = fullfile(ps.param.dir_source,'parameters.in.tsv');
end
number_fields = {...
    'n_show',...
    'dsh',...
    'decorr_lambda',...
    'snp',...
    'p_significant',...
    'p_suggestive',...
    'n_permutation'};
defaults = { ...
    'variant','1c';...
    'mode','peak';...
    'scoring','chisq';...
    'reference','hmdb';...
    'decorr_lambda',1;...
    'n_show',8;...
    'n_permutation',0;...
    'p_significant',5e-8};
special_defaults.dsh_peak = 0.025;
special_defaults.dsh_multiplet = 0.010;
special_defaults.p_suggestive = 1E-4;
% /
if exist(fn,'file');
    pr = fun_read(fn,'%s%s');
    for j = 1:length(pr{1})
        field = pr{1}{j};
        value = pr{2}{j};
        if ismember(field,number_fields)
            ps.param.(field)=str2double(value);
        else
            field=strrep(field,'.','_');
            ps.param.(field)=value;
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
        ps.param.dsh=special_defaults.dsh_peak;
    else
        ps.param.dsh=special_defaults.dsh_multiplet;
    end
end
if ismember(ps.param.variant,{'pm','pm1c','pm2c'}) && ...
        ~isfield(ps.param,'p_suggestive')
    ps.param.p_suggestive=special_defaults.p_suggestive;
end
ps.param.dir_source = dir_source;
