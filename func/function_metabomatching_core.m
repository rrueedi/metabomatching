function ps = function_metabomatching_core(ps)
% FUNCTION_METABOMATCHING_CORE  Compute metabomatching scores
nm = size(ps.sid,1);
ns = size(ps.p,2);
ps.score = NaN(nm,ns);
for jm = 1:nm
    if ps.param.decorr_lambda<1
        seInMet=[];
        for ii = 1:size(ps.cluster{jm},1)
            seInCluster = find(...
                ps.shift<=ps.cluster{jm}(ii,2) & ...
                ps.shift>=ps.cluster{jm}(ii,1));
            subC{ii} = ps.correlation(seInCluster,seInCluster);
            seInMet = [seInMet;seInCluster];
        end
        nInMet = length(seInMet);
        D = blkdiag(subC{:});
        clear subC
        C = (1-ps.param.decorr_lambda)*D+ps.param.decorr_lambda*eye(nInMet);
        z = ps.beta(seInMet,:)./ps.se(seInMet,:);
        switch ps.param.scoring
            case 'chisq'
                chisq = sum(z.*(C\z),1);
                ps.score(jm,:) = -log10(gamcdf_tail(chisq,nInMet/2,2));
                sl = ps.score(jm,:)==Inf;
                if ~isempty(sl)
                    % fprintf('using bound\n');
                    ps.score(jm,sl)=gamcdf_bound(chisq(sl),nInMet);
                end
            case 'z'
                ps.score(jm,:) = -log10(2*normcdf(-abs(sum(z,1)),0,sqrt(abs(sum(C(:))))));
        end
    else
        seInMet = find(ps.mim(:,jm));
        nInMet = length(seInMet);
        z = ps.beta(seInMet,:)./ps.se(seInMet,:);
        switch ps.param.scoring
            case 'chisq'
                chisq = sum(z.*z,1);
                ps.score(jm,:) = -log10(gamcdf_tail(chisq,nInMet/2,2));
                se = find(ps.score(jm,:)==Inf);
                if ~isempty(se)
                    ps.score(jm,se)=gamcdf_bound(chisq(se),nInMet);
                end
            case 'z'
                ps.score(jm,:) = -log10(2*normcdf(-abs(sum(z,1)),0,sqrt(nInMet)));
        end
    end
end