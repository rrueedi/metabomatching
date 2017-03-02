function p=gamcdf_bound(chisq,df)
% GAMCDF_BOUND  Bound of gamma cumulative distribution function
u=chisq;
k=df;
a = 1/2.*(u-k-(k-2).*log(u/k)+log(k))-log(u);
p = a+log(sqrt(pi))+log(u-k+2);
p = p*log10(exp(1));