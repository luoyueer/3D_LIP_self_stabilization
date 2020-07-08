function [t,Y,alpha] = singlesupport_constantPace(y0)
    tspan = 0:0.001:3;
    options = odeset('Events',@(t,y)PEventsConstantT(y,y0,t),'Reltol',1e-3);
    [t,Y,alpha] = ode45(@(t,y)dynm(t,y),tspan,y0,options);
end