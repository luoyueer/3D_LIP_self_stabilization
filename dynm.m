function [dx, alpha] = dynm(t,x)
global omega;

dx = [0;0;0;0];
dx(1) = x(3);
dx(2) = x(4);
dx(3) = omega^2*x(1);
dx(4) = omega^2*x(2);

return;





