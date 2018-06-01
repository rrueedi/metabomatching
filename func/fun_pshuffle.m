function ps = fun_pshuffle(ps)
% FUN_PSHUFFLE  Build shuffled pseudospectra to compute permutation scores

nm = length(ps.sid);
nf = length(ps.shift);
ns = length(ps.tag);
np = ps.param.n_permutation;

% deep parameters
d_hole = 0.3;
d_cut = 0.04;
ts_smooth = 0;

s = ps.shift;

ps.zperm = NaN(nf,np,ns);

% identify holes
% holes are common to all pseudospectra
d = s(2:end)-s(1:(end-1));
ix_hole = find( d>d_hole );

for js = 1:ns
    g = ps.z(:,js);
    if ts_smooth
        g = g;
    end
    [g_srt,r_srt] = sort(abs(g),'ascend');
    s_srt = s(r_srt);
    
    if ~isempty(ix_hole)
        ix_cut = ix_hole;
        s_cut = s(ix_hole);
    else
        ix_cut = r_srt(1);
        s_cut = s_srt(1);
    end
    
    % cut threshold
    threshold_cut = std(g);
    for jf = 1:nf
        if ...
                ( min(abs(s_cut-s_srt(jf)))>d_cut ) && ...
                ( g_srt(jf) < threshold_cut)
            s_cut=[s_cut;s_srt(jf)];
            ix_cut=[ix_cut;r_srt(jf)];
        end
    end
    
    ix_cut = unique([1;ix_cut;nf]);
    nc = length(ix_cut)-1;
    
    qq = NaN(nf,2);
    cs = [];
    for jc = 1:nc
        s1 = s(ix_cut(jc));
        s2 = s(ix_cut(jc+1));
        if jc == 1
            se = find( (s>=s1) & (s<=s2) );
        else
            se = find( (s>s1) & (s<=s2) );
        end
        qq(se,1)=jc;
        qq(se,2)=(1:length(se))';
        cs=[cs;length(se)];
    end
    
    for jp = 1:np
        mm=0;
        [~,perm] = sort(rand(nc,1));
        for jc = 1:nc
            sec = find(qq(:,1)==perm(jc));
            nnc = length(sec);
            ps.zperm((mm+1):(mm+nnc),jp,js) = ps.z(sec,js);
            mm=mm+nnc;
        end
    end
end


