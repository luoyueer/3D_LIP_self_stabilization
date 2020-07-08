%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Case: with Kajita start and stop
%Arthor: Qiuyue Luo
%Date: 13/03/2018
%Note: the dynamic is calculated in normalized coordinate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear 
clf
close all

% ---------------------------------------------------------------------------------------------
currentfolder = pwd; % save current path
cd ..                % go one folder down (go out of the current folder and stay in the previous one)
add_paths;           % add all folders where all files are founded in order to acces to them
cd(currentfolder);   % return to the original path
% ---------------------------------------------------------------------------------------------


global omega g z_0 T k_dx X0d Y0d Current_step N_step isConstantT kS kD zs_mid  changeT phi_mid
global  DRAW_ENABLE applyKajita groundType Xs_prev XG YG ZG counter 
global S D 

counter =1;
Ani = 0;
DRAW_ENABLE = 1;

testcase = 3;
testcasesParam;

%---caracteristic of pendulum-------
g = 9.8;
z_0 = 1;
omega = sqrt(g/z_0);
Tc = 1/omega;
S=0.4; %S length of a step %Unit:m
D=0.2; %D width of a step %Unit:m
% S=1;
% D=1;
alpha_cyc = -(1-cosh(omega*T))/((1+cosh(omega*T)));

%-----------------------------------

XG = -2:0.01:N_step+2;
YG = -10:10:10;
ZG = groundGenerater;

a = 1;%definition of the gait for optimization N = a(Xd-X)^2+b(DXd-DX)^2
b = 10;
%----------------------------------
Ch = cosh(T*omega);
Sh = sinh(T*omega);

inverse = 1;

%-----initial condition-------------------------
t_prev = 0;
x_dot_0(1) = omega*(1/2)*(1+cosh(omega*T))/(sinh(omega*T)); 
x_dot_0(2) = omega*(1/2)*(1-cosh(omega*T))/(sinh(omega*T)); 
xd1 = omega*(1/2)*(1+cosh(omega*T))/(sinh(omega*T)); %the desired velocity in x direction before T changes
X0d = x_dot_0(1);
Y0d = x_dot_0(2);
y0 = [-1/2;1/2;X0d;Y0d]+distb;
Zs_prev = find_zg(-1); %because for the first step, the position of the swing foot for periodic motion is -1 along x axis
phi_mid = 0.6;
%-----------------------------------------------

Y_prev = [0 0];   %to record X,Y at the end of the last step
Y_show = []; 
t_show = [];
foot_show = [];
step_show = [0];
duration_show = [];
Y_dot_show = [];
Xs_show = [];
Ys_show = [];
Zs_show = [];
step_time = [];
length_prev = 0;
s_show = cell(N_step,1);
eig_valShow = [];
kskd_show = [];
CoM_target = [];

Xt = cell(1,N_step);
Foot_t = cell(1,N_step);
%-----for the first step----------------
%%%with S. Kajita's method%%%%%%%%%%
if applyKajita==1
    yd = 1/2;
    xd = 1/2;
    vx = xd*(Ch+1)/(Sh/omega);
    vy = yd*(Ch-1)/(Sh/omega);
    xi = 0;
    yi = 1/2+disbyi;
    xpi = xi*(Ch+1)/(Sh/omega);
    ypi = -yi*(Ch-1)/(Sh/omega);
    Dint=a*(Ch-1)^2+b*(Sh/Tc)^2;
    pxe=-a*(Ch-1)/Dint*(xd-Ch*xi-Tc*Sh*xpi)-b*Sh/(Tc*Dint)*(vx-Sh/Tc*xi-Ch*xpi);
    pye=-a*(Ch-1)/Dint*(yd-Ch*yi-Tc*Sh*ypi)-b*Sh/(Tc*Dint)*(vy-Sh/Tc*yi-Ch*ypi);
    y0(1) = -pxe;
    y0(2) = yi-pye;
    % y0(3) = Y(end,3)+0.8;
    y0(3) = xpi;
    y0(4) = ypi;
    Y_dot_show_end = [xpi ypi];
    pos_foot = [pxe pye 0];
    Y_show_origin = [xi yi];
else
    Y_dot_show_end = [y0(3) y0(4)];
    pos_foot = [0 0 0];
    Y_show_origin = [0 1/2];
end
%----------------------------------------

