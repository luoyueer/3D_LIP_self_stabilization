function [value, isterminal, direction] = PEventsZsIs0_stability(X,y0,t,pos_foot,Zs_prev)
global T kS Current_step N_step applyKajita zs_mid Xs_prev phi_mid



if (Current_step ==1 || Current_step==N_step)&&applyKajita==1
    phi = t/T;
else
    phi = cal_phi(X,y0);
end

if applyKajita == 0
    if Current_step == 1
        Xs_f = (1-kS)*(X(1)-1/2)+1;
        Xs_prev = Xs_f;
        Xs_i = -1;
    else
        Xs_f = (1-kS)*(X(1)-1/2)+1;
        Xs_i = -Xs_prev;
    end
    Xs = -2*(Xs_f-Xs_i)*phi^3+3*(Xs_f-Xs_i)*phi^2+Xs_i;
    if phi<phi_mid
        a_zs = (-(2*zs_mid)/(phi_mid)^3);
        b_zs = ((3*zs_mid)/(phi_mid)^2);
        c_zs = 0;
        d_zs = 0;
        Zs = a_zs*phi^3+b_zs*phi^2+c_zs*phi+d_zs;
    else
        
        a_zs = -zs_mid*(-1+2*phi_mid)/(phi_mid-1)^2;
        b_zs = (2*zs_mid*phi_mid)/(phi_mid-1)^2;
        c_zs = -zs_mid/(phi_mid-1)^2;
        Zs = c_zs*phi^2+b_zs*phi+a_zs;
    end
    
    Xs_global = Xs+pos_foot(1);
    Zs_global = Zs+Zs_prev;
    
    Zg=find_zg(Xs_global);
    
    value(1) = Zg-Zs_global;
else
    value(1) = phi - 1;
end
isterminal(1) = 1;
direction(1) = 1;
end