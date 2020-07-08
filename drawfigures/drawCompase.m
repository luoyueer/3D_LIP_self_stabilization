function drawCompase(Y_show,Xs_show,Ys_show,Zs_show,mark,step_time,N_step)
%Y_show: (X,Y,X position of stance foot, Y position of stance foot)
%Xs_show: x position of swing foot
%Ys_show: y position of swing foot
%Zs_show: y position of swing foot
%mark: to mark which one is the stance foot in order to use different color
%step_time:
%N_step: the total number of steps
global C z_0 S D N_step ZG XG YG
bVideo = 1;

DRAW_ENABLE = 1;
testcase = 3; %2 for 2D, 3 for 3D

lengthS = size(Y_show,1);

density = 100;
density2 = 200;

lengthG = length(XG);
i = 1;
% for i = 1:lengthG
%     if (i == 1 || mod(i,density2)==0||i==lengthG)
%     zg(j) = ZG(1,i);
%     xg(j) = XG(i);
%     yg(j) = YG(i);
%     j = j+1;
%     end
% end

fig15 = figure(15);
fig15size = get(fig15,'position');
% set(gcf,'Position',[fig15size(1) fig15size(2) fig15size(3)/2 fig15size(4)*1.2]);
if DRAW_ENABLE == 1
    if testcase == 3
        subplot(2,1,1)
    surf(S*XG,D*YG,ZG);
%     colormap(parula(5))
    colormap summer
    shading interp 
    hold on;
    h1_3D = plot3([S*Y_show(i,1) S*Xs_show(i)],[D*Y_show(i,2) D*Ys_show(i)],[1 Zs_show(i)],'r-','LineWidth',2);
    h2_3D = plot3([S*Y_show(i,1) S*Y_show(i,3)],[D*Y_show(i,2) D*Y_show(i,4)],[z_0 Y_show(i,5)],'b-','LineWidth',2); %stance foot;
    h3_3D = plot3(S*Xs_show(i),D*Ys_show(i),Zs_show(i),'.k');
    h4_3D = plot3(S*Y_show(i,3),D*Y_show(i,4),Y_show(i,5),'.k');
    xlabel('$x$','Interpreter','latex');
    ylabel('$y$','Interpreter','latex');
    zlabel('$z$','Interpreter','latex');
    axis equal
    axis([-0.5 N_step*S -1 2]);
    grid on;
    fig2 = subplot(2,1,2);
    fig2position = get(fig2,'position');
    
%     axes('position',[fig2position(1)  fig2position(2) fig2position(3)-0.1  fig2position(4)]); %[left bottom witdth height]
      plot(S*XG,ZG,'k');
       hold on;
        h1_2D =  plot([S*Y_show(i,1) S*Xs_show(i)],[z_0 Zs_show(i)],'r-','LineWidth',2);
        h2_2D =  plot([S*Y_show(i,1) S*Y_show(i,3)],[z_0 Y_show(i,5)],'b-','LineWidth',2);
        axis equal;
        axis([-0.5 N_step*S -0.5 2]);
        xlabel('$x$','Interpreter','latex');
        ylabel('$z$','Interpreter','latex');
        grid on;
%         set(fig2,'Position',[fig2position(1) fig2position(2) fig2position(3)/2 fig2position(4)*1.2]);
        
  indexprint = 1;  
    pause
    for i = 1:1:lengthS
            if (i == 1 || mod(i,density)==0||i==lengthS)
                %%
             subplot(2,1,1)
    %             hold on;
                if mark(i) == 1
                    set(h1_3D,'xdata',[S*Y_show(i,1) S*Xs_show(i)],'ydata',[D*Y_show(i,2) D*Ys_show(i)],'zdata',[1 Zs_show(i)],'color','r');
                    set(h2_3D,'xdata',[S*Y_show(i,1) S*Y_show(i,3)],'ydata',[D*Y_show(i,2) D*Y_show(i,4)],'zdata',[z_0 Y_show(i,5)],'color','b');
                    set(h3_3D,'xdata',S*Xs_show(i),'ydata',D*Ys_show(i),'zdata',Zs_show(i));
                    set(h4_3D,'xdata',S*Y_show(i,3),'ydata',D*Y_show(i,4),'zdata',Y_show(i,5));
                else
                    set(h1_3D,'xdata',[S*Y_show(i,1) S*Xs_show(i)],'ydata',[D*Y_show(i,2) D*Ys_show(i)],'zdata',[1 Zs_show(i)],'color','b');
                    set(h2_3D,'xdata',[S*Y_show(i,1) S*Y_show(i,3)],'ydata',[D*Y_show(i,2) D*Y_show(i,4)],'zdata',[z_0 Y_show(i,5)],'color','r');
                    set(h3_3D,'xdata',S*Xs_show(i),'ydata',D*Ys_show(i),'zdata',Zs_show(i));
                    set(h4_3D,'xdata',S*Y_show(i,3),'ydata',D*Y_show(i,4),'zdata',Y_show(i,5));
                end;
                hold on;
               
