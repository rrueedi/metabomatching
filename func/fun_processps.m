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

switch ps.param.pstype
case 'xs'
% remove dummy columns
  se = find(all(ps.beta==0)|all(ps.p==0)|all(ps.se)==0);
  ps.tag(se)=[];
  ps.beta(:,se)=[];
  ps.se(:,se)=[];
  ps.p(:,se)=[];
  % metabomatching only uses beta and x in their ratio.
  ps.z=ps.beta./ps.se;
case 'isa'
  se = find(all(ps.isa==0));
  ps.tag(se)=[];
  ps.isa(:,se)=[];
  ps.z=zscore(ps.isa);
end

% handling pm cases
if ismember(ps.param.variant,{'pm','pm1c','pm2c'})
  F = fieldnames(ps);
  nr = length(ps.tag);
  for jf = 1:length(F)
    f=F{jf};
    if ~ismember(f,{'param','shift'})
      if ismember(f,{'beta','se','p','z'});
        ps.(f)=[ps.(f),ps.(f)];
      else
        ps.(f)=[ps.(f);ps.(f)];
      end
    end
  end
  for jr = 1:nr
    ps.tag{jr}=[ps.tag{jr},'.pos'];
    se = ps.p(:,jr)<ps.param.p_suggestive & ps.z(:,jr)<0;
    ps.z(se,jr)=-1E-10;
    % this may not be necessary, even for xs-type
    if strcmp(ps.param.type,'xs')
      ps.beta(se,jr)=-1E-10;
    end
    ps.pm{jr,1}='positive';
  end
  for jr = (nr+1):2*nr
    ps.tag{jr}=[ps.tag{jr},'.neg'];
    se = ps.p(:,jr)<ps.param.p_suggestive & ps.z(:,jr)>0;
    ps.z(se,jr)=+1E-10;
    % this may not be necessary, even for xs-type
    if strcmp(ps.param.type,'xs')
      ps.beta(se,jr)=+1E-10;
    end
    ps.pm{jr,1}='negative';
  end
end