%-------calculate eigen values--------------------------
Xf = 1/2; %the position of CoM at the end of a step for cyclic motion
Yf = 1/2;
mark = [];
%----------------------------------------------
    

mark_j = 0;
Y_save = cell(1,N_step);
t_save = cell(1,N_step);
phi = cell(1,N_step);
for i = 1:N_step
    Current_step = i;
    
    %% if the desired step duation is changed
    if i>15 && changeT == 1
        T=0.8;
        k_dx = 0.04;
        kv = k_dx;
        xd2 = omega*(1/2)*(1+cosh(omega*T))/(sinh(omega*T));
        Ch = cosh(T*omega);
        Sh = sinh(T*omega);
    end
    %%
    
    %T have changed, so the desired velocity should be changed
    X0d = omega*(1/2)*(1+cosh(omega*T))/(sinh(omega*T));
     
    %the first step need to finish the desired T, if not the gait will
    %diverge
    
    if isConstantT==1 && groundType == 0
        [t,Y,alpha] = singlesupport_constantPace(y0);
    else
        if (i==1 || i==N_step)&&applyKajita==1
            [t,Y,alpha] = singlesupport_constantPace(y0);
        else
            [t,Y,alpha] = singlesupport_Zsis0(y0,pos_foot,Zs_prev);
        end
    end
    Y_save{i} = Y;
    t_save{i} = t;
    
    Length = length(Y(:,1));
    
    %phi I proposed again
    if ((i == 1 || i==N_step)&&applyKajita==1)||isConstantT == 1
        for j = 1:Length
            phi{i}(j) = t(j)/T;
        end
    else
        for j = 1:Length
            phi{i}(j) = cal_phi(Y(j,:),y0);
        end
    end
    Xs_f = zeros(1,Length);
    Ys_f = zeros(1,Length);
    Xs = zeros(1,Length);
    Ys = zeros(1,Length);
    Zs = zeros(1,Length);
    
    for j=1:Length
        if applyKajita==1
            if i == 1
                Xs_f(j) = (1-kS)*(Y(j,1)-1/2)+1;
                Xs_prev = Xs_f(end);
                Xs_i = 0;
                Ys_f(j) = (1-kD)*(Y(j,2)-1/2)+1;
                Ys_prev = Ys_f(end);
                Ys_i = 1;
            elseif (i<(N_step-1)&&1<i)
                %         else
                Xs_f(j) = (1-kS)*(Y(j,1)-1/2)+1;
                Xs_i = -Xs_prev;
                Ys_f(j) = (1-kD)*(Y(j,2)-1/2)+1;
                Ys_i = Ys_prev;
                %         end
            elseif i==(N_step-1)
                Xs_cp = Y(j,1) + Y(j,3)/omega;
                Ys_cp = Y(j,2) + Y(j,4)/omega;
                xd = 0;
                yd = 1/2;
                vx = 0;
                vy = yd*(Ch-1)/(Sh/omega);
                xi = Y(end,1)-1;
                yi = 1-Y(end,2);
                xpi = Y(end,3);
                ypi = -Y(end,4);
                Dint=a*(Ch-1)^2+b*(Sh/Tc)^2;
                pxe=-a*(Ch-1)/Dint*(xd-Ch*xi-Tc*Sh*xpi)-b*Sh/(Tc*Dint)*(vx-Sh/Tc*xi-Ch*xpi);
                pye=-a*(Ch-1)/Dint*(yd-Ch*yi-Tc*Sh*ypi)-b*Sh/(Tc*Dint)*(vy-Sh/Tc*yi-Ch*ypi);
                Xs_f(j) = 1+pxe;
                Xs_i = -Xs_prev;
                Ys_f(j) = 1-pye;
                Ys_i = Ys_prev;
            elseif i==N_step
                Xs_f(j) = 0;
                Xs_i = -Xs_prev;
                Ys_f(j) = 1;
                Ys_i = Ys_prev;
            end
        else %Kajita not applied
            if i == 1
                Xs_f(j) = (1-kS)*(Y(j,1)-1/2)+1;
                Xs_prev = Xs_f(end);
                Xs_i = -1;
                Ys_f(j) = (1-kD)*(Y(j,2)-1/2)+1;
                Ys_prev = Ys_f(end);
                Ys_i = 1;
            else
                Xs_f(j) = (1-kS)*(Y(j,1)-1/2)+1;
                Xs_i = -Xs_prev;
                Ys_f(j) = (1-kD)*(Y(j,2)-1/2)+1;
                Ys_i = Ys_prev;
            end
        end
        
        Xs(j) = -2*(Xs_f(j)-Xs_i)*phi{i}(j)^3+3*(Xs_f(j)-Xs_i)*phi{i}(j)^2+Xs_i;
        Ys(j) = -2*(Ys_f(j)-Ys_i)*phi{i}(j)^3+3*(Ys_f(j)-Ys_i)*phi{i}(j)^2+Ys_i;
        
        if phi{i}(j)<phi_mid
            a_zs = (-(2*zs_mid)/(phi_mid)^3);
            b_zs = ((3*zs_mid)/(phi_mid)^2);
            c_zs = 0;
            d_zs = 0;
            Zs(j) = a_zs*phi{i}(j)^3+b_zs*phi{i}(j)^2+c_zs*phi{i}(j)+d_zs;
        else
            a_zs = -zs_mid*(-1+2*phi_mid)/(phi_mid-1)^2;
            b_zs = (2*zs_mid*phi_mid)/(phi_mid-1)^2;
            c_zs = -zs_mid/(phi_mid-1)^2;
            Zs(j) = c_zs*phi{i}(j)^2+b_zs*phi{i}(j)+a_zs;
        end
        
    end
    
    Xs_prev = Xs(end);
    Ys_prev = Ys(end);
    
    
    Y_show_origin = [Y_show_origin; Y(end,1:2)];
    Y_dot_show_end = [Y_dot_show_end; Y(end,3:4)];
    t_show = [t_show; t+t_prev];
    step_time = [step_time;Length+length_prev];
    t_prev = t_prev + t(end);
    step_show = [step_show; i];
    
    Y_show_X = Y(:,1) + ones(size(Y,1),1)*pos_foot(1);
    Y_show_Y = (Y(:,2))*inverse + ones(size(Y,1),1)*pos_foot(2);
    
    Y_show = [Y_show; Y_show_X Y_show_Y ones(size(Y,1),1)*pos_foot]; %position of CoM and position of stance foot
    Xt{i} = [Y_show_X Y_show_Y ones(size(Y,1),1)*pos_foot];
    Foot_t{i} = pos_foot;
    Xs = Xs';
    Ys = Ys';
    Zs = Zs';
    
    Xs_global = Xs+ones(size(Y,1),1)*pos_foot(1);
    Ys_global = pos_foot(2)*ones(length(Ys),1)+inverse*Ys;
    Zs_global = Zs+ones(length(Zs),1)*Zs_prev;
    
   
    Xs_show = [Xs_show;Xs_global];
    Ys_show = [Ys_show;Ys_global];
    Zs_show = [Zs_show;Zs_global];

    Zs_prev = pos_foot(3);
    
    
    y0 =[Y(end,1)-Xs(end);Ys(end)-Y(end,2);Y(end,3);Y(end,4)*(-1)] ;
    
    pos_foot(1) = pos_foot(1)+Xs(end);
    pos_foot(2) = pos_foot(2)+Ys(end)*inverse;
    pos_foot(3) = find_zg(pos_foot(1));
    
    inverse = -inverse;
    Y_prev = Y_show(end,1:2);
    length_prev = step_time(end);
    %     pos_foot_prev = pos_foot;
    %     Xi = -Xs(end);
    mark = [mark; inverse*ones(size(Y,1),1)];%used for changing the color of the two legs during walking
    
    
    h_com = z_0-pos_foot(3);
    omega = sqrt(g/h_com);
    
    if i~=N_step
        clear Zs phi0 Xs_f Xs_i Ys_f Ys_i Ys Xs_global Xs;
    end
    
    

