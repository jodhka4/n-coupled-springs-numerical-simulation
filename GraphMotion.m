function GraphMotion(t,y,n, PlotMotion)
% this function plots the position-time behaviour of each mass in the
% system, with up to 8 plots per figure
% the t and y inputs are for time and position data respectively
% the n input is the number of masses in the system
% the PlotMotion input is a boolean which determines whether to plot at all

    if PlotMotion == true
        % plot motion on figures with up to 8 plots per figure
        ind = 1:ceil(n/8);
        for h = 1:ceil(n/8)
            figure('position', [0,0,800,1280])

            % if on the last figure, then the plots go from 8*h - 7 to n, other
            % wise go from 8*h - 7 to 8*h
            % e.g. n = 15 - then for fig 1 the nested loop goes from 1:8, and for
            % fig 2 it goes from 9:15
            if h == ind(length(ind))
                lastii = n;
            else
                lastii = 8*h;
            end

            % loop to create each plot (up to 8 subplots per figure)
            for ii = (8*h - 7):lastii
                subplot(4,2,(ii - 8*(h-1)))
                xlabel('time [s]')
                ylabel(['Position of', strcat('x',int2str(ii)), ' [m]'])
                plot(t,y(:,(2*ii - 1)))
            end
        end
    end
end