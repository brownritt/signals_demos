# Signals Demos

## Overview

These are some simple Matlab demonstrations I made many years ago to use in teaching undergraduate Signals and Systems classes. Each m-script is a standalone demonstration, that records some audio and then displays, manipulates, and/or plays it back.

As long as the scripts are on the Matlab path (or in the working directory) you should be able to click the "Play" button in the Matlab editor, and then follow prompts in the Command Window. They should also work by invoking the file name as a command.

After a short initialization delay, the Command Window will prompt you to record a short (5 second) audio sample. For best effect, you should try speech (with both long vowels and sharp consonants), "pure" harmonic sounds (whistles or tones), and/or percussive sounds (finger snaps or vocal "tsking"). Run the scripts a few times and mix and match!

Most of the scripts are coded to enable editor cell mode, e.g. to repeatedly rerun just one part of the demonstration with a fixed audio sample, but the cells have to be executed in an order that puts recorded data in the workspace before later cells can be run.

`sampled_signal_demo.m` demonstrates the relation between continuous time signals and the discrete time sampled signal that is actually represented in the computer, and displays a spectrogram as a frequency domain representation.

`random_phase_vs_whitening.m` demonstrates the distinct contributions of the magnitude (AKA amplitude AKA power) spectrum and the phase spectrum to audio signals, by either phase randomizing (keeping the frequency content the same but eliminating the temporal structure) or whitening (keeping the "temporal" structure but equalizing the power over all frequencies).

`real_time_analysis.m` repeatedly updates a power spectrum from the microphone so you can see the spectral content as you make many different sounds (more fun than karaoke...).

There is some additional explanation and background information in the code comments.

Note: figures are generated "docked", and removing the docking might mess up the keyboard focus when switching between figures and the Command Window. If figures do not appear or the keyboard loses focus, you may need to modify your Matlab layout.


## Installation and dependencies

Should need only standard Matlab with signal processing toolbox. Tested most recently on a MacBook Air with Matlab R2019a (update 9), but hopefully works with minor version/platform dependence as it uses mostly vanilla Matlab functions.

If there are glitches, they will most likely be in the audio input or output. Matlab will need OS permission to access the microphone. Also, the code relies on Matlab's default audio devices, so if you have a USB microphone or other fancy audio setup it is possible Matlab will not find the correct device. You can try switching to system default audio devices, or look at the documentation for `audiorecorder` and `audiodevinfo` on how to select specific devices when more than one is available.

The code was written just for in-lecture demonstration, and is fairly bespoke and brittle. No warranty of any kind is made; use at your own risk.

## Contributors

Jason Ritt
