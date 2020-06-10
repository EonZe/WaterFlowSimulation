function [vr,vv,vr1] = integral1()
format shortEng
%format compact
%[msg, id] = lastwarn;
%warning('off', id)
j=500;
dr=0.000001;
k=1;
Psistr=0;
dPsidr=0;
%ni=0.15e-4;%air
ni=1.0e-6; %water
%ni=0.114e-6; %Hg
%ni=0.215e-6; %Ga
f=1000;%frequency 
a=0.000040; % radius of coloumn
%A=0.000000058;amplitude of vibration in case of pzt vibrator 200 x 200 um
%A=3*0.000000064; %amplitude of vibration in case of pzt vibrator 1 x 1 x 0.5 mm
A=0.000008;%amplitude of circular vibrations
eps=sqrt(1i*2*pi*f/ni);
epsz=sqrt(-1i*2*pi*f/ni);
r=a;
H01epsa=besselh(0,1,a*eps);
C=besselh(2,1,a*eps)./H01epsa;
Cconj=conj(besselh(2,1,a*eps)./H01epsa);
roxxm1=@(x) 2*pi^3*f^3*A^2/ni^2./x.*(2*besselh(0,1,x*eps)/H01epsa +2*conj(besselh(0,1,x*eps)/H01epsa)-2*a^2./x.^2*C.*besselh(2,2,x*epsz)/conj(H01epsa)-2*a^2./x.^2.*Cconj.*besselh(2,1,x*eps)/H01epsa-4*besselh(0,1,x*eps)/H01epsa.*conj(besselh(0,1,x*eps)/H01epsa)+4*besselh(2,1,x*eps)/H01epsa.*conj(besselh(2,1,x*eps)/H01epsa));
roxx=@(x) 2*pi^3*f^3*A^2.*x/ni^2.*(2*besselh(0,1,x*eps)/H01epsa +2*conj(besselh(0,1,x*eps)/H01epsa)-2*a^2./x.^2*C.*besselh(2,2,x*epsz)/conj(H01epsa)-2*a^2./x.^2.*Cconj.*besselh(2,1,x*eps)/H01epsa-4*besselh(0,1,x*eps)/H01epsa.*conj(besselh(0,1,x*eps)/H01epsa)+4*besselh(2,1,x*eps)/H01epsa.*conj(besselh(2,1,x*eps)/H01epsa));
%roxxc=@(x) x.*(2*besselh(0,1,x*eps)/H01epsa +2*conj(besselh(0,1,x*eps)/H01epsa)-2*a^2./x.^2*C.*conj(besselh(2,1,x*eps)/H01epsa)-2*a^2./x.^2.*Cconj.*besselh(2,1,x*eps)/H01epsa-4*besselh(0,1,x*eps)/H01epsa.*conj(besselh(0,1,x*eps)/H01epsa)+4*besselh(2,1,x*eps)/H01epsa.*conj(besselh(2,1,x*eps)/H01epsa));
roxx3=@(x) 2*pi^3*f^3*A^2.*x.^3/ni^2.*(2*besselh(0,1,x*eps)/H01epsa +2*conj(besselh(0,1,x*eps)/H01epsa)-2*a^2./x.^2*C.*besselh(2,2,x*epsz)/conj(H01epsa)-2*a^2./x.^2.*Cconj.*besselh(2,1,x*eps)/H01epsa-4*besselh(0,1,x*eps)/H01epsa.*conj(besselh(0,1,x*eps)/H01epsa)+4*besselh(2,1,x*eps)/H01epsa.*conj(besselh(2,1,x*eps)/H01epsa));
roxx5=@(x) 2*pi^3*f^3*A^2.*x.^5/ni^2.*(2*besselh(0,1,x*eps)/H01epsa +2*conj(besselh(0,1,x*eps)/H01epsa)-2*a^2./x.^2*C.*besselh(2,2,x*epsz)/conj(H01epsa)-2*a^2./x.^2.*Cconj.*besselh(2,1,x*eps)/H01epsa-4*besselh(0,1,x*eps)/H01epsa.*conj(besselh(0,1,x*eps)/H01epsa)+4*besselh(2,1,x*eps)/H01epsa.*conj(besselh(2,1,x*eps)/H01epsa));
c1x3=-1/48*integral(roxx3,a,inf);
c1=-1/48*integral(roxxm1,a,inf);
%c1=-1/48*integral(roxxm1,a,0.000055,'RelTol',1.3e-13,'AbsTol',1.3e-13)
c2=1/16*integral(roxx,a,inf);
c3=a^4/16*integral(roxxm1,a,inf)-a^2/8*integral(roxx,a,inf);
c4=-a^6/24*integral(roxxm1,a,inf)+a^4/16*integral(roxx,a,inf);
%disp(['     k               r               Psi             dPsi/dr'])
vk=[1];
vr=[a];
vr1=[a];
vpsi=[0];
vv=[0];  % um/s
while k <j
%disp([k,r,Psistr,dPsidr])
k=k+1;
r=r+dr;
Psistrkm1=Psistr;
Psistr=abs(r^4*((1/48)*integral(roxxm1,a,r)+c1)+r^2*((-1)/16*integral(roxx,a,r)+c2)+(1/16*integral(roxx3,a,r)+c3)+r^(-2)*(((-1)/48)*integral(roxx5,a,r)+c4));
%dPsidr=abs((Psistr-Psistrkm1)/dr);
dPsidr=(Psistr-Psistrkm1)/dr;
vk=[vk,k];
vr=[vr,1e6*(r-a)];
%vr=[vr,1e6*r];
vr1=[vr1,1e6*r];
vpsi=[vpsi,Psistr];
vv=[vv,1e6*dPsidr];
end
k=1;
vr2=vv./vr1;
vv2=0;
while k <j
vv2=vv2+vr2(k+1);
k=k+1;
end
vk2=vv2/j;
k=1;
vk3=[vk2];
while k <j
vk3=[vk2,vk3];
k=k+1;
end

return;
figure(2)
plot(vr,vv)
grid
xlabel('r [\mum]')
ylabel('v_0 [\mum/s]')
title('Tangential speed v_0 against distance from the pillar')
figure(3)
plot(vr,vv./vr1,'b', vr,vk3,'r')
grid
legend('v_r','average v_r');
xlabel('r [\mum]')
ylabel('v_r [rd/s]')
title('Rotational speed v_r against distance from the pillar')
end
