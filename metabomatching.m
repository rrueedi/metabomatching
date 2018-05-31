clear all;
funcdir=getenv('DR_METABOMATCHING');
if ~isempty(funcdir)
    addpath(fullfile(funcdir,'func'));
else
    addpath('func');
end
dirs = dir;
dirs_source = {dirs(:).name};
dirs_source = dirs_source(strncmp(dirs_source,'ps.',3));
for i = 1:length(dirs_source)
    clear ps;
    dir_source = dirs_source{i};
    fprintf('+---------------------------------------\n')
    fprintf('|   %s\n+--\n',dir_source);
    ps=function_load_parameters(dir_source);
    fprintf('--- loading data ------------------');
    ps=build_spectrum_database(ps);
    ps=function_import_correlation(ps);
    ps=function_import_pseudospectra(ps);
    fprintf(' done\n--- building transition matrix ----');
    ps=function_build_mim(ps);    
    fprintf(' done\n--- metabomatching ----------------');
    ps=function_metabomatching_core(ps);
    fprintf(' done\n--- permutation -------------------');
    ps=fun_pshuffle(ps);
    ps=fun_pshuffle_score(ps);
    %csvwrite([dir_source,'op.csv'],ps.op)
    fprintf(' done\n--- writing scores ----------------');
    function_write_scores(ps);
    save(fullfile(dir_source,'ps.mat'),'ps');
    fprintf(' done\n--- writing svg -------------------');
    vis_metabomatching(dir_source);
    fprintf(' done\n----------------------------------- ---+');
    fprintf('\n\n');
end