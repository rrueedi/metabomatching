function ps=function_import_pseudospectra(ps)
% FUNCTION_IMPORT_PSEUDOSPECTRA Read pseudospectrum files
if exist(ps.param.dir_source,'dir')
    fil=dir(fullfile(ps.param.dir_source,'*.pseudospectrum.tsv'));
    if length(fil)>0
        for f={'beta','se','p','tag'}
            if isfield(ps,f{1});
                ps = rmfield(ps,f{1});
            end
        end
        for i = 1:length(fil)
            fi = fopen(fullfile(ps.param.dir_source,fil(i).name));
            qq = textscan(fi,'%s',1,'delimiter','?');
            qq = qq{1}{1};
            fclose(fi);
            nc = length(regexp(qq,'\s','split'));
            fi = fopen(fullfile(ps.param.dir_source,fil(i).name));
            lb = textscan(fi,repmat('%s',1,nc),1,'delimiter','\t');
            pr = textscan(fi,repmat('%f',1,nc),'delimiter','\t');
            fclose(fi);
            if length(lb)==4
                ps.tag{i,1} = strrep(fil(i).name,'.pseudospectrum.tsv','');
                for i_field=1:length(lb)
                    ps.(lb{i_field}{1})(:,i)=pr{i_field};
                end
            else
                ps.tag={};
                ps.param.multi=fil(i).name;
                for i_field = 1:length(lb)
                    if strcmpi(lb{i_field}{1},'shift')
                        ps.shift=pr{i_field};
                    else
                        xx=regexp(lb{i_field}{1},'/','split');
                        if length(xx)==2
                            ix = find(strcmpi(ps.tag,xx{2}));
                            if isempty(ix)
                                ix = length(ps.tag)+1;
                                ps.tag{ix,1} = xx{2};
                            end
                            ps.(xx{1})(:,ix)=pr{i_field};
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
        %ps.param.dir_source = dir_source;
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
