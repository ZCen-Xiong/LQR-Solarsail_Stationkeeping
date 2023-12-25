clc;clear;
% initial_position = [ 60; 0; 20];
% initial_division = [0;6;0];
% X0 = [initial_position; initial_division;0;0;1;1];
initial_position = [ .001 ;.001];

initial_division = [0.0001;0.001];%初始时刻的一阶导数
X0 = [initial_position; initial_division];
tspan=[0,1000];

% 求解微分方程组
options = odeset('RelTol', 1e-11, 'AbsTol', 1e-11);
[t, X] = ode45(@dynamic_model, tspan, X0,options,60,20,38.2143);
RHO=X(:,1)+60;
Z=X(:,2);

%柱坐标和直角坐标转换，由于角速度不变就假设了角速度为10
x=RHO.*cosd(10*t);
y=RHO.*sind(10*t);
z=Z;

% 绘制结果
figure(1);
hold on;
plot3(x(1), y(1), z(1), 'o');
plot3(x, y, z, 0,0,0, 'o');
xlabel('X轴');
ylabel('Y轴');
zlabel('Z轴');
title('position');
grid on;

% figure(2);
% plot3(X(:,4), X(:,5), X(:,6));
% xlabel('X轴');
% ylabel('Y轴');
% zlabel('Z轴');
% title('division');
% grid on;
% 
% figure(3);
% comet3(x, y, z);
