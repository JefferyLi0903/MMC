function y = loadFile_FM_IQ(filename)

fid = fopen(filename,'r');
y=textscan(fid,'%f');
fclose(fid);
y=cell2mat(y);


y=y(1:(end-256));

if mod(length(y),2)==0
  y=y(1:end);
else
  y=y(1:end-1);
end

y = y-127.5; % Convert to 8-bit unsigned 
y = y(1:2:end) + i*y(2:2:end); % Readable IQ Data to work with in Matlab 
% Odd samples are real data, and Even samples are Imag data 

