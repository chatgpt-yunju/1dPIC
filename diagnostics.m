function hdiag = diagnostics(hdiag, particle,field,output, ...
   prm, jtime, jdiag,ren)
%
% diagnostics
%
% hdiag: handles

global flag_exit;

% reference to class obj
f = field;
X2=prm.X2
try
   % pause check
   flag = get(hdiag.fig,'UserData');
   if strcmp(flag,'pause')
      uiwait(hdiag.fig);
   end
   
   % exit check
   flag = get(hdiag.fig,'UserData');
   if strcmp(flag,'exit')
      flag_exit = 1;
      return;
   end
   
catch
   return
end

%
if hdiag.flag_eng
   output.engsave(:,jdiag) = energy(f, particle, prm); %？engsave的257
end
if hdiag.flag_field
   output.fieldsave(:,:,jdiag) = [f.ex, f.ey, f.ez, f.by-prm.by0, f.bz]';
end
if hdiag.flag_kspec
   output.kspecsave(:,:,jdiag) = kspectr([f.ex(X2),f.ey(X2),f.ez(X2),f.by(X2)-prm.by0,f.bz(X2)],prm)';
end


%
% graphics
%
figure(hdiag.fig)

%
for l=1:length(prm.diagtype)             %prm.diagtype在diagnostics_init.m中
   %axes(hdiag.axes(l))
   set(gcf,'CurrentAxes',hdiag.axes(l)); %	创建笛卡尔坐标系  
   hdiag.nplt = l; % plate number
   
   type = prm.diagtype(l);%diagtype = [11.000000, 23.000000, 18.000000, 4.000000, ]
   switch type   % [1, 4, 5,  10, 11.000000,12,15, 23.000000, 25.000000, 30.000000]
      case {1,2,3}
         hdiag = plotphs(hdiag, type, jdiag, particle, prm,ren);
      case 4
         hdiag = plotvs(hdiag,jdiag, particle,prm,ren);
      case {5,6,7,8,9}
         hdiag = plotfield(hdiag, type-4, jdiag, field, prm);
      case 10
         hdiag = plotwave(hdiag,jdiag,particle,field,prm,ren);
      case 11
         hdiag = plotenergy(hdiag,jdiag,output.engsave,prm,ren);
      case {12,13,14}
         hdiag = plotvdist(hdiag,type-11,jdiag,particle,prm,ren);
      case {15,16,17,18,19}
         hdiag = plotkspectrum(hdiag,type-14,jdiag, field, prm, ren);
      case {20,21,22,23,24}
         % reserved for wk plot
      case {25,26,27,28,29}
         hdiag = plotts(hdiag,type-24,jdiag,output.fieldsave,prm,ren); % time series plot
      case {30,31,32,33,34}
         hdiag = plottsk(hdiag,type-29,jdiag,output.kspecsave,prm,ren); % time series k plot
      otherwise
         error('Error: %s',mfilename);
   end
   
end

% Title
set(hdiag.htitle,'String',sprintf('Time: %5.3f/%5.3f',jtime*prm.dt,prm.ntime*prm.dt));

if hdiag.flag_rot
   rotate3d on
end
drawnow
end

