clear all;
close all;
clc;


fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_15dB(+0Hz)06.txt');
figure(1)
subplot(2,1,1)
plot(real(fmdata));
set(gcf,'color','white');
title('Real time serial data')
subplot(2,1,2)
plot(imag(fmdata),'r');
set(gcf,'color','white');
title('Image time serial data')

figure(2)
freqz(fmdata(1:3000),1,[-1E5:.1E5:1E5],2E5);
set(gcf,'color','white');
title('Magnitude and Phase Shift Plot FFT of  IQ Data')




firstsample=1; % start @ first sample
filterlength=.015*2E5; % filter length is 2 milliseconds for each sample
fs=2E5; % sampling frequency
centerfreq=93.4E6; %#1: Works for Jazz Stations 88.3FM

figure(3)
plot_FFT_IQ(fmdata,firstsample,filterlength,fs,centerfreq,'Magnitude and Phase Shift Plot FFT of IQ Data @ Center Freq'); % FFT of IQ data @ Center Freq
title('Magnitude and Phase Shift Plot FFT of IQ Data @ Center Freq')


[y_FM_demodulated] = FM_IQ_Demod(fmdata); % Demodulate the decimated signal 

figure(5)
plot(y_FM_demodulated)
set(gcf,'color','white');
title('Demodulated signals')


Fpass1 = 0.0200;
Fpass2 = 30;
Fstop1 = 32;
Fstop2 = 200;
fs = 200;
audio_filter_coe = firls(20, [Fpass1 Fpass2 Fstop1 Fstop2]*(1/fs), [1 1 0 0],[1 10000]); % LPF
%audio_filter_coe=[17 34 57 85 118 152 185 215 239 254 259 254 239 215 185
%152 118 85 57 34 17];   % FPGA used filter coe. 


for ii=21:length(y_FM_demodulated)
     y_FM_demodulated(ii-20) = audio_filter_coe(21)*y_FM_demodulated(ii)+audio_filter_coe(20)*y_FM_demodulated(ii-1)+audio_filter_coe(19)*y_FM_demodulated(ii-2)+audio_filter_coe(18)*y_FM_demodulated(ii-3)...
                      +audio_filter_coe(17)*y_FM_demodulated(ii-4)+audio_filter_coe(16)*y_FM_demodulated(ii-5)+audio_filter_coe(15)*y_FM_demodulated(ii-6)+audio_filter_coe(14)*y_FM_demodulated(ii-7)...
                      +audio_filter_coe(13)*y_FM_demodulated(ii-8)+audio_filter_coe(12)*y_FM_demodulated(ii-9)+audio_filter_coe(11)*y_FM_demodulated(ii-10)+audio_filter_coe(10)*y_FM_demodulated(ii-11)...
                      +audio_filter_coe(9)*y_FM_demodulated(ii-12)+audio_filter_coe(8)*y_FM_demodulated(ii-13)+audio_filter_coe(7)*y_FM_demodulated(ii-14)+audio_filter_coe(6)*y_FM_demodulated(ii-15)...
                      +audio_filter_coe(5)*y_FM_demodulated(ii-16)+audio_filter_coe(4)*y_FM_demodulated(ii-17)+audio_filter_coe(3)*y_FM_demodulated(ii-18)+audio_filter_coe(2)*y_FM_demodulated(ii-19)...
                      +audio_filter_coe(1)*y_FM_demodulated(ii-20);
end

samples=3000;
fs=2E5;
t = (-0.5:1/samples:0.5-1/samples)*fs;

figure(6)
subplot(2,1,1) % Time series of filtered audio signal from IQ Data
plot(-1500:1:1500, y_FM_demodulated(1:3001)) % Real Plot of Signal 
title('Time Series of audio filtered demodulated signals@200Khz')
xlabel('Time')
ylabel('Amplitude')

demodulation_data_filtered_fft = 20*log10(fftshift(abs(fft(y_FM_demodulated,samples)/samples))); % FFT of Desired Radio Station that is shifted 
filtered_coe_fft = 20*log10(fftshift(abs(fft(audio_filter_coe,samples)/samples))); % FFT of Desired Radio Station that is shifted 

subplot(2,1,2) % Filter Overlay w/ Signal 
plot(t,filtered_coe_fft)
hold on
plot(t,demodulation_data_filtered_fft)
title('LPF Overlay on Desired Radio Station Pre-Decimate between -100KHz & 100KHz')
xlabel('Frequency (f)')
ylabel('Magnitude')

figure(7)
plot(filtered_coe_fft)
title('audio filter fft')


decimatevalue1=10;
df = y_FM_demodulated(1:10:(end-20));

figure(8)
plot(df(1:length(df)))
set(gcf,'color','white');
title('Time Aeries Decimated Audio Signals @20KHz')


figure(9)
plot_FFT_IQ(df,1,.015*2E5/decimatevalue1,0.5/decimatevalue1,0,'Audio Demodulated Signal @20KHz');


%sound(df,2E5/decimatevalue2);


