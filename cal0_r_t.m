function [r,t] = cal0_r_t(n1,n2,n3,d,lamda,AOI)
delta = 4*pi./lamda.*n2.*d*cos(AOI);
r12 = (n2 - n1)./(n2 + n1);
t12 = 2*sqrt(n1.*n2)./(n2 + n1);
r23 = (n3 - n2)./(n3 + n2);
t23 = 2*sqrt(n2.*n3)./(n3 + n2);
r = (r12+r23.*exp(1i*delta))./(1+ r12.*r23.*exp(1i*delta));
t = (t12.*t23).*exp(1i*delta/2)./(1+ r12.*r23.*exp(1i*delta));
end