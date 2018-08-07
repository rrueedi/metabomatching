clear all;
addpath('func');
dirs = dir;
dirs_source = {dirs(:).name};
dirs_source = dirs_source(strncmp(dirs_source,'ps.',3));
p = gcp('nocreate');
if isempty(p)
    parpool(min(12,length(dirs_source)));
end
parfor i = 1:length(dirs_source)
    dir_source = dirs_source{i};
    mparf(dir_source);
end
