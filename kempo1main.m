function kempo1main
    %*************伪随机数************%
    %用于随机生成粒子的初始坐标和相位角
    rng('default');
    rng(1);

    global flag_exit
    flag_exit=0

    %*************读取参数************%
    prm = Parameters

    %********renormalization*********%
    [prm,ren] = renorm(prm);

    %********initialization*********%
    [hdiag,output] = diagnostics_init(prm);
    particle = Particle(prm)
    field = Field(prm)
    %prm = initial(prm, hdiag);

    position(particle,prm)
    if prm.iex  %静电开关：iex=1为电磁，iex=2为静电
       charge(particle, field, prm)
       poisson(field, prm)
    end

    %************main loop***********%
    jtime=0;
    jdiag=1;  %保存不同时刻的画图数据，每次循环自加1

    %-- Diagnostics at initial time显示粒子的初始图像信息 --
    hdiag=diagnostics(hdiag,particle,field,output,prm,jtime,jdiag,ren);
    if prm.nplot == 0  %nplot: number of output
       return
    end

    % Time advance loop
    for jtime = 1:prm.ntime  
        if prm.iex==2  %iex=2静电；iex=1电磁
            rvelocity(particle, field, prm);
            position(particle, prm);
            position(particle, prm);      %？两次位置变化？？ 每次更新半个时间步位置
            charge(particle, field, prm);
            poisson(field, prm);
        else
            bfield(field,prm);
            rvelocity(particle, field, prm);
            position(particle, prm);
            current(particle, field, jtime, prm);
            bfield(field, prm);
            efield(field, prm);
            position(particle, prm);
        end

       %-- 时变诊断diagnostics --
       if mod(jtime,prm.ifdiag)==0
          jdiag = jdiag+1;
          hdiag = diagnostics(hdiag, particle, field,output, prm, jtime, jdiag,ren);
       end
       if flag_exit
          break;
       end
    end
    %-- diagnostics --
    if ~flag_exit
       diagnostics_last(hdiag, prm, jtime,output,ren);
    end
end


