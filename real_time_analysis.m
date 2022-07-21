% real_time_analysis_db.m  Simulated Real Time Analyzer (RTA)
%
% Iteratively takes a short microphone recording, performs an FFT, and
% displays the results.  Parameters are set for a MacBook Air and expected
% amplitudes; may need to be adjusted on other systems.
%
% The name "Real Time Analyzer" comes from audio engineering, and does not
% mean the code is running in real time in the computational sense. An RTA
% is a device that displays power spectra in closed loop so one can 
% visualize how sounds change over time.

%- Set up recording parameters, create recording object

record_dur = 0.150; % Time in secs to record
sampRate_rec = 44100; % Sampling rate in Hz

SNDREC = audiorecorder(sampRate_rec,16,1);
pause(1)

% Note: Normally the audiorecorder object should be cleaned up
% automatically when the script terminates (by hitting Ctrl-C).  If weird
% memory or hardware issues arise after running the script several times,
% try an explicit delete of SNDREC after each run.

%- Predefine the number of Fourier frequencies that will be displayed, to
%- simplify the loop below

NFFT = 2.^(nextpow2(record_dur*sampRate_rec)); % Zero pad length for FFT

% The next line finds the frequencies computed by an FFT of an
% NFFT-length vector, taken with a sample rate of sampRate_rec.  However,
% it computes only the lower half (NFFT/2) of the FFT, which corresponds to
% the _positive_ frequencies.
%
% Recall that the FT of a discrete signal is periodic with period NFFT, so
% the top half can also be thought of as the negative frequencies:
% 0:(NFFT-1) covers the same range as -(NFFT/2):(NFFT/2-1),
% where the "minus ones" just account for one-offset indexing.
% Matlab chooses to return 0:(NFFT-1).
%
% We limit the list to the positive half as that's all we're going to
% display.  Think through why the below gives the correct freq scaling.
freq_axis = (0:(NFFT/2-1))*sampRate_rec/(NFFT-1)/1e3; % kHz

cutoff_freq = 7; % kHz, highest freq to display can be less than Nyquist
last_freq_ind = find(freq_axis>=cutoff_freq,1,'first');
freq_skip = 2; % Skip bins when plotting, to simplify display
freq_axis = freq_axis(1:freq_skip:last_freq_ind); % Freqs that will be displayed

%- Create figure in advance.  Will use handle graphics to update display
%- within the loop.

figure(2000) % Create figure in advance
set(2000,'windowstyle','docked')
plh = plot(freq_axis,zeros(size(freq_axis)),'linewidth',2); % Grab plot handle
xlabel('Frequency (kHz)','fontsize',18)
ylabel('Magnitude (dB): 20 log_{10}|X(j\omega)|','fontsize',18)
title('Real Time Analyzer','fontsize',18)
axis([freq_axis([1 end]) -60 40]) % Guess at good range, vertical in dB
drawnow
figure(2000) % Make top window

disp('Hit <Ctrl>-C in the Command Window to quit')

%% The main loop

% Loop is set to repear forever.  To break out, hit Cntrl-C.
while 1

  % Collect short sound sample
  recordblocking(SNDREC, record_dur);
  snd = getaudiodata(SNDREC);

  % Take the FFT, zero padded out to NFFT samples
  sndF = fft(snd,NFFT);

  % Update the vertical coords of the plotted data
  % The indexing here assumes freq_axis was properly defined above in
  % terms of the freqs an NFFT-long FFT would return
  %
  % Note we display magnitude |X(jw)| in dB
  set(plh,'ydata',20*log10(abs(sndF(1:freq_skip:last_freq_ind))));

  drawnow; % Flush the graphic queue to display each time through the loop

end
