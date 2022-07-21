% sampled_signal_demo.m
%
% Takes a short audio recording, and displays the signal in "continuous"
% time, as discrete samples, and as a spectrogram.

record_dur = 5; % Time in secs to record

% Create recording object

sampRate_rec = 44100; % Sampling rate in Hz

SNDREC = audiorecorder(sampRate_rec,16,1);
pause(1)

%% Collect short sound sample

disp('Start of recording...');
recordblocking(SNDREC, record_dur);
disp('End of recording.');

% Get the data

snd.data = getaudiodata(SNDREC);
time_axis = (0:length(snd.data)-1)/sampRate_rec;

% Normalize power of recorded signal
% Also demonstrate clipping

snd_pwr = var(snd.data); % Recorded power

good_pwr = 0.07^2; % Normalized to 1, Matlab convention
snd_orig.data = sqrt(good_pwr/snd_pwr)*snd.data; % Scale power
snd_orig.data = max(-1,min(1,snd_orig.data)); % Clip if necessary


%% Display (in cell mode can repeat)

% Make/reset figures

figure(1001)
clf
set(1001,'Windowstyle','docked');
figure(1002)
clf
set(1002,'Windowstyle','docked');
figure(1003)
clf
set(1003,'Windowstyle','docked');
figure(1004)
clf
set(1004,'Windowstyle','docked');


% Display signal in time domain as if it is a continuous time signal: the
% sample values are not marked explicitly but joined with lines.  When
% plotted this way, the computer is acting as if it has data at all times,
% which will be a reasonable approximation if the sample rate is
% sufficiently high (often much higher tha Nyquist).
%
% The signal is notated as x(t)

figure(1001)
plh1 = plot(time_axis,snd_orig.data,'b-'); % Will use handle below
hold on
plot(xlim,[0 0],'k--')
hold off
set(gca,'fontsize',14); % Tick labels
th = title('Sound pressure as a "continuous" time signal x(t)','fontsize',18);
xlabel('Time (sec)','fontsize',18)
ylabel('Intensity (normalized)','fontsize',18)
ylim([-1.1 1.1])
drawnow

% Zoom in to a short segment of data.
%
% The code contains some fancy stuff to make the animation, which you can
% ignore as far as signals is concerned.

disp('Click to zoom around a time point')
gp = ginput(1); % Click on point to zoom

axh = gca; % Get handle to current axes
xl_start = xlim; % Find current x axis limits

num_steps = 40; % Design change in limits for zoom
xlow = linspace(xl_start(1),gp(1)-0.001,num_steps);
xhigh = linspace(xl_start(2),gp(1)+0.001,num_steps);

for kk=1:num_steps % ZOOOOOOOOM 
  set(axh,'xlim',[xlow(kk) xhigh(kk)])
  drawnow
end

% Add makers to explicitly indicate sample values.

input('Hit <RET> to add sample markers','s');
set(plh1,'marker','.');

% Add stems

input('Hit <RET> to add stem plot','s');

figure(1001)
hold on
plh2 = stem(time_axis,snd_orig.data,'fill','color',[0 0 0]);
hold off

% Rempve the "continuous" plot leaving only the stems.  The stem is how we
% usually display a discrete time signal.
%
% The signal is notated as x(n dt)

input('Hit <RET> to remove line plot','s');
set(plh1,'visible','off')
set(th,'string','Sampled sound pressure in discrete time x(n \Delta{}t)');

% But we still need to think about the horizontal axis. It's displayed in
% seconds, which is correct if we know the interval ("delta t") between
% each successive sample, but since the samples occur only at equally
% spaced times, we often prefer to number the samples as integers and label
% the time axis by that numbering, 0, 1, 2, ...
%
% The signal is notated as x[n]

input('Hit <RET> to relabel the time axis by sample number','s');
set(plh1,'xdata',0:(length(time_axis)-1)); % Convert times to discrete
set(axh,'xtick',time_axis(1:50:end), ...
   'xticklabel', ...
   cellstr(num2str((1:50:length(time_axis))'))); % Update the tick marks
% Here we have to fool Matlab with new xtick labels for animation purposes.
% Normally you would just plot the vector (ie, plot(data)) and Matlab will
% by default plot against sample number
set(th,'string','Sampled sound pressure in discrete time x[n]');
xlabel('Sample number') % Update the axis label
drawnow

% We should point out that there are discrete time signals that are not
% samples of a continuous time signal.  For example, we might ask for the
% blood volume pumped by each heartbeat, say V[n].  Although the operation
% of the heart is continuous, the signal V[n] is not really sampled from a
% continuous signal, but is naturally considered as a discrete process.


%% This cell separates time from freq domain sections

input('Hit <RET> to start frequency domain section','s');

%% Example of viewing a sound in the frequency domain

% First replot as continuous signal

figure(1002)
plot(time_axis,snd_orig.data,'b-');
hold on
plot(xlim,[0 0],'k--')
hold off
set(gca,'fontsize',14); % Tick labels
th = title('Sound pressure as a "continuous" time signal x(t)','fontsize',18);
xlabel('Time (sec)','fontsize',18)
ylabel('Intensity (normalized)','fontsize',18)
ylim([-1.1 1.1])
drawnow

input('Hit <RET> to view spectrogram','s');

% Now in new figure present spectrogram.  As discussed in class, this is a
% color coded plot of many windowed Fourier transforms concatenated
% together.  As is typical when using spectrograms, in this plot the
% individual windows are actually overlapping, which means the pixels in
% the spectrogram are not independent (two pixels closer in time than
% the window width will be correlated).

[So,Fo,To] = spectrogram(snd_orig.data,2^10,2^9,[],sampRate_rec);
figure(1003)
set(gcf,'windowstyle','docked')
imagesc(To,Fo,20*log10(abs(So)),[-126 34])
axis xy
set(gca,'fontsize',14);
xlabel('Time (sec)','fontsize',18)
ylabel('Frequency (Hz)','fontsize',18)
title('Spectrogram','fontsize',18)
ylim([0 6000]) % Interesting range is up to 6 kHz

% Will also put time series and spectrogram on same figure, but hide it.
% This is for demonstration purposes.

figure(1004)
clear alh
alh(1) = subplot(2,1,1); % Signal x(t)
plot(time_axis,snd_orig.data,'b-');
hold on
plot(xlim,[0 0],'k--')
hold off
set(gca,'fontsize',14); % Tick labels
th = title('Time domain and frequency domain together','fontsize',18);
ylabel('Intensity (normalized)','fontsize',18)
ylim([-1.1 1.1])
alh(2) = subplot(2,1,2); % Spectrogram
imagesc(To,Fo,20*log10(abs(So)),[-126 34])
axis xy
set(gca,'fontsize',14);
xlabel('Time (sec)','fontsize',18)
ylabel('Frequency (Hz)','fontsize',18)
ylim([0 6000]) % Interesting range is up to 6 kHz
pause(0.1)
linkaxes(alh,'x');

figure(1003) % Dislay spectrogram alone
drawnow

