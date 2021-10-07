classdef Particle < handle
   
    properties
        x double    %粒子坐标
        vx double
        vy double
        vz double
    end
    
    methods
        function obj=Particle(prm)
           %Initialtion
           obj.x =zeros(prm.npt,1);
           obj.vx=zeros(prm.npt,1);
           obj.vy=zeros(prm.npt,1);
           obj.vz=zeros(prm.npt,1);
            
           %粒子初始化
           n2=0;
           for k=1:prm.ns
               n1=n2;
               n2=n2+prm.np(k);
               
               phi = pi/180.0*prm.pch(k); %与平行方向的夹角，俯仰角
               vdpa = prm.vd(k)*cos(phi); %漂移速度的平行分量
               vdpe = prm.vd(k)*sin(phi); %漂移速度的垂直分量
            
               xx = 0;
               nphase = 1;
               phase = 0;
            
               %对每一个粒子进行操作
               for i=(n1+1):n2
                   if mod(i,nphase) == 0
                      phase = 2*pi*rand;            %随机粒子的相位
                      xx = xx+ prm.nx/prm.np(k);    %等间距分配每一个粒子
                   else
                      phase = phase + 2*pi/nphase;  %？
                   end 
               
                   obj.x(i) = xx;                   %初始化粒子坐标
                   if obj.x(i) < 0.0
                      obj.x(i) = obj.x(i) + prm.slx;%slx网格点数=nx
                   end
                   if obj.x(i) >= prm.slx
                      obj.x(i) = obj.x(i) - prm.slx;%保证粒子坐标在网格内
                   end

                   uxi = prm.vpa(k)*randn + vdpa;           %粒子速度的平行分量+漂移速度的平行分量             
                   uyi = prm.vpe(k)*randn + vdpe*cos(phase);  
                   uz  = prm.vpe(k)*randn + vdpe*sin(phase);

                   % rotation to the direction of the magnetic field
                   % 磁场对速度的转向
                   costh = cos(pi/180*prm.angle); %costh=1
                   sinth = sin(pi/180*prm.angle); %sinth=0
                   ux = costh*uxi - sinth*uyi;    %平行磁场方向的速度还是磁场方向  
                   uy = sinth*uxi + costh*uyi;    %？

                   %?
                   g = prm.cv /sqrt(prm.cs + ux*ux + uy*uy + uz*uz);
                   obj.vx(i) = ux*g;      
                   obj.vy(i) = uy*g;
                   obj.vz(i) = uz*g;
               end
           end
        end    
    end
end