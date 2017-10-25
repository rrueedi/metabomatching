function ps=function_import_pseudospectra(ps)
% FUNCTION_IMPORT_PSEUDOSPECTRA Read pseudospectrum files
if exist(ps.param.dir_source,'dir')
    fn=dir(fullfile(ps.param.dir_source,'*.pseudospectrum.tsv'));
    if ~isempty(fn)
        for f={'beta','se','p','tag'}
            if isfield(ps,f{1});
                ps = rmfield(ps,f{1});
            end
        end
        for i = 1:length(fn)
            dsfni = fullfile(ps.param.dir_source,fn(i).name);            
            ts = func_readtable(dsfni);
            [ts.lb{:}]
            if ~ismember('/',[ts.lb{:}])               
                ps.tag{i,1} = strrep(fn(i).name,'.pseudospectrum.tsv','');
                for i_field=1:length(ts.lb)
                    ps.(ts.lb{i_field})(:,i)=ts.pr{i_field};
                end
            else
                ps.tag={};
                ps.param.multi=fn(i).name;
                for i_field = 1:length(ts.lb)
                    if strcmpi(ts.lb{i_field},'shift')
                        ps.shift=ts.pr{i_field};
                    else
                        xx=regexp(ts.lb{i_field},'/','split');
                        if length(xx)==2
                            ix = find(strcmpi(ps.tag,xx{2}));
                            if isempty(ix)
                                ix = length(ps.tag)+1;
                                ps.tag{ix,1} = xx{2};
                            end
                            ps.(xx{1})(:,ix)=ts.pr{i_field};
                        end
                    end
                end
                se_dump = find(all(ps.beta==0)|all(ps.p==0)|all(ps.se==0));
                ps.tag(se_dump)=[];
                ps.beta(:,se_dump)=[];
                ps.se(:,se_dump)=[];
                ps.p(:,se_dump)=[];
            end
        end
        ps.shift = ps.shift(:,1);
        %
        if ismember(ps.param.variant,{'pm','pm1c','pm2c'})
            F=fieldnames(ps);
            nr = length(ps.tag);
            for jf = 1:length(F)
                f=F{jf};
                if ~ismember(f,{'param','shift'})
                    if ismember(f,{'beta','se','p'});
                        ps.(f)=[ps.(f),ps.(f)];
                    else
                        ps.(f)=[ps.(f);ps.(f)];
                    end
                end
            end
            for jr = 1:nr
                ps.tag{jr}=[ps.tag{jr},'pos'];
                se = ps.p(:,jr)<ps.param.pSuggestive & ps.beta(:,jr)<0;
                ps.beta(se,jr)=-1e-6;
                ps.pm{jr,1}='positive';
            end
            for jr = (nr+1):2*nr
                ps.tag{jr}=[ps.tag{jr},'neg'];
                se = ps.p(:,jr)<ps.param.pSuggestive & ps.beta(:,jr)>0;
                ps.beta(se,jr)=1e-6;
                ps.pm{jr,1}='negative';
            end
        end
    else
        error('metabomatching:noPS','No pseudospectrum files found (*.pseudospectrum.tsv)');
    end
else
    error('metabomatching:noDS','Source directory %s does not exist',ps.param.dir_source);
end
