function y = loadFile_FM_audio(filename)

fid = fopen(filename,'r');
y=textscan(fid,'%f');
fclose(fid);
y=cell2mat(y);



