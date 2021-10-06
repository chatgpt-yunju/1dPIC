%********renormalization*********%
function [prm,ren]=renorm(prm)
   ren.x=prm.dx             %位移
   ren.t=prm.dt/2           %半个步长  
   ren.v=ren.x/ren.t        %网格距/半个步长 %---速度---% 
   ren.e=ren.x/(ren.t^2)    %加速度 
   ren.b=1.0/ren.t          %半步长倒数 
   ren.j=ren.x/(ren.t^3)    %加速度/半个步长
   ren.r=1.0/(ren.t^2)      %
   ren.g=(ren.x^2)/(ren.t^4)%
   
   prm.cv=prm.cv/ren.v
   prm.wc=prm.wc*ren.t
   
   prm.wp=prm.wp   .* ren.t
   prm.vpa=prm.vpa ./ren.v
   prm.vpe=prm.vpe ./ren.v
   prm.vd=prm.vd ./ren.v

   prm.vmax=prm.vmax ./ren.v
   
   prm.wj=prm.wj*ren.t      % 外部电流的频率jz
   prm.ajamp=prm.ajamp/ren.j
end