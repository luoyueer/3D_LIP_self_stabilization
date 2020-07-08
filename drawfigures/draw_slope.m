function draw_slope(x,y,y0,inverse)
global C k_dx X0d S D
l = k_dx*(X0d-y0(3));
slope = C*inverse;
L_draw = 0.2;
alpha = atan(1/slope);
x_draw_l = x - L_draw*cos(alpha)*S;
y_draw_l = y + L_draw*sin(alpha)*D;
x_draw_r = x + L_draw*cos(alpha)*S;
y_draw_r = y - L_draw*sin(alpha)*D;

% if y0(3)==X0d
%     plot([x_draw_l,x_draw_r],[y_draw_l,y_draw_r],'b-');
%     hold on
% else
    plot([x_draw_l,x_draw_r],[y_draw_l,y_draw_r],'b-','LineWidth',1.5);
    hold on;
% end

end