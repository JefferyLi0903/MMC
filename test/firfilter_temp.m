
close all
clear all

%working filter coefficient
Fpass1 = 0.0004;
Fpass2 = 0.30;
Fstop1 = 0.32;
Fstop2 = 1;

audio_filter_coe = firls(20, [Fpass1 Fpass2 Fstop1 Fstop2], [1 1 0 0]) % LPF
%audio_filter_coe=[17 34 57 85 118 152 185 215 239 254 259 254 239 215 185 152 118 85 57 34 17];
audio_filter_coe_fft = 20*log10(fftshift(abs(fft(audio_filter_coe,1024)))); % FFT of LPF 
figure(1)
plot(audio_filter_coe_fft)


 

audio_filter_coe=[-9  21  39 23 -22  -62  -54  23  148  263  310  263  147   23   -54   -62   -22  23   39  21 -9]
audio_filter_coe_fft = 20*log10(fftshift(abs(fft(audio_filter_coe,1024)))); % FFT of LPF 
figure(2)
plot(audio_filter_coe_fft)

maximum_value = audio_filter_coe(1)+audio_filter_coe(5)+audio_filter_coe(6)+audio_filter_coe(7)+audio_filter_coe(15)+audio_filter_coe(16)+audio_filter_coe(17)+audio_filter_coe(21)
maximum_value=maximum_value*255


    'FFF7'
    '0015'
    '0027'
    '0017'
    'FFEA'
    'FFC2'
    'FFCA'
    '0017'
    '0094'
    '0107'
    '0136'
    '0107'
    '0093'
    '0017'
    'FFCA'
    'FFC2'
    'FFEA'
    '0017'
    '0027'
    '0015'
    'FFF7'

    '0009'
    'FFEB'
    'FFD9'
    'FFE9'
    '0016'
    '003E'
    '0036'
    'FFE9'
    'FF6C'
    'FEF9'
    'FECA'
    'FEF9'
    'FF6D'
    'FFE9'
    '0036'
    '003E'
    '0016'
    'FFE9'
    'FFD9'
    'FFEB'
    '0009'
