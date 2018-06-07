function ps = fun_pshuffle_score(ps)
% FUNCTION_PPERMUTE
nm = length(ps.sid);
nf = length(ps.shift);
ns = length(ps.tag);
np = ps.param.n_permutation;

permscore=NaN(np,ns);
for js = 1:ns
    zpi = squeeze(ps.zperm(:,:,js));
    opi = NaN(nm,np);
    for jm = 1:nm
        se_met = find(ps.mim(:,jm));
        nb_inmet = length(se_met);
        z = zpi(se_met,:);
        switch ps.param.scoring
            case 'chisq'
                chisq = sum(z.*z,1);
                opi(jm,:) = -log10(gamcdf_tail(chisq,nb_inmet/2,2));
                se = find(ps.score(jm,:)==Inf);
                if ~isempty(se)
                    opi(jm,se)=gamcdf_bound(chisq(se),nb_inmet);
                end
            case 'z'
                opi(jm,:) = -log10(2*normcdf(-abs(sum(z,1)),0,sqrt(nb_inmet)));
        end
    end
    opi(isnan(opi))=0;
    opi = sort(opi,1,'descend');
    permscore(:,js)=max(opi,[],1);
    % permscore(:,js)=prctile(opi,97.5,1);
    tm = sum(repmat(ps.score(:,js),1,np)<repmat(permscore(:,js)',nm,1),2);
    ps.scoreadj(:,js)=abs(log10((1+tm)/(1+np)));
end
