%Maximal conductances k,na,r,m-current
%g(1)=36; g(2)=120; g(3)=0.3; g(4)=0.075; 
g(1)=6; g(2)=56; g(3)=(0.02); g(4)=0.075;
%reversal potentials K,Na,Leak,M-current(same as K) mV
E(1)=-90; E(2)=50; E(3)=-70.3; 
%Initialization of some variables
I_ext=0; 
V=-65; 
x=zeros(1,3); 
x(3)=1; 
t_rec=0; 
Vt=-56.2; 
m=0.0474;

%Time step for integration;
dt=0.01;


