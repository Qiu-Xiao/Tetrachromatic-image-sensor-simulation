clc;
M = 1000;
N = 1000;
Dn = xlsread('en.xlsx');
Dk = xlsread('ek.xlsx');
DITO = xlsread('nITO.xls');
DQUARZE = xlsread('nQUARZE.xls');
DUV = xlsread('T.xlsx');
waveUV = flip(DUV(:,1))*1e-9;
thickness = 0.35e-6;
AClBr2 = flip(DUV(:,2));AClBr2 = -log(AClBr2/100)/thickness;kClBr2 = AClBr2.*waveUV/2/pi;
thickness = 0.345e-6;
ACl3 = flip(DUV(:,4));ACl3 = -log(ACl3/100)/thickness;kCl3 = ACl3.*waveUV/2/pi;
thickness = 0.42e-6;
ABr3 = flip(DUV(:,5));ABr3 = -log(ABr3/100)/thickness;kBr3 = ABr3.*waveUV/2/pi;
thickness = 0.61e-6;
ABrI2 = flip(DUV(:,6));ABrI2 = -log(ABrI2/100)/thickness;kBrI2 = ABrI2.*waveUV/2/pi;

factor = 3;

wavee = Dn(:,1)*1e-9;
waveITO = DITO(:,1)*1e-6;
waveQUARZE = DQUARZE(:,1)*1e-6;

DataneBr3 = Dn(:,2);
DataneClBr2 = Dn(:,3);
DataneCl3 = Dn(:,4);
DataneBrI2 = Dn(:,5);
DatanITO = DITO(:,2);
DatanQUARZE = DQUARZE(:,2);

DatakeBr3 = Dk(:,2);
DatakeClBr2 = Dk(:,3);
DatakeCl3 = Dk(:,4);
DatakeBrI2 = Dk(:,5);
DatakITO = DITO(:,3);

wave = linspace(371.4,700,N)'*1e-9;

p = polyfit(waveITO,DatanITO,9);
nrITO =  p(1)*wave.^9+p(2)*wave.^8+p(3)*wave.^7+p(4)*wave.^6+p(5)*wave.^5+p(6)*wave.^4+p(7)*wave.^3+p(8)*wave.^2+p(9)*wave+p(10);
p = polyfit(waveQUARZE,DatanQUARZE,9);
tempnQUARZE =  p(1)*wave.^9+p(2)*wave.^8+p(3)*wave.^7+p(4)*wave.^6+p(5)*wave.^5+p(6)*wave.^4+p(7)*wave.^3+p(8)*wave.^2+p(9)*wave+p(10);

p = polyfit(wavee,DataneBr3,9);
neBr3 =  p(1)*wave.^9+p(2)*wave.^8+p(3)*wave.^7+p(4)*wave.^6+p(5)*wave.^5+p(6)*wave.^4+p(7)*wave.^3+p(8)*wave.^2+p(9)*wave+p(10);
p = polyfit(wavee,DataneClBr2,9);
neClBr2 =  p(1)*wave.^9+p(2)*wave.^8+p(3)*wave.^7+p(4)*wave.^6+p(5)*wave.^5+p(6)*wave.^4+p(7)*wave.^3+p(8)*wave.^2+p(9)*wave+p(10);
p = polyfit(wavee,DataneCl3,9);
neCl3 =  p(1)*wave.^9+p(2)*wave.^8+p(3)*wave.^7+p(4)*wave.^6+p(5)*wave.^5+p(6)*wave.^4+p(7)*wave.^3+p(8)*wave.^2+p(9)*wave+p(10);
p = polyfit(wavee,DataneBrI2,9);
neBrI2 =  p(1)*wave.^9+p(2)*wave.^8+p(3)*wave.^7+p(4)*wave.^6+p(5)*wave.^5+p(6)*wave.^4+p(7)*wave.^3+p(8)*wave.^2+p(9)*wave+p(10);

kITO =  interp1(waveITO,DatakITO,wave,'spline');
keBr3 =  interp1(waveUV,kBr3,wave,'spline');
keClBr2 =  interp1(waveUV,kClBr2,wave,'spline');
keCl3 =  interp1(waveUV,kCl3,wave,'spline');
keBrI2 =  interp1(waveUV,kBrI2,wave,'spline');

AOI = 0;
lamda = wave;

nair = 1;
nITO = nrITO + 1i*kITO;
nglass = tempnQUARZE;
nBrI2 = neBrI2 + 1i*keBrI2;
nBr3 = neBr3 + 1i*keBr3;
nClBr2 = neClBr2 + 1i*keClBr2;
nCl3 = neCl3 + 1i*keCl3;
nSnO2 = nglass;

out_T = zeros(N,M);
out_R = zeros(N,M);
dITO = 130e-9;
dglass = 1e-6;

