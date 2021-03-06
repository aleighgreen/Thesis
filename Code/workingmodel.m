%
%Integration of Hodgkin-Huxley equations with Euler method
%%NOTE: I had the naming backwards, so everything called tslow is actually
%%the faster of the t-currents. whoopsie.

clear; %when you run this through changingtau/max remove it from here
initialvals;
taumax=608;
%g(4)=0.0250;
%g(4)= 0.0417;
%g(4)=0.0583;
g(4)=0.0750;

%g(4)=(8.4*10^-5);

%Time step for integration;
dt=.03;

runtime=180000; %time of run in millisec
I_ext=normrnd(.59,.6,[1,(length(0:dt:runtime))]); 
I_ext(1:ceil((1.6667e+03)))=0;

x_plot=zeros(1,length(0:dt:runtime));
y_plot=zeros(1,length(0:dt:runtime));
Im_plot=zeros(1,length(0:dt:runtime));
It_plot=zeros(1,length(0:dt:runtime));
Ita_plot=zeros(1,length(0:dt:runtime));
Ir_plot=zeros(1,length(0:dt:runtime));

for t=-30:dt:runtime;
    
     %do something here 1 to 7 Hz
    %if t==500;I_ext=2; end
    %if t==20;I_ext=(randi(30)/10); %do something here 1 to 7 Hz
    
   
    
    %alpha functions used by hodgkin and huxley (activation)
alphafunctions;
    %leaking channel
    %beta functions used by hodgkin and huxley (inactivation)
    betafunctions;
    %functions for the m-current
    Mcurrentfunctions;
    %t-type current
    fastertfunction;
    %t-type slower
    ThreeTcurrent;
    %alpha and beta functions for the r-type current from Cav2_3
    rtypefunctions;
    
    %Tau_x and x_0 are defined with alpha and beta for Na and K
    tau=1./(alpha+beta);   %time constant
    x_0=alpha.*tau;    %steady-state equation
    %defining Tau and steady-state activation for r-type
    mrTau=1/(mAlpha+mBeta);
    mrInf=mAlpha*mrTau;
    hrTau=1/(hAlpha +hBeta);
    hrInf=hAlpha*hrTau;
    %now
   
    %leaky integration with Euler method
    x=(1-dt./tau).*x+dt./tau.*x_0;
    %x=x+dt*((alpha.*(1-x))-(beta.*x));
    %integration for m-current
    m=(1-dt./taup).*m+dt./taup.*p;
    %m=m+dt*((p-m)/taup);
    %integration for the fast-t-type current
    mt=(1-dt./mTau).*mt+dt./mTau.*mInf;
    ht=(1-dt./hTau).*ht+dt./hTau.*hInf;
    
    %integration for the slow-t-type
    mtslow=(1-dt./mtsTau).*mtslow+dt./mtsTau.*mtsInf;
    htslow=(1-dt./htsTau).*htslow+dt./htsTau.*htsInf;
    %integration for r-type current
    mr=(1-dt./mrTau).*mr+dt./mrTau.*mrInf;
    hr=(1-dt./hrTau).*hr+dt./hrTau.*hrInf;
    
    
    
    %calculate actual conductance using probability of opening times
    %maximum conductance
    gnmh(1)=g(1)*x(1)^4;          %potassium channels
    gnmh(2)=g(2)*x(2)^3*x(3);     %sodium channels
    gnmh(3)=g(3);               %leak
    
    Mcur=g(4)*m;  %conductance max of M-channels times probability ala Yamada
    Tcur = gCav3_3bar*mt*ht;%this is for the Cav3.3
    Tslcur= gCav3_1bar*mtslow*htslow;
    %r current regulated by CaV2.3 calcium channel
    Rcur=gCav2_3*mr*hr;
   
    %leaking channels
    %Ohm's law
    I=(gnmh.*(E-V));
    Im=(Mcur*(-90-V));%E of K -90
    It=(Tcur*(30-V));%ECa for this is 30 mV Ca3.3
    Itslow=(Tslcur*(30-V));%Ca3.1
    Ir=Rcur*(135-V);%reversal is 135 mV
    if t>=0;
        t_rec=t_rec+1;
    %Itslow;
    %update voltage of membrane
    V=V+dt*(I_ext(t_rec)+(sum(I)+Im));
    %record some variables for plotting after equilibration
         if V> 49.3
          y_plot(t_rec)=1; end
    %y_plot(t_rec)=V;
    x_plot(t_rec)=t;
   
        
%         I_plot(t_rec,:)=I;
%             Im_plot(t_rec)=Im;
%              It_plot(t_rec)=It;
%              Ita_plot(t_rec)=Itslow;
%          Ir_plot(t_rec)=Ir;

    end
    end

   
% 
%   [spiketime maxtab]=spiketimelocator(y_plot,x_plot);
%   binplot=zeros(1,length(0:dt:runtime));
%   binplot(maxtab(:,1))=1;
     


% %hold on
% beep
% pause(0.5)
% beep
new_y=cleaner(y_plot,runtime);
plot(new_y); xlabel('Time (ms)');ylabel('Voltage(mV)');
% hold on
% plot(Im_plot);
% plot(It_plot,'r');
% plot(Ita_plot, 'g');
% plot(Ir_plot,'k');
%splot(new_y);
%plot(new_y);
% spiketime=spiketimelocator(new_y,x_plot);
% figure;
% hist(diff(spiketime));
% cleaner;
% binner;



 