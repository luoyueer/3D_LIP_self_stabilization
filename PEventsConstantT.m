function [value, isterminal, direction] = PEventsConstantT(X,y0,t)
global T dx_t;
phi = t/T;

% Zs = dx_t*phi^3-dx_t*phi^2;

value(1) = phi-1;

isterminal(1) = 1;
direction(1) = 1;
end