function function_write_scores(ps)
% FUNCTION_WRITE_SCORES  Write metabomatching scores to file

if isfield(ps.param,'multi')
    fn = fullfile(ps.param.dir_source,strrep(ps.param.multi,'pseudospectrum','scores'));
    fi = fopen(fn,'w');
    fprintf(fi,'cas\tid');
    for i = 1:size(ps.score,2)
        fprintf(fi,'\tscore/%s',ps.tag{i});
    end
    fprintf(fi,'\n');
    for j = 1:size(ps.sid,1)
        if ismember(ps.param.variant,{'pm2c','2c'})
            fprintf(fi,'%s\t%d\t%s\t%d',...
                ps.cas{j,1},ps.sid(j,1),...
                ps.cas{j,2},ps.sid(j,2));
            for i = 1:size(ps.score,2)
                fprintf(fi,'\t%.4f',ps.score(j,i));
            end
            fprintf(fi,'\n');
        else
            fprintf(fi,'%s\t%d',ps.cas{j},ps.sid(j));
            for i = 1:size(ps.score,2)
                fprintf(fi,'\t%.4f',ps.score(j,i));
            end
            fprintf(fi,'\n');
        end
    end
    fclose(fi);
else
    for i = 1:size(ps.score,2);
        
        fn=fullfile(ps.param.dir_source,[ps.tag{i},'.scores.tsv']);
        fi=fopen(fn,'w');
        fprintf(fi,'cas\tid\tscore\n');
        for j = 1:size(ps.sid,1)
            if ismember(ps.param.variant,{'pm2c','2c'})
                fprintf(fi,'%s\t%d\t%s\t%d\t%.4f\n',...
                    ps.cas{j,1},ps.sid(j,1),...
                    ps.cas{j,2},ps.sid(j,2),ps.score(j,i));
            else
                fprintf(fi,'%s\t%d\t%.4f\n',ps.cas{j},ps.sid(j),ps.score(j,i));
            end
        end
        fclose(fi);
    end
end
numberFields = {'n_show','dsh','decorr_lambda','snp','p_significant','pSuggestive'};
fi=fopen(fullfile(ps.param.dir_source,'parameters.out.tsv'),'w');
F=fieldnames(ps.param);
for iField = 1:length(F)
    f=F{iField};
    if ismember(f,numberFields)
        format = '%.4g';
    else
        format = '%s';
    end
    fprintf(fi,['%s\t',format,'\n'],f,ps.param.(f));
end
fclose(fi);