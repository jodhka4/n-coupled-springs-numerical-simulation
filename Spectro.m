function Spectro(y,t,t0,tf, whichmass, PlotFourier, PlotMaxfreq, PlotSpectro, AnimateFourier)
% this function is for any spectral analysis that needs to be done
% first, create some variables that are used by most of the sections here,
% i.e. sampling frequency, number of fft points, number of samples per
% spectrogram division
% then the program performs a series of operations depending on the input
% of booleans (e.g. PlotFourier, PlotMaxfreq, etc.) via if statements
% besdies the booleans, the inputs include the position-time and
% velocity-time waveforms of each variable (stored in y), the corresponding
% times in t, integration times t0 and tf
% the input vector 'whichmass' includes the index corresponding to each
% mass in the system - e.g. if whichmass = [1, 10], then the calculations
% in this function will be made for the first mass from the left and the
% 10th mass from the left (see NcoupledSprings.m for picture)


    % sampling frequency
    Fs = length(t)/(tf-t0);
    
    % number of points for the fft
    nfft = 2^nextpow2(length(t));
    
    % number of samples per division in the spectrogram
    nsamp = 1000;
    
%-------------------------------------------------------------------

    if PlotMaxfreq || AnimateFourier == true
        % store the spectrograms of the position-time data of each mass
        % indicated in the whichmass vector into one 3d array
        
        % get the first spectrogram, then get its dimensions in order to
        % make a suitable 3d array
        [s1, f, times] = spectrogram(y(:,1), nsamp, [], nfft, Fs);

        % create a 3d array to contain all the spectrograms
        spectrograms = cat(3,s1, zeros((nfft/2 + 1), size(s1,2), length(whichmass) - 1));
        
        for ii = 2:length(whichmass)
            spectrograms(:,:,ii) = spectrogram(y(:,(2*(whichmass(ii)) - 1)), nsamp, [], nfft, Fs);
        end
        
        spectrograms = abs(spectrograms);
    end
    
%-------------------------------------------------------------------

    if PlotFourier == true
        % this section plots the fourier transform of the entire
        % position-time wave of each mass indicated in the whichmass vector
        
        % make a matrix to store the FT data for each oscillation
        Yft = zeros(nfft,length(whichmass));
        
        % plot the fourier transform of the entire oscillation of each mass
        for ii = 1:length(whichmass)
            % perform fft 
            Yft(:,ii) = fft(y(:, 2*whichmass(ii) - 1), nfft);
            
            % get frequency domain
            freqdom = Fs/nfft * (0:(nfft-1));
            freqdom = freqdom(1:ceil(length(freqdom)/2));
            
            % plot it
            figure
            plot(freqdom, abs(Yft((1:ceil(size(Yft, 1)/2)),ii)))
        end
    end
    
%-------------------------------------------------------------------

    if PlotMaxfreq == true
        % graph the peak frequency over time (easier to read than spectro)
        
        % preallocate for maxfreqs array, containing max frequencies over time
        % for each mass
        maxfreqs = zeros(size(spectrograms, 2), length(whichmass));
    
        % loop to get all the max frequencies
        for ii = 1:length(whichmass)
            for jj = 1:size(spectrograms, 2)
                [maxes, ind] = max(spectrograms(:,jj,ii));
                maxfreqs(jj,ii) = f(ind);
            end
             figure
             plot(times, maxfreqs(:,ii))
             title(['Maximum Frequencies over time for', strcat(' x', int2str(whichmass(ii)))])
             xlabel('Time [s]')
             ylabel('Frequency [Hz]')
        end
    end
    
%-------------------------------------------------------------------
    
    if AnimateFourier == true
        % create an animation of the fourier transform over time
        
        % create the figure array for all the plots (preallocate)
        Figs = gobjects(1,length(whichmass));
        Figs(1) = figure;
        
        % fill the rest of the array and create the figures for plotting
        for ii = 2:length(whichmass)
            Figs(ii) = figure;
            axis([0,50,0,200])
        end

        
        % plot the fourier transform over time using the spectrogram
        for ii = 1:length(times)
            for jj = 1:length(whichmass)
                set(0, 'currentfigure', Figs(jj))
                plot(f,spectrograms(:,ii,jj))
                axis([0,40,0,200])
                pause(0.1)
            end
        end
    end
    
%-------------------------------------------------------------------

    if PlotSpectro == true
        % just show the spectrograms - no storing in array
        for ii = 1:length(whichmass)
            figure
            spectrogram(y(:,2*(whichmass(ii)) -1), nsamp, [], nfft, Fs)
            axis([0,0.04,0,3])
            view(-90, 90)
            set(gca,'YDir','reverse');
        end
    end
end
