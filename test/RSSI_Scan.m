load RSSI_Scan.mat;
figure(1);
plot(linspace(87.02,108,1050),Dec_list);
title('RSSI Dec\_list')
xlabel('Frequency(KHz)')
ylabel('RSSI')
figure(2);
plot(linspace(87.02,108,1050),Log_list);
title('RSSI Log\_list')
xlabel('Frequency(KHz)')
ylabel('RSSI')