dBrI2 = 350e-9; %320
dBr3 = 380e-9; %350
dClBr2 = 330e-9; %300
dCl3 = 230e-9;  %200
dSnO2 = 15e-9;

layer0 = 0;
layer1 = dITO;
layer2 = layer1 + dCl3;
layer3 = layer2 + dSnO2;
layer4 = layer3 + dClBr2;
layer5 = layer4 + dITO;
layer6 = layer5 + dglass;
layer7 = layer6 + dITO;
layer8 = layer7 + dBr3;
layer9 = layer8 + dSnO2;
layer10 = layer9 + dBrI2;
layer11 = layer10 + dITO;
depth = linspace(0,layer11,M)';
for j=1:M
dc = depth(j);
%1  
if dc<=layer1&&dc>=layer0
tempd = dc - layer0;
n1 = nair;
n2 = nITO;
n3 = nCl3;
d = tempd;
[r,t] = cal0_r_t(n1,n2,n3,d,lamda,AOI);
%2222222222222222222222222222222222222
elseif dc<=layer2&&dc>layer1
tempd = dc - layer1;
n1 = nITO;
n2 = nCl3;
n3 = nSnO2;
d = tempd;
[r,t] = cal0_r_t(n1,n2,n3,d,lamda,AOI);
n1 = nair;
n2 = nITO;
%n3 = nCl3;
d = dITO;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);
%33333333333333333333333333333333333
elseif dc<=layer3&&dc>layer2
tempd = dc - layer2;
n1 = nCl3;
n2 = nSnO2;
n3 = nClBr2;
d = tempd;
[r,t] = cal0_r_t(n1,n2,n3,d,lamda,AOI);
n1 = nITO;
n2 = nCl3;
%n3 = nClBr2;
d = dCl3;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);
n1 = nair;
n2 = nITO;
%n3 = nCl3;
d = dITO;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);
%4444444444444444444444444444444444
elseif dc<=layer4&&dc>layer3
tempd = dc - layer3;
n1 = nSnO2;
n2 = nClBr2;
n3 = nITO;
d = tempd;
[r,t] = cal0_r_t(n1,n2,n3,d,lamda,AOI);
n1 = nCl3;
n2 = nSnO2;
%n3 = nITO;
d = dSnO2;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);
n1 = nITO;
n2 = nCl3;
%n3 = nClBr2;
d = dCl3;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);
n1 = nair;
n2 = nITO;
%n3 = nCl3;
d = dITO;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);
%55555
elseif dc<=layer5&&dc>layer4
tempd = dc - layer4;
n1 = nClBr2;
n2 = nITO;
n3 = nglass;
d = tempd;
[r,t] = cal0_r_t(n1,n2,n3,d,lamda,AOI);

n1 = nSnO2;
n2 = nClBr2;
%n3 = nglass;
d = dClBr2;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);
n1 = nCl3;
n2 = nSnO2;
%n3 = nITO;
d = dSnO2;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);
n1 = nITO;
n2 = nCl3;
%n3 = nClBr2;
d = dCl3;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);
n1 = nair;
n2 = nITO;
%n3 = nCl3;
d = dITO;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);
%6666
elseif dc<=layer6&&dc>layer5
tempd = dc - layer5;
n1 = nITO;
n2 = nglass;
n3 = nITO;
d = tempd;
[r,t] = cal0_r_t(n1,n2,n3,d,lamda,AOI);

n1 = nClBr2;
n2 = nITO;
%n3 = nITO;
d = dITO;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);

n1 = nSnO2;
n2 = nClBr2;
%n3 = nglass;
d = dClBr2;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);
n1 = nCl3;
n2 = nSnO2;
%n3 = nITO;
d = dSnO2;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);
n1 = nITO;
n2 = nCl3;
%n3 = nClBr2;
d = dCl3;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);
n1 = nair;
n2 = nITO;
%n3 = nCl3;
d = dITO;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);
%777777
elseif dc<=layer7&&dc>layer6
tempd = dc - layer6;
n1 = nglass;
n2 = nITO;
n3 = nBr3;
d = tempd;
[r,t] = cal0_r_t(n1,n2,n3,d,lamda,AOI);

n1 = nITO;
n2 = nglass;
%n3 = nBr3;
d = dglass;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);

n1 = nClBr2;
n2 = nITO;
%n3 = nITO;
d = dITO;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);

n1 = nSnO2;
n2 = nClBr2;
%n3 = nglass;
d = dClBr2;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);
n1 = nCl3;
n2 = nSnO2;
%n3 = nITO;
d = dSnO2;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);
n1 = nITO;
n2 = nCl3;
%n3 = nClBr2;
d = dCl3;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);
n1 = nair;
n2 = nITO;
%n3 = nCl3;
d = dITO;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);
%88888888888888
elseif dc<=layer8&&dc>layer7
tempd = dc - layer7;
n1 = nITO;
n2 = nBr3;
n3 = nSnO2;
d = tempd;
[r,t] = cal0_r_t(n1,n2,n3,d,lamda,AOI);

