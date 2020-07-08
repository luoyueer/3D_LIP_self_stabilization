function [t,Y,alpha] = singlesupport_Zsis0(y0,pos_foot,Zs_prev)
    tspan = 0:0.0001:2;
    options = odeset('Events',@(t,y)PEventsZsIs0_stability(y,y0,t,pos_foot,Zs_prev));
    [t,Y,alpha] = ode45(@(t,y)dynm(t,y),tspan,y0,options);
      
end