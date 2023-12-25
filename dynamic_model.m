function dX = dynamic_model(t,X,rho,z,alpha)
% mu = 3.986004415e14;
% mu_s = 330000 * mu;
% r_s = 1.5e11;
% beta = 0.002;

% alpha = 38.2153;
% delta_rho=60.001;
% delta_z=20.001;

% rho=X(1);
% theta=X(2);
% z=X(3);
% d_rho=X(4);
% d_theta=X(5);
% d_z=X(6);
delta_rho=X(1);%扰动量和初始值60加起来的值
delta_z=X(2);%扰动量和初始值20加起来的值
% delta_alpha=X(9);
d_delta_rho=X(3);%由于60是常值，所以对rho_total微分和对delta_rho微分相等
d_delta_z=X(4);

r = sqrt(rho^2+z^2);

% omega_0=3;
kai=z/r^3;
h=10;

% dX1=d_rho;
% dX2=d_theta;
% dX3=d_z;
% dX4 = rho* d_theta^2 - mu/r^3*rho + beta * mu_s / r_s ^2 *cosd(alpha)^2 * sind(alpha);
% dX5 = -2/rho * d_rho* d_theta + beta* mu_s / (rho*r_s ^2)* theta * cosd(alpha)^2;
% dX6 = - mu/r^3 * z + beta * mu_s / r_s ^2 * cosd(alpha)^3;

% dX4 = h^2/rho^3 - rho /r^3 + kai*cosd(alpha)^2*sind(alpha)^2;
% dX5 = -2*d_rho*d_theta/rho;
% dX5 = 0;
% dX6 = -z/r^3 + kai*cosd(alpha)^3;

%偏导数计算
p_frho_rho = - h^2/rho^4-1/r^3;
p_frho_z=0;
p_frho_alpha=kai*(-2*cosd(alpha)*sind(alpha)^2+cosd(alpha)^3);
p_fz_rho=0;
p_fz_z=-1/r^3;
p_fz_alpha=kai*(-3*cosd(alpha)^2*sind(alpha));

%lqr控制器
A=[0,0,1,0;
    0,0,0,1;
    p_frho_rho,p_frho_z,0,0;
    p_fz_rho,p_fz_z,0,0];
B=[0,0,p_frho_alpha,p_fz_alpha]';
Q=[10,0,0,0;
    0,20,0,0;
    0,0,0,0;
    0,0,0,0];
R=1;
K=lqr(A,B,Q,R);
%u=-K*x;

%控制器得到的结果
delta_alpha=-K*[delta_rho,delta_z,d_delta_rho,d_delta_z]';

dX1 = d_delta_rho;
dX2 = d_delta_z;
dX3 = p_frho_rho*delta_rho+p_frho_z*delta_z+p_frho_alpha*delta_alpha;
dX4 = p_fz_rho*delta_rho+p_fz_z*delta_z+p_fz_alpha*delta_alpha;

%alpha=alpha+delta_alpha;

dX=[dX1;dX2;dX3;dX4];

end