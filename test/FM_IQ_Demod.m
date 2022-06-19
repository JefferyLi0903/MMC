function [y_FM_demodulated] = FM_IQ_Demod(y)
%This function demodualtes an FM signal. It is assumed that the FM signal
%is complex (e.g. an IQ signal) centered at DC and occupies less than 90%
%of total bandwidth. 


d=normalize(y);%normalize the signal to put in unit circle range 
realsignal=real(d); %real part of normalized siganl.
imagsignal=imag(d); %imaginary part of normalized signal. 
realsignal_delay=realsignal(2:end,1);
imagsignal_delay=imagsignal(2:end,1);
size_signal=size(d);

%最小角度法解调：X(n)=Q(n)I(n-1)-I(n)Q(n-1); 
y_FM_demodulated =  realsignal(1:size_signal-1).*imagsignal_delay-imagsignal(1:size_signal-1).*realsignal_delay;



end
