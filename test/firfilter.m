%working filter coefficient
Fpass1 = 0.0200;
Fpass2 = 30;
Fstop1 = 32;
Fstop2 = 200;
fs = 200;
audio_filter_coe = firls(20, [Fpass1 Fpass2 Fstop1 Fstop2]*(1/fs), [1 1 0 0],[1 10000]) % LPF
%audio_filter_coe=[17 34 57 85 118 152 185 215 239 254 259 254 239 215 185 152 118 85 57 34 17];
    '011'
    '022'
    '039'
    '055'
    '076'
    '098'
    '0B9'
    '0D7'
    '0EF'
    '0FE'
    '103'
    '0FE'
    '0EF'
    '0D7'
    '0B9'
    '098'
    '076'
    '055'
    '039'
    '022'
    '011'


    

