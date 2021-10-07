%*************伪随机数************%
rng('default');
rng(1);

global flag_exit
flag_exit=0

%*************读取参数************%
prm = Parameters

%********renormalization*********%
[prm,ren] = renorm(prm);

%-- initialization --
[hdiag,output] = diagnostics_init(prm);
particle = Particle(prm);
field = Field(prm);
%prm = initial(prm, hdiag);

position(particle,prm);
if prm.iex  %control parameter for electrostatic option
   charge(particle, field, prm);
   poisson(field, prm);
end