function ps = fun_processps(ps)

% defining cut points when computing permutation scores requires sorted shifts.
[~,r] = sort(ps.shift);
sfld = {'shift','beta','se','p','z'};
for jd = 1:length(sfld)
    fld = sfld{jd};
    if ismember(fld,fieldnames(ps))
        ps.(fld)=ps.(fld)(r,:);
    end
end

% metabomatching only uses beta and x in their ratio.
if ~ismember('z',fieldnames(ps))
    ps.z=ps.beta./ps.se;
end
