clc;
D = xlsread('T.xlsx');
DQUARZE = xlsread('nQUARZE.xls');
DITO = xlsread('nITO.xls');
wave = flip(D(:,1));
AClBr09 = flip(D(:,2));AClBr09 = -log(AClBr09/100);
AClBr1 = flip(D(:,3));AClBr1 = -log(AClBr1/100);
ACl3 = flip(D(:,4));ACl3 = -log(ACl3/100);
ABr3 = flip(D(:,5));ABr3 = -log(ABr3/100);
ABrI2 = flip(D(:,6));ABrI2 = -log(ABrI2/100);
TNiO = 0.98;
TSnO2 = 0.98;
TITO = 0.9;
TQUARZE = 1;
figure;
plot(wave,AClBr09,'--rs');
hold on;
plot(wave,AClBr1,'--gs');
hold on;
plot(wave,ACl3,'--bs');
hold on;
plot(wave,ABr3,'--ys');
hold on;
plot(wave,ABrI2,'--ks');
hold on;
legend('ClBr0.9','ClBr1','Cl3','Br3','BrI2');
axis([400,700,0,6]);
figure;
plot(wave,exp(-AClBr09),'--rs');
hold on;
plot(wave,exp(-AClBr1),'--gs');
hold on;
plot(wave,exp(-ACl3),'--bs');
hold on;
plot(wave,exp(-ABr3),'--ys');
hold on;
plot(wave,exp(-ABrI2),'--ks');
hold on;
legend('ClBr0.9','ClBr1','Cl3','Br3','BrI2');

%{
for i=1:381 
    if (wave(i)-405)<=1
        TCl3 = exp(-ACl3*k1);
        TClBr09 = exp(-AClBr09*k2);
        TBr3 = exp(-ABr3*k2);
        TBrI = 1;
    end
end
%}

N1 = 9;
N2 = 76;
N3 = 116;
N4 = 241;

k1 = linspace(0.01,5,1000);
d1 = 347.4;
k2 = linspace(0.01,5,1000);
d2 = 356.3;
k3 = linspace(0.01,5,1000);
d3 = 422.6;

%k1 = 0;
k2 = 0;
k3 = 0;
TCl3 = exp(-ACl3*k1);
TClBr09 = exp(-AClBr09*k2);
TBr3 = exp(-ABr3*k3);
TBrI = 1;
T = TITO*TNiO.*TCl3*TSnO2.*TClBr09*TNiO*TITO*TQUARZE*TITO*TNiO.*TBr3*TSnO2.*TBrI*TNiO*TITO;

figure;
plot(k1*d1,T(N1,:));
output = [(k1*d1)',T(N1,:)'];
%xlswrite('Cl3',output);