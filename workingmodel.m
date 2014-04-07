%
%Integration of Hodgkin-Huxley equations with Euler method
%

clear; %when you run this through changingtau remove it from here
initialvals;
taumax=608; %when you run this through changingtau remove it from here

for t=-30:dt:50
    if t==10; I_ext=60.375; end %turns external curent on This input is 0.5 nA
    if t==12; I_ext=0; end %turns external current off 
    
    %alpha functions used by hodgkin and huxley (activation)
alphafunctions;
    %leaking channel
    %beta functions used by hodgkin and huxley (inactivation)
    betafunctions;
    Mp=slowpot(V);
    Taup=tauslowpot(taumax,V);
    %Tau_x and x_0 are defined with alpha and beta
    tau=1./(alpha+beta);   %time constant
    x_0=alpha.*tau;    %steady-state equation
    %leaky integration with Euler method
    x=(1-dt./tau).*x+dt./tau.*x_0;
    m=m*(1-dt)./Taup +((Mp)*(dt./(Taup)));
    %calculate actual conductance using probability of opening times
    %maximum conductance
    gnmh(1)=g(1)*x(1)^4;          %potassium channels
    gnmh(2)=g(2)*x(2)^3*x(3);     %sodium channels
    gnmh(3)=g(3);                 %leak?
    Mcur=(g(4)*m);
   
    %leaking channels
    %Ohm's law
    I=(gnmh.*(V-E));
    Im=Mcur*(V+90);
    %update voltage of membrane
    V=V+dt*(I_ext-(sum(I+(Im))));
    %record some variables for plotting after equilibration
    if t>=0;
        t_rec=t_rec+1;
        x_plot(t_rec)=t;
        y_plot(t_rec)=V;
        I_plot(t_rec,:)=I;
        Im_plot(t_rec)=Im;
        m_plot(t_rec)=m;
        nmhplot(t_rec,:)=x;
    end
end  %time loop

%plot(x_plot,y_plot, 'r'); xlabel('Time');ylabel('Voltage')

% %figure;
%plot(x_plot, Im_plot, 'k')
% figure;
%plot(x_plot, I_plot)
