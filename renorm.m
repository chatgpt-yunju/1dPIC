%********renormalization归一化系数ren.*=实际/模拟（归一化指的是网格距归一，其他参数并不归一而是等比例变化）*********%
function [prm,ren]=renorm(prm)
   ren.x=prm.dx             %网格距系数
   ren.t=prm.dt/2           %时间步长系数  
   ren.v=ren.x/ren.t        %速度系数 
   ren.e=ren.x/(ren.t^2)    %电场系数 
   ren.b=1.0/ren.t          %磁场系数 
   ren.j=ren.x/(ren.t^3)    %电流密度系数
   ren.r=1.0/(ren.t^2)      %电荷密度系数
   ren.s=(ren.x^2)/(ren.t^4)%能量缪爹系数
   
   prm.cv=prm.cv/ren.v      %归一化后的光速
   prm.wc=prm.wc*ren.t      %归一化后的回旋频率
   
   prm.wp=prm.wp   .*ren.t  %归一化后的等离子体频率 
   prm.vpa=prm.vpa ./ren.v  %归一化后的平行速度
   prm.vpe=prm.vpe ./ren.v  %归一化后的垂直速度
   prm.vd=prm.vd   ./ren.v  %归一化后的漂移速度

   prm.vmax=prm.vmax ./ren.v%归一化后的速度上限
   
   prm.wj=prm.wj*ren.t      %归一化的外部电流的频率jz
   prm.ajamp=prm.ajamp/ren.j%归一化的外部电流的振幅ajamp


end