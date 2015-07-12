function out = NcoupledFunction(t, y, num, klast, M)
    % the main input is the vector of [x1, x1', x2, x2', x3, x3'...xn, xn']
    % the output is [x1', x1'', x2', x2'', x3', x3''...xn', xn'']
    % then ODE45 uses those derivatives to calculate the next values of the
    % positions and velocities (e.g. x1, x1')
    %
    % - the y contains the input quantities, while P is just for getting
    % values of coefficients
    % - the n input contains the number of masses
    % - the t input is just the time vector, only comes into use if damping
    % terms are included (unlikely)
    % the equations are
    % mx1'' = -kx1 + k(x2 - x1)
    % mx2'' = -k(x2 - x1) + k(x3 - x2)
    % ...
    % mx_n'' = -k(x_n - x_(n-1)) - kx_n

    

    out = zeros(1, 2*num);              % create the output vector
    
    % do the output for the first and last mass because their equations are
    % slightly different
    
    %first mass
    out(1) = y(2);                                                                          % velocity
    out(2) = (-1 * (M(1).k/M(1).mass) * y(1)) + ((M(2).k/M(1).mass) * (y(3) - y(1)));       % acceleration
    
    % last mass
    out(2*num - 1) = y(2*num);                                                                  
    out(2*num) = (-1 * (M(num).k/M(num).mass) * (y(2*num - 1) - y(2*num - 3))) - ((klast/M(num).mass) * y(2*num - 1));
    
    % loop through every mass and get the x' and x'' outputs
    for h = 2:(num-1)
        out(2*h - 1) = y(2*h);
        out(2*h) = (-1 * (M(h).k/M(h).mass) * (y(2*h - 1) - y(2*h - 3))) + ((M(h+1).k/M(h).mass) * (y(2*h + 1) - y(2*h - 1)));
    end
    
    out = out';                     % output as column matrix

