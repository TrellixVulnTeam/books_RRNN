%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%    An Introduction to Scientific Computing          %%%%%%%
%%%%%%%    I. Danaila, P. Joly, S. M. Kaber & M. Postel     %%%%%%%
%%%%%%%                 Springer, 2005                      %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%================================================
% Explicit Euler scheme to integrate 
%  u'(t)=fun(t,u)
%=================================================
%fun  the name of the right hand side EDO function
% t0   the initial time
% u0   the initial condition at  t0
% t1   the final time
%  n   the number of time steps between t0 and t1
% Output arguments :
%      u    the dimension n+1 vector containing the numerical
%              solution at times  t0+i*h, with h=(t1-t0)/n
%=================================================

function u=PDE_EulerExp(fun,u0,t0,t1,n)

h=(t1-t0)/n;    % discretization of the time interval      
u=zeros(1,n+1); % initialize   u
u(1)=u0;        % start from initial condition

% the rhs function is fun(t,u)
for i=1:n
   u(i+1)=u(i)+h*feval(fun,t0,u(i));
   t0=t0+h;
end