end
% dataname = ['datatestcase',num2str(testcase)];
% save(dataname,'Y_show_origin', 'step_show','Xt','Foot_t','Y_dot_show_end');
if Ani == 1
    figure(22)
    axis([-0.3 0.3 0.06 0.11]);
    xlabel('x[m]');
    ylabel('y[m]');
    pause
    plot(0.15,0.075);
    draw_slope(S/2,D/2,y0,1);
    hold on;
    for i = 2:N_step-1
        axis([-0.3 0.3 0.06 0.11]);
        plot(Y_save{i}(:,1)*S,Y_save{i}(:,2)*D);
        axis([-0.3 0.3 0.06 0.11]);
        hold on;
        pause(0.5)
    end
    pause;
    
    drawCompase(Y_show,Xs_show,Ys_show,Zs_show,mark,step_time,N_step);
end

figure(2)
for ii = 1:N_step
    plot(Xt{ii}(:,1)*S,Xt{ii}(:,2)*D,'k');
    hold on;
    plot(Xt{ii}(1,1)*S,Xt{ii}(1,2)*D,'*k');
    hold on;
    plot(Foot_t{ii}(1)*S,Foot_t{ii}(2)*D,'ob');
    hold on;
end



if DRAW_ENABLE == 1
    figure(1)
    % subplot(2,1,1)
    plot(S*Y_show(:,1), D*Y_show(:,2), 'k');
    %axis([-1 11 0.2 1.6]);
    grid on;
    xlabel('$x[m]$','Interpreter','latex');
    ylabel('$y[m]$','Interpreter','latex');
    xlim([-S/2 S*N_step]);
    
    
    drawref = 1;
    
    if N_step>2
        figure(5)
        subplot(2,2,1);
        xlim([0 N_step]);
        plot(step_show,S*Y_show_origin(:,1),'.-k');
        hold on;
        if drawref == 1
            plot([0 N_step],[S/2 S/2],'--b');
            legend('the real value','the fixed value')
        end
        xlabel('$step$','Interpreter','latex');
        ylabel('$x[m]$','Interpreter','latex');
        grid on;
        hold on;
        subplot(2,2,2);
        xlim([0 N_step]);
        plot(step_show,D*Y_show_origin(:,2),'.-k');
        hold on;
        if drawref == 1
            plot([0 N_step],[D/2 D/2],'--b');
            legend('the real value','the fixed value')
        end
        xlabel('$step$','Interpreter','latex');
        ylabel('$y[m]$','Interpreter','latex');
        grid on;
        hold on;
        
        subplot(2,2,3);
        xlim([0 N_step]);
        hh1 = plot(step_show,S*Y_dot_show_end(:,1),'.-k');
        hold on;
        if N_step>15 && changeT==1
            hh2 = plot([0 15], [S*xd1 S*xd1],'--b');
            hold on;
            plot([15 N_step], [S*xd2 S*xd2],'--b');
            hold on;
            plot([15 15], [S*xd1 S*xd2],'--b');
            hold on;
        else
            hh2 = plot([0 N_step],[S*xd1 S*xd1],'--b');
        end
        xlabel('$step$','Interpreter','latex');
        ylabel('$\dot{x}[m/s]$','Interpreter','latex');
        grid on;
        hold on;
        legend([hh1,hh2],'the real value','the fixed value')

        subplot(2,2,4);
        xlim([0 N_step]);
        plot(step_show,D*Y_dot_show_end(:,2),'.-k');
        hold on;
        if ~(N_step>15 && changeT==1)
            plot([0 N_step],[-D*Y0d -D*Y0d],'--b');
            legend('the real value','the fixed value')
        else
            legend('the real value')
        end
        xlabel('$step$','Interpreter','latex');
        ylabel('$\dot{y}[m/s]$','Interpreter','latex');
        grid on;
        ylim([-0.26 0.3]);
        
        
        duration_show = zeros(1,N_step);
        for i = 1:N_step
            duration_show(i) = t_save{i}(end);
        end
        
        
        figure(14)
        % subplot(2,1,2)
        hh1=plot(step_show(2:end),duration_show,'.-k','LineWidth',1);
        hold on;
        for i=1:N_step
            %     plot(step_show(i+1),duration_show(i),'*b')
            hold on
        end
        grid on;
        xlabel('$step$','Interpreter','latex');
        ylabel('$T[s]$','Interpreter','latex');
        hold on;
        if N_step>15 && changeT
            h2=plot([0 15], [0.6 0.6],'--k');
            hold on;
            plot([15 N_step], [0.8 0.8],'--k');
            hold on;
            plot([15 15], [0.6 0.8],'--k');
            hold on;
        else
            h2=plot([0 N_step],[0.6 0.6],'--k');
        end
        xlim([1 N_step]);
        % ylim([0.5 0.85]);
        hold on;
        % text(0,0.52,'$T=0.1$','Interpreter','latex','horiz','center');
%         legend([hh1,h2],'the simulated duration','desired duration','Interpreter','latex');
        hold on;
        % legend(h2,'desired duration');
    end
end











