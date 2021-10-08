%********输入参数*********%
classdef Parameters < handle

    properties
        %网格距
        dx double {mustBePositive}
        %时间间隔
        dt double {mustBePositive}
        %网格点数
        nx double {mustBePositive}
        %时间步数  
        ntime double {mustBeInteger,mustBePositive}
        % number of outputs
        nplot double {mustBeInteger, mustBePositive}
        %光速
        cv double {mustBePositive}
        %粒子的回旋频率
        wc double {mustBeReal}
        %外部电流的振幅jz
        ajamp double {mustBeNonnegative}
        %电场振幅
        eamp double {mustBePositive}
        %maximum range for plotting the electric field
        emax double {mustBeReal}
        %磁场的振幅
        bamp double {mustBePositive}
        %maximum range for plotting the magnetic field
        bmax double {mustBeReal}
        % control parameter for electrostatic option
        iex double {mustBeMember(iex,[0,1,2])}
        % maximum range for plotting velocity
        vmax double {mustBeReal}
        %number of bins for deriving the particle distribution function
        nv double {mustBeInteger}
        % 外部电流的频率jz
        wj double {mustBeNonnegative}
        % 粒子种类的数量
        ns double {mustBeInteger, mustBePositive}
        % number of particles for species
        np double {mustBeInteger, mustBePositive}
        % plasma frequency of species
        wp double {mustBePositive}
        % charge-to-mass ratio of species
        qm double {mustBeReal}
        % parallel thermal velocity of species
        vpa double {mustBePositive}
        % perpendicular thermal velocity of species
        vpe double {mustBePositive}
        % drift velocity of species
        vd double {mustBeNonnegative}
        % pitch angle (degrees) of species
        pch double {mustBeGreaterThanOrEqual(pch,0), mustBeLessThanOrEqual(pch,180)}
        %
        icolor
        %
        iparam
        %
        diagtype
        angle  double {mustBeGreaterThanOrEqual(angle,0), mustBeLessThanOrEqual(angle,90)}
    end
   
     % Actually I am not sure if this should be calculated only once. It
   % might be better. 
   % For example, in the initialization part, slx has been used several 
   % times inside the nested loop. q is used in function charge.
   properties (Dependent)
      slx
      npt
      nxp1
      nxp2
      X1
      X2
      X3
      cs
      tcs
      q
      mass
      rho0
      bx0
      by0
      ifdiag
   end
   
   methods
      function obj = Parameters(fname)
         % read input parameters and set values
         
         if nargin==0
            fname = 'input_tmp.dat';  % default input filename
         end
         
         try
            fid = fopen(fname);
            C = textscan(fid,'%s%s','delimiter','=;','commentstyle','matlab');
            [StrName,StrValue] = C{:};
            fclose(fid);
         catch
            errordlg(sprintf('Can''t open input file: %s',fname),'Error')
         end
         
         for l=1:length(StrName)
            value = eval(char(StrValue(l)));
            prmname = strtrim(StrName{l});
            switch prmname
               case 'dx'
                  obj.dx = value;
               case 'dt'
                  obj.dt = value;
               case 'nx'
                  obj.nx = value;
               case 'ntime'
                  obj.ntime = value;
               case 'nplot'
                  obj.nplot = value;
               case 'cv'
                  obj.cv = value;
               case 'wc'
                  obj.wc = value;
               case 'ajamp'
                  obj.ajamp = value;
               case 'eamp'
                  obj.eamp = value;
               case 'emax'
                  obj.emax = value;
               case 'bamp'
                  obj.bamp = value;
               case 'bmax'
                  obj.bmax = value;
               case 'iex'
                  obj.iex = value;
               case 'vmax'
                  obj.vmax = value;
               case 'nv'
                  obj.nv = value;
               case 'wj'
                  obj.wj = value;
               case 'ns'
                  obj.ns = value;
               case 'np'
                  obj.np = value;
               case 'wp'
                  obj.wp = value;
               case 'qm'
                  obj.qm = value;
               case 'vpa'
                  obj.vpa = value;
               case 'vpe'
                  obj.vpe = value;
               case 'vd'
                  obj.vd = value;
               case 'pch'
                  obj.pch = value;
               case 'icolor'
                  obj.icolor = value;
               case 'iparam'
                  obj.iparam = value;
               case 'diagtype'
%                   obj.diagtype = value;
                  obj.diagtype = [1, 4, 5,  10, 11.000000,12,15, 23.000000, 25.000000, 30.000000];
               case 'angle'
                  obj.angle = value;
               otherwise
                  error('Plese check input parameter %s.',prmname)
            end
         end
      end
      
      % Get the dependent vars
      
      %网格点数
      function value = get.slx(obj)
          value = obj.nx;  
      end
      
      %总的网格点数
      function value = get.npt(obj)
          %总的粒子数量
          value = sum(obj.np(1:obj.ns));
      end      
      
      %网格点数+1
      function value = get.nxp1(obj)
         
          value = obj.nx+1;
      end
      
      %网格点数+2
      function value = get.nxp2(obj)
         value = obj.nx+2;
      end
      
      %1:128
      function value = get.X1(obj)
         value = 1:obj.nx;
      end
      
      %2:129
      function value = get.X2(obj)
         value = 2:(obj.nx+1);
      end
      
      %3:130
      function value = get.X3(obj)
         value = 3:(obj.nx+2);
      end
      
      %光速平方
      function value = get.cs(obj)
         value = obj.cv^2;
      end
      
      %光速平方的2倍
      function value = get.tcs(obj)
         value = 2*obj.cs;
      end      
      
      %电荷量
      function value = get.q(obj)
         value = obj.nx ./ obj.np(1:obj.ns) .* (obj.wp(1:obj.ns).^2) ./ ...
            obj.qm(1:obj.ns);
      end 
      
      % This is a case where you have inter-dependency.
      function value = get.mass(obj)
         value = obj.q ./ obj.qm(1:obj.ns);
      end
      
      %电荷密度
      function value = get.rho0(obj)
         value = -sum(obj.q(1:obj.ns) .* obj.np(1:obj.ns)) / obj.nx *...
            ones(obj.nxp2,1);
      end
      
      function value = get.bx0(obj)
         theta = pi/180*obj.angle;
         value = obj.wc/obj.qm(1)*cos(theta);
      end

      function value = get.by0(obj)
         theta = pi/180*obj.angle;
         value = obj.wc/obj.qm(1)*sin(theta);
      end   
      
      %每次画的步长数
      function value = get.ifdiag(obj)
         value = ceil(obj.ntime/obj.nplot);
      end
   end   
end