%                 axis equal
                %                     axis([S*Y_show(i,1)-1 S*Y_show(i,1)+1 -4*D 4*D -0.2 1.5]);
%                 axis([-1 N_step*1 -0.5 2]);
                
%                 figure_FontSize=14;
%                     axis([-1 N_step*1 -0.5 2]);
%                     hold off;
%%
                   subplot(2,1,2)
%                    axes('position',[fig2position(1)  fig2position(2) fig2position(3)-0.1  fig2position(4)]);
%                    axes('position',[fig2position(1)  fig2position(2) fig2position(3)-0.1  fig2position(4)-0.3]) %[left bottom witdth height]
                   if mark(i) == 1
                       set(h1_2D,'xdata',[S*Y_show(i,1) S*Xs_show(i)],'ydata',[z_0 Zs_show(i)],'color','r');
                       set(h2_2D,'xdata',[S*Y_show(i,1) S*Y_show(i,3)],'ydata',[z_0 Y_show(i,5)],'color','b');
                       
                   else
                       set(h1_2D,'xdata',[S*Y_show(i,1) S*Xs_show(i)],'ydata',[z_0 Zs_show(i)],'color','b');
                       set(h2_2D,'xdata',[S*Y_show(i,1) S*Y_show(i,3)],'ydata',[z_0 Y_show(i,5)],'color','r');
                   end;
                   
%                    axis equal
                   
                   
%                    axis([Y_show(i,1)-1 Y_show(i,1)+1 -0.5 2]);
%                    axes('position',[.1  .1  .8  .6]) %[left bottom witdth height]
                   
                   
                   drawnow;
                   if (i == 1 || mod(i,300)==0||i==lengthS)&&bVideo
                   filename = ['D:\lipwalking\walking_new'    num2str(indexprint) '.jpeg' ];
%                    print(15,'-djpeg',filename);
                   indexprint = indexprint + 1;
                   end;
         end;
%             hold off;

    %         plot3(Y_show(i,1),Y_show(i,2),0,'r.'); %the center of mass
    %         hold on;
%     pause(0.001);
        end;
    else %testcase = 2
  
        figure(15)
%         hold on;
%         figure(15)
            plot(XG,ZG,'k');
            hold on;
        h1 =  plot([Y_show(i,1) Xs_show(i)],[z_0 Zs_show(i)],'r-');
        h2 =  plot([Y_show(i,1) Y_show(i,3)],[z_0 Y_show(i,5)],'b-');
        for i = 1:1:lengthS
            
            set(gcf,'closerequestfcn','')
        if (i == 1 || mod(i,density)==0||i==lengthS)
            
            
            if mark(i) == 1
                

               set(h1,'xdata',[Y_show(i,1) Xs_show(i)],'ydata',[z_0 Zs_show(i)]);
               set(h2,'xdata',[Y_show(i,1) Y_show(i,3)],'ydata',[z_0 Y_show(i,5)]);
                
%                plot([Y_show(i,1) Xs_show(i)],[z_0 Zs_show(i)],'r-');
%                 hold on;
%                 plot([Y_show(i,1) Y_show(i,3)],[z_0 Y_show(i,5)],'b-'); %f means fix leg
% %                 hold on;
               
            else
                set(h1,'xdata',[Y_show(i,1) Xs_show(i)],'ydata',[z_0 Zs_show(i)]);
               set(h2,'xdata',[Y_show(i,1) Y_show(i,3)],'ydata',[z_0 Y_show(i,5)]);
               
%                 plot([Y_show(i,1) Xs_show(i)],[z_0 Zs_show(i)],'b-');
%                 hold on;
%                 plot([Y_show(i,1) Y_show(i,3)],[z_0 Y_show(i,5)],'r-'); %f means fix leg
%                 hold on;
            end;

                xlabel('x');
                ylabel('z');
                axis equal
                axis([-1 N_step*1 -0.5 2]);
                grid on;
%                 
                pause(0.01);
                drawnow;
%                 hold off;
                
        hold on;
     end;
     
%        hold off;

     set(gcf,'closerequestfcn','closereq')  
       
       
%        figure(15)
%             plot(xg,zg,'k');
%             hold on;
        end

        
        
        
    end
end
  
end