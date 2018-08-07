function []=fpar(dir_source)
addpath('func');
ini__;
hp = @(str) fprintf('%s --- %s\n',dir_source,str);
hp('start');
ps = fun_load_parameters(dir_source);
hp('load data');
ps = fun_build_spectrum_database(ps);
ps = fun_import_correlation(ps);
ps = fun_import_pseudospectra(ps);
ps = fun_processps(ps);
hp('build transition matrix');
ps = fun_build_mim(ps);    
hp('metabomatching');
ps = fun_metabomatching_core(ps);
if ps.param.n_permutation>0
     hp('permutation');
     ps = fun_pshuffle(ps);
end
hp('write scores');
fun_write_scores(ps);
save(fullfile(dir_source,'ps.mat'),'ps');
if strcmp(dir_source(end-2:end),'sig')
   hp('plot svg');
   vis_metabomatching(dir_source);	
end
hp('done');
