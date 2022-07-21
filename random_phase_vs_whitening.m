% random_phase_vs_whitening.m
%
% Demonstration of phase randomizing and whitening.
%
% Code can be run in its entirety to walk through each example on the same 
% recording.
%
% Alternatively, you can skip to the part you want, by first running the
% first section to record a signal, then using cell mode in the Matlab
% editor:
%   Place your cursor in the cell (sections separated by lines begining
%   with "%%") you want (should be highlighted) and hit Ctrl-Return (PC)
%   or Cmd-Return (Mac) to run just that cell.  Only the currently
%   highlighted cell should run.

record_dur = 5; % Time in secs to record

desired_pwr = 0.07.^2; % Normalized to 1

if exist('figh','var')
  figure(figh)
  clf
else
  figh = figure('Windowstyle','docked');
end
drawnow

% Create recording object

sampRate_rec = 44100;
% Note: Code below assumes record_dur*sampRate_rec is an even integer 
% when preserving conjugate symmetry in phase randomization. Is a little
% brittle if you change duration to non-integer or use an odd sample rate.

SNDREC = audiorecorder(sampRate_rec,16,1);
pause(1)

% Collect short sound sample

disp('Start speaking.');
recordblocking(SNDREC, record_dur);
disp('End of recording.');

% Get the data

snd.data = getaudiodata(SNDREC);
snd.time = (0:length(snd.data)-1)/sampRate_rec;

% Normalize power of recorded signal

snd_pwr = var(snd.data); % Recorded power
snd.data = max(-1,min(1,sqrt(desired_pwr/snd_pwr)*snd.data));

%% Waypoint for cell mode

disp('===')
disp('===')
disp('===')

inQ = input('Enter "n<RET>" to stop (for cell mode), or <RET> to continue','s');
if strcmp(inQ,'n')
    return
end

%% Time domain and spectrograms

disp('First look at recorded signal in time and frequency domains...')

figure(figh)
plot(snd.time,snd.data,'b')
title('Sound pressure profile')
xlabel('Time (sec)')
ylabel('Intensity (normalized)')
legend({'Original'})
drawnow

input('Hit <RET> to show spectrogram','s');

[So,Fo,To] = spectrogram(snd.data,2^10,2^9,[],sampRate_rec);

figure(1002)
set(gcf,'windowstyle','docked')
imagesc(To,Fo,20*log10(abs(So)),[-126 34])
axis xy
xlabel('Time (sec)')
ylabel('Frequency (Hz)')
title('Original sound spectrogram')
ylim([0 6000])

%% Waypoint when not in cell mode

disp('===')
disp('===')
disp('===')

input('Hit <RET> to move to phase randomizing section','s');


%% Randomize phase

% Normalize power of recorded signal

snd_pwr = var(snd.data); % Recorded power
snd.data = max(-1,min(1,sqrt(desired_pwr/snd_pwr)*snd.data));

% Phase randomized signal, same magnitude spectrum

snd_fft = fft(snd.data); 
N = length(snd_fft); % Should be even by default
rand_phase = exp((sqrt(-1)*2*pi)*rand(N/2-1,1));
rand_phase = [1; rand_phase; 1; conj(rand_phase(end:-1:1))]; % Conjugate symmetry

snd_phase.data = real(ifft(rand_phase.*snd_fft)); % Back to time domain
% The "real" is to eliminate any spurious imaginary components due to round
% off error.

snd_phase.time = (0:length(snd_phase.data)-1)/sampRate_rec;

% Normalize altered sound power for playback

snd_phase_pwr = var(snd_phase.data); % Recorded power
snd_phase.data = max(-1,min(1,sqrt(desired_pwr/snd_phase_pwr)*snd_phase.data));

% Display both signals in time domain

figure(figh)
plot(snd.time,snd.data,'b',snd_phase.time,-1+snd_phase.data,'r')
title('Sound pressure profile: Phase randomization')
xlabel('Time (sec)')
ylabel('Intensity (normalized)')
legend({'Original','Phase randomized'})
drawnow

% Make playback objects

obj_rec = audioplayer(snd.data, sampRate_rec);
obj_phase = audioplayer(snd_phase.data, sampRate_rec);

disp(' --- Original sound')
input('<RET> to start playback','s');
playblocking(obj_rec)

disp(' --- Phase randomized sound')
input('<RET> to start playback','s');
playblocking(obj_phase)

%% Waypoint when not in cell mode

disp('===')
disp('===')
disp('===')

input('Hit <RET> to move to whitening section','s');

%% Phase coherent, "whitened" (flattened) spectrum

snd_fft = fft(snd.data); 

snd_mag.data = real(ifft(exp(sqrt(-1)*angle(snd_fft))));
% In polar form it is particularly easy to set rho=1.
% There may be some computational artifacts from this brute force way
% of whitening, but it works as a quick and dirty demonstration with 
% reasonable signals.

snd_mag.time = (0:length(snd_mag.data)-1)/sampRate_rec;

% Normalize altered sound power for playback

snd_mag_pwr = var(snd_mag.data); % Recorded power
snd_mag.data = max(-1,min(1,sqrt(desired_pwr/snd_mag_pwr)*snd_mag.data));

% Display both signals in time domain

figure(figh)
plot(snd.time,snd.data,'b',snd_mag.time,-1+snd_mag.data,'r')
title('Sound pressure profile: Whitening')
xlabel('Time (sec)')
ylabel('Intensity (normalized)')
legend({'Original','Whitened'})
drawnow

% Make playback objects

obj_rec = audioplayer(snd.data, sampRate_rec);
obj_mag = audioplayer(snd_mag.data, sampRate_rec);

disp(' --- Original sound')
input('<RET> to start playback','s');
playblocking(obj_rec)

disp(' --- Whitened (flat magnitude) sound')
input('<RET> to start playback','s');
playblocking(obj_mag)


