global C CC DD kv 
switch testcase
    case 1 %simulation 2.5.2 (1)
        isConstantT=1;
        applyKajita = 0; %0: periodic motion; 1: integrated with the first step and last step by Kajita's method
        groundType = 0; %0: flat ground; 1: slope; 2: sinusoidal 3: steps
        changeT = 0;
        dz_t = -0.005; %the downword veolicity of swing foot at the end of a step
        zs_mid = 0.2; %the maximum height of swing foot
        kS = 0;
        kD = 0;
        C = 3;
        DD = -0.5; %CC and DD are defined to make \phi monotonic
        CC = 0;
        T = 0.6;
        kv = 0.08;
        distb = [0.001;0.001;0;0];
        N_step = 5;
%         distb = [0 0 0 0]';
    case 2 %simulation 2.5.2 (2)
        isConstantT=1;
        applyKajita = 0; %0: periodic motion; 1: integrated with the first step and last step by Kajita's method
        groundType = 0; %0: flat ground; 1: slope; 2: sinusoidal 3: steps
        changeT = 0;
        dz_t = -0.005; %the downword veolicity of swing foot at the end of a step
        zs_mid = 0.2; %the maximum height of swing foot
        kS = 0;
        kD = 0;
        C = 3;
        DD = -0.5; %CC and DD are defined to make \phi monotonic
        CC = 0;
        T = 0.6;
        kv = 0.08;
        distb = [0;0;0;0];
        N_step = 5;
    case 3 %simulation 2.6.5
        isConstantT=0;
        applyKajita = 1; %0: periodic motion; 1: integrated with the first step and last step by Kajita's method
        groundType = 0; %0: flat ground; 1: slope; 2: sinusoidal 3: steps
        changeT = 0;
        dz_t = -0.1; %the downword veolicity of swing foot at the end of a step
        zs_mid = 0.2; %the maximum height of swing foot
        kS = 0;
        kD = 1;
        C = 3;
        DD = -0.5; %CC and DD are defined to make \phi monotonic
        CC = 0;
        T = 0.6;
        kv = 0;
        distb = [0;0;0;0];
        N_step = 15;
        disbyi = 0.05;
    case 4 %simulation 2.6.5
        isConstantT=0;
        applyKajita = 1; %0: periodic motion; 1: integrated with the first step and last step by Kajita's method
        groundType = 0; %0: flat ground; 1: slope; 2: sinusoidal 3: steps
        changeT = 1;
        dz_t = -0.1; %the downword veolicity of swing foot at the end of a step
        zs_mid = 0.2; %the maximum height of swing foot
        kS = 0;
        kD = 1;
        C = 3;
        DD = -0.5; %CC and DD are defined to make \phi monotonic
        CC = 0;
        T = 0.6;
        kv = 0.08;
        distb = [0;0;0;0];
        N_step = 30;
        disbyi = 0.05;
     case 5 %simulation on sin ground ks=0 kd=1
        isConstantT=0;
        applyKajita = 0; %0: periodic motion; 1: integrated with the first step and last step by Kajita's method
        groundType = 2; %0: flat ground; 1: slope; 2: sinusoidal 3: steps
        changeT = 0;
        dz_t = -0.1; %the downword veolicity of swing foot at the end of a step
        zs_mid = 0.2; %the maximum height of swing foot
        kS = 0;
        kD = 1;
        C = 4;
        DD = -0.4; %CC and DD are defined to make \phi monotonic
        CC = 0;
        T = 0.6;
        kv = 0.08;
        distb = [0;0;0;0];
        N_step = 30;
    case 6 %simulation on sin ground ks=0 kd=0
        isConstantT=0;
        applyKajita = 0; %0: periodic motion; 1: integrated with the first step and last step by Kajita's method
        groundType = 2; %0: flat ground; 1: slope; 2: sinusoidal 3: steps
        changeT = 0;
        dz_t = -0.1; %the downword veolicity of swing foot at the end of a step
        zs_mid = 0.2; %the maximum height of swing foot
        kS = 0;
        kD = 0;
        C = 1.5;
        DD = -0.4; %CC and DD are defined to make \phi monotonic
        CC = 0;
        T = 0.6;
        kv = 0.06;
        distb = [0;0;0;0];
        N_step = 30;
    case 7 %test
        isConstantT=0;
        applyKajita = 0; %0: periodic motion; 1: integrated with the first step and last step by Kajita's method
        groundType = 0; %0: flat ground; 1: slope; 2: sinusoidal 3: steps
        changeT = 0;
        dz_t = -0.1; %the downword veolicity of swing foot at the end of a step
        zs_mid = 0.2; %the maximum height of swing foot
        kS = 0;
        kD = 0;
        C = 6;
        DD = -0.4; %CC and DD are defined to make \phi monotonic
        CC = 0;
        T = 0.7;
        kv = 0.06;
        distb = [0;0;0;0];
        N_step = 1;
    
        
end