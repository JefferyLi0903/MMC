clear all;
close all;
clc;


df=loadFile_FM_audio('./CaptureData/Audio/Audio_934_15dB(+0Hz)03.txt');

figure(10)
plot(df(1:length(df)))
set(gcf,'color','white');
title('Time Aeries Decimated Audio Signals @20KHz')


figure(11)
plot_FFT_IQ(df,1,length(df),2E5,83.4E6,'Audio Demodulated Signal @20KHz');


sound(df,2E5/10);