n1 = nglass;
n2 = nITO;
d = dITO;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);

n1 = nITO;
n2 = nglass;
%n3 = nBr3;
d = dglass;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);

n1 = nClBr2;
n2 = nITO;
%n3 = nITO;
d = dITO;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);

n1 = nSnO2;
n2 = nClBr2;
%n3 = nglass;
d = dClBr2;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);
n1 = nCl3;
n2 = nSnO2;
%n3 = nITO;
d = dSnO2;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);
n1 = nITO;
n2 = nCl3;
%n3 = nClBr2;
d = dCl3;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);
n1 = nair;
n2 = nITO;
%n3 = nCl3;
d = dITO;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);
%999999999999999
elseif dc<=layer9&&dc>layer8
tempd = dc - layer8;
n1 = nBr3;
n2 = nSnO2;
n3 = nBrI2;
d = tempd;
[r,t] = cal0_r_t(n1,n2,n3,d,lamda,AOI);

n1 = nITO;
n2 = nBr3;
d = dBr3;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);

n1 = nglass;
n2 = nITO;
d = dITO;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);

n1 = nITO;
n2 = nglass;
%n3 = nBr3;
d = dglass;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);

n1 = nClBr2;
n2 = nITO;
%n3 = nITO;
d = dITO;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);

n1 = nSnO2;
n2 = nClBr2;
%n3 = nglass;
d = dClBr2;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);
n1 = nCl3;
n2 = nSnO2;
%n3 = nITO;
d = dClBr2;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);
n1 = nITO;
n2 = nCl3;
%n3 = nClBr2;
d = dCl3;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);
n1 = nair;
n2 = nITO;
%n3 = nCl3;
d = dITO;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);
%1010100100101001
elseif dc<=layer10&&dc>layer9
tempd = dc - layer9;
n1 = nSnO2;
n2 = nBrI2;
n3 = nITO;
d = tempd;
[r,t] = cal0_r_t(n1,n2,n3,d,lamda,AOI);

n1 = nBr3;
n2 = nSnO2;
d = dSnO2;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);

n1 = nITO;
n2 = nBr3;
d = dBr3;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);

n1 = nglass;
n2 = nITO;
d = dITO;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);

n1 = nITO;
n2 = nglass;
%n3 = nBr3;
d = dglass;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);

n1 = nClBr2;
n2 = nITO;
%n3 = nITO;
d = dITO;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);

n1 = nSnO2;
n2 = nClBr2;
%n3 = nglass;
d = dClBr2;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);
n1 = nCl3;
n2 = nSnO2;
%n3 = nITO;
d = dClBr2;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);
n1 = nITO;
n2 = nCl3;
%n3 = nClBr2;
d = dCl3;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);
n1 = nair;
n2 = nITO;
%n3 = nCl3;
d = dITO;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);
elseif dc<=layer11&&dc>layer10
tempd = dc - layer9;
n1 = nBrI2;
n2 = nITO;
n3 = nair;
d = tempd;
[r,t] = cal0_r_t(n1,n2,n3,d,lamda,AOI);

n1 = nSnO2;
n2 = nBrI2;
d = dBrI2;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);

n1 = nBr3;
n2 = nSnO2;
d = dSnO2;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);

n1 = nITO;
n2 = nBr3;
d = dBr3;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);

n1 = nglass;
n2 = nITO;
d = dITO;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);

n1 = nITO;
n2 = nglass;
%n3 = nBr3;
d = dglass;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);

n1 = nClBr2;
n2 = nITO;
%n3 = nITO;
d = dITO;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);

n1 = nSnO2;
n2 = nClBr2;
%n3 = nglass;
d = dClBr2;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);
n1 = nCl3;
n2 = nSnO2;
%n3 = nITO;
d = dClBr2;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);
n1 = nITO;
n2 = nCl3;
%n3 = nClBr2;
d = dCl3;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);
n1 = nair;
n2 = nITO;
%n3 = nCl3;
d = dITO;
[r,t] = cal_r_t(r,t,n1,n2,d,lamda,AOI);
    
    %output

end

out_R(:,j) = abs(r).^2;
out_T(:,j) = abs(t).^2;
end

out_T = out_T';
out_R = out_R';

D = [lamda*1e6,depth*1e6,out_T];
xlswrite('case2_T.xlsx',D);
D = [lamda*1e6,depth*1e6,out_R];
xlswrite('case2_R.xlsx',D);

figure;
contour(lamda*1e6,depth*1e6,out_T);
title('T');
figure;
contour(lamda*1e6,depth*1e6,out_R);
title('R');
