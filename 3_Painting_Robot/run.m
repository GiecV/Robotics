clear all
close all

alpha = pi/128;
angle_with_plane = pi/18;
angle_points = angle_with_plane - alpha;

points = 10*[.8 .6 .0 -.8 -.8 -.8 -.6   0  .8 .8 .8; ...
             .8 .8 .4  .8 -.6 -.8 -.8 -.2 -.8 .6 .8];

[curve, t] = fnplt(cscvn(points));

curve3D = [curve; zeros(1, length(curve))];
rotCurve3D = rotx(rad2deg(angle_with_plane))*curve3D;

Ts = zeros(4, 4, length(rotCurve3D));
Tsrot = zeros(4, 4, length(rotCurve3D));

Hrot = [rotx(rad2deg(alpha)) zeros(3, 1);
        zeros(1, 3) 1
       ];
   
for i=2:(length(rotCurve3D)-1)
    
    Ts(1:3, 1:3, i) = rotx(rad2deg(angle_with_plane));
    Ts(:, 4, i) = [rotCurve3D(:, i); 1];
    
end 
   
hold on;

view([1 1]);
plot3(rotCurve3D(1, :), rotCurve3D(2, :), rotCurve3D(3, :));
zlim([-5,10])


for i=1:length(rotCurve3D)
    plotFrame(Ts(:, :, i));
end

xlabel("x");
ylabel("y");
zlabel("z");
% hold off;

[x, y] = meshgrid(-10:1:10);

coeff = getPlaneCoff(rotCurve3D);
z = coeff(1).*x + coeff(2).*y + coeff(4);

surf(x,y,z,'FaceAlpha',0.2, 'EdgeColor','none');

function plotFrame(T, varargin)
    if ~isempty(varargin)
        k = varargin{1};
    else
        k = 1;
    end
    x = [k 0 0 1]';
    y = [0 k 0 1]';
    z = [0 0 k 1]';

    Op = T * [0 0 0 1]';
    xp = T * x;
    yp = T * y;
    zp = T * z;

    plot3([Op(1) xp(1)], [Op(2) xp(2)], [Op(3) xp(3)], 'r', 'LineWidth', 2)
    % hold on
    plot3([Op(1) yp(1)], [Op(2) yp(2)], [Op(3) yp(3)], 'b', 'LineWidth', 2)
    plot3([Op(1) zp(1)], [Op(2) zp(2)], [Op(3) zp(3)], 'g', 'LineWidth', 2)
    % hold off
end

function coeff=getPlaneCoff(curve)
    non_collinear_points_idxs = randi(length(curve), 3);
    non_collinear_points = curve(:, non_collinear_points_idxs);

    A = non_collinear_points(:, 2) - non_collinear_points(:, 1);
    B = non_collinear_points(:, 3) - non_collinear_points(:, 1);

    normal = cross(A, B);
    normal = -normal ./ normal(3);
    
    k = -normal'*non_collinear_points(:, 1);
    coeff = [normal; k];
end
