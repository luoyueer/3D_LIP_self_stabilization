function ZG = groundGenerater
global groundType N_step XG YG ZG
%        0 0 0 0 0 0 0 0 0    
% ZG = [ 0 0 0 0 0 0 0 0 0 ]   ? y direction
%        0 0 0 0 0 0 0 0 0     
%        ? x direction
ZG = zeros(length(YG),length(XG));
% heightSin = 0.03; %works for kd=1;
heightSin = 0.035;
omegasin = 0.8; %should be omega_wanted *S
switch groundType
    case 0
        ZG=zeros(length(YG),length(XG));
    case 1 %slope
        for i = 1:length(XG)
            ZG(:,i) = ones(length(YG),1)*0.01*XG;
        end;
    case 2 %sinoud
        for i = 389:1140
%             ZG(:,i) = ones(length(YG),1)*heightSin*cos(3.14*omegasin*XG(i)-2*3.14); 
%             ZG(:,i) = ones(length(YG),1)*heightSin*cos(3.14*omegasin*(XG(i))); %the one used in the thesis
            ZG(:,i) = ones(length(YG),1)*heightSin*sin(3.14*omegasin*(XG(i)-XG(389))); 
%             0.07
        end;
        for i = 1140:length(XG)
            ZG(:,i)=zeros(length(YG),1);
        end
    case 3
        Stepheight = 0.03;
            for i = 310:500
                ZG(:,i)=-ones(length(YG),1)*Stepheight;
            end
            
            for i = 501: 700
                ZG(:,i)=-ones(length(YG),1)*Stepheight*2;
            end
            
            for i = 701:length(XG)
                ZG(:,i)=-ones(length(YG),1)*Stepheight*3;
            end



    otherwise
        fprintf('Invalid ground type\n' );
end
end