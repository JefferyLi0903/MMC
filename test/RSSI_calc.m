clear all;
close all;
clc;

% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(-400Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(1)=mean(RSSI);
% x_axis=-400;
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(-350Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(2)=mean(RSSI);
% x_axis=[x_axis -350];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(-300Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(3)=mean(RSSI);
% x_axis=[x_axis -300];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(-280Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(4)=mean(RSSI);
% x_axis=[x_axis -280];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(-260Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(5)=mean(RSSI);
% x_axis=[x_axis -260];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(-240Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(6)=mean(RSSI);
% x_axis=[x_axis -240];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(-220Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(7)=mean(RSSI);
% x_axis=[x_axis -220];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(-200Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(8)=mean(RSSI);
% x_axis=[x_axis -200];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(-190Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(9)=mean(RSSI);
% x_axis=[x_axis -190];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(-180Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(10)=mean(RSSI)
% x_axis=[x_axis -180];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(-170Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(11)=mean(RSSI);
% x_axis=[x_axis -170];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(-160Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(12)=mean(RSSI);
% x_axis=[x_axis -160];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(-150Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(13)=mean(RSSI);
% x_axis=[x_axis -150];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(-140Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(14)=mean(RSSI);
% x_axis=[x_axis -140];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(-130Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(15)=mean(RSSI);
% x_axis=[x_axis -130];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(-120Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(16)=mean(RSSI);
% x_axis=[x_axis -120];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(-110Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(17)=mean(RSSI);
% x_axis=[x_axis -110];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(-100Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(18)=mean(RSSI);
% x_axis=[x_axis -100];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(-90Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(19)=mean(RSSI);
% x_axis=[x_axis -90];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(-80Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(20)=mean(RSSI)
% x_axis=[x_axis -80];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(-70Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(21)=mean(RSSI);
% x_axis=[x_axis -70];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(-60Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(22)=mean(RSSI);
% x_axis=[x_axis -60];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(-50Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(23)=mean(RSSI);
% x_axis=[x_axis -50];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(-40Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(24)=mean(RSSI);
% x_axis=[x_axis -40];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(-30Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(25)=mean(RSSI);
% x_axis=[x_axis -30];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(-20Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(26)=mean(RSSI);
% x_axis=[x_axis -20];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(-10Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(27)=mean(RSSI);
% x_axis=[x_axis -10];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_15dB(+0Hz)10.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(28)=mean(RSSI);
% x_axis=[x_axis 0];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(+10Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(29)=mean(RSSI);
% x_axis=[x_axis 10];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(+20Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(30)=mean(RSSI)
% x_axis=[x_axis 20];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(+30Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(31)=mean(RSSI);
% x_axis=[x_axis 30];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(+40Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(32)=mean(RSSI);
% x_axis=[x_axis 40];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(+50Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(33)=mean(RSSI);
% x_axis=[x_axis 50];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(+60Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(34)=mean(RSSI);
% x_axis=[x_axis 60];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(+70Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(35)=mean(RSSI);
% x_axis=[x_axis 70];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(+80Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(36)=mean(RSSI);
% x_axis=[x_axis 80];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(+90Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(37)=mean(RSSI);
% x_axis=[x_axis 90];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(+100Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(38)=mean(RSSI);
% x_axis=[x_axis 100];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(+110Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(39)=mean(RSSI);
% x_axis=[x_axis 110];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(+120Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(40)=mean(RSSI)
% x_axis=[x_axis 120];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(+130Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(41)=mean(RSSI);
% x_axis=[x_axis 130];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(+140Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(42)=mean(RSSI);
% x_axis=[x_axis 140];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(+150Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(43)=mean(RSSI);
% x_axis=[x_axis 150];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(+160Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(44)=mean(RSSI);
% x_axis=[x_axis 160];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(+170Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(45)=mean(RSSI);
% x_axis=[x_axis 170];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(+180Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(46)=mean(RSSI);
% x_axis=[x_axis 180];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(+190Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(47)=mean(RSSI);
% x_axis=[x_axis 190];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(+200Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(48)=mean(RSSI);
% x_axis=[x_axis 200];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(+220Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(49)=mean(RSSI);
% x_axis=[x_axis 220];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(+240Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(50)=mean(RSSI)
% x_axis=[x_axis 240];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(+260Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(51)=mean(RSSI);
% x_axis=[x_axis 260];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(+280Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(52)=mean(RSSI);
% x_axis=[x_axis 280];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(+300Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(53)=mean(RSSI);
% x_axis=[x_axis 300];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(+320Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(54)=mean(RSSI);
% x_axis=[x_axis 320];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(+340Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(55)=mean(RSSI);
% x_axis=[x_axis 340];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(+360Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(56)=mean(RSSI);
% x_axis=[x_axis 360];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(+380Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(57)=mean(RSSI);
% x_axis=[x_axis 380];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(+400Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(58)=mean(RSSI);
% x_axis=[x_axis 400];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(+450Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(59)=mean(RSSI);
% x_axis=[x_axis 450];
% 
% fmdata=loadFile_FM_IQ('./CaptureData/IQ/IQ_934_25dB(+500Hz)00.txt');
% RSSI=real(fmdata).*real(fmdata) + imag(fmdata).*imag(fmdata);
% RSSI_result(60)=mean(RSSI)
% x_axis=[x_axis 500];

load RSSI_result.mat

figure(1)
plot(x_axis,10*log10(RSSI_result))
title('RSSI evaluation centered of real station channel')
xlabel('Frequency offset(KHz)')
ylabel('RSSI in dB')
%Add line @ center freq
y1=get(gca,'ylim');
hold on;
plot([0 0],y1,'r-','linewidth',1);
hold off;


