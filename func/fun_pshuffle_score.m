function ps = fun_pshuffle_score(ps)
% FUNCTION_PPERMUTE
nm = size(ps.sid,1);
nf = size(ps.shift,1);
ns = size(ps.p  ,2);
n_permutation = size(ps.zperm,2);

ps.permscore=NaN(n_permutation,ns);

for js = 1:ns
    zpi = squeeze(ps.zperm(:,:,js));
    opi = NaN(nm,n_permutation);
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
    ps.permscore(:,js)=max(opi,[],1);
    tm = sum(repmat(ps.score(:,js),1,n_permutation)<repmat(ps.permscore(:,js)',nm,1),2);
    ps.scoreadj(:,js)=-log10((1+tm)/(1+n_permutation));
end
