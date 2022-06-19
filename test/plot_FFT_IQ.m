function plot_FFT_IQ(x,n0,nf,fs,f0,title_of_plot)
%
%  plot_FFT_IQ(x,n0,nf)
%   plot_FFT_IQ(fmdata,1,0.004*2E5,0.2,93.4, 'plot of fft');
%  Plots the FFT of sampled IQ data
%
%      x  -- input signal
%      n0 -- first sample (start time = n0/fs)
%      nf -- block size for transform (signal duration = nf/fs)
%      fs -- sampling frequency [MHz] 
%      f0 -- center frequency [MHz]
%      title_of_plot--title of plot (string) (optional)
%
%-This extracts a segment of x starting at n0, of length nf, and plots the FFT.

n0=round(n0); %round to integer. 1st sample = 1
nf=round(nf); %round to integer. Last Sample = 488 
x_segment=x(n0:(n0+nf-1)); %extracts a small segment of data from IQ data
p=fftshift(fft(x_segment)); %FFT
z = 20*log10(abs(p)/max(abs(p))); %normalize

Low_freq=(f0-fs/2); %lowest frequency to plot
High_freq=(f0+fs/2); %highest frequency to plot

N=length(z); % num of samples in signal 
freq=[0:1:N-1]*(fs)/N+Low_freq;

plot(freq,z);
axis tight
xlabel('Freqency [MHz]','FontSize', 14)
ylabel('Magnitude [dB down from max]','FontSize', 14)
grid on
set(gcf,'color','white');

if nargin==6
    title(title_of_plot,'FontSize', 14)
else
    title({'Spectrum',['Center frequency = ' num2str(f0) ' MHz'] },'FontSize', 14)
end

%Add line @ center freq
y1=get(gca,'ylim');
hold on;
plot([f0 f0],y1,'r-','linewidth',2);
hold off;