% DEMO5 
%
% Description
%     "Fit" a contour, using motion normal to an interface. Start with an 
%     initial "Swiss cheese" level-set function.

% Print out help message.
help demo5
dims = [80 80];

    %
    % Form the contour that we will attempt to mimic.
    %

lset_grid(dims);
phi0 = lset_box([0 0], [30 10]);
phi0 = lset_union(phi0, lset_box([0 0], [10 30]));
[phi0, err] = signed_distance(phi0, 1e-1);


    %
    % Initialize grid.
    %

lset_grid(dims);


    % 
    % Construct the initial structure/interface.
    %

% Simple circle.
radius = 1;
spacing = 3;

phi = -Inf * ones(dims); % Empty level-set.
for i = [0 : spacing : dims(1)] - dims(1)/2
    for j = [0 : spacing : dims(2)] - dims(2)/2
        phi = lset_intersect(phi, lset_complement(lset_circle([i j], radius)));
    end
end
        


    % 
    % Construct the signed distance function for the interface.
    %

[phi, err] = signed_distance(phi, 1e-1);


    % 
    % Construct a (zero) velocity field.
    %

V = lset_velfield(@(x, y) 0*x, @(x, y) 0*y);


    %
    % Move the surface within the velocity field, keep phi "close" to a
    % signed distance function.
    %

while (true)
    lset_plot(phi); % Visualize.
    hold on
    contour(phi0', [0 0], 'g-', 'LineWidth', 2);
    hold off
    drawnow
    phi = update_interface(phi, V, phi0, 0); % Move the interface.

%     % Use this update to add a significant amount of curvature motion, 
%     % this keeps the contour smooth.
%     phi = update_interface(phi, V, phi0, 10); % Move the interface.

    [phi, err] = signed_distance(phi, 1e-1); % Make phi more sdf-like.
end


