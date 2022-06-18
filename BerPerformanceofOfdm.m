clc;
clear all;
close all;
%Korkut Emre Arslantürk / 250206039
%Homework 2-BER Performance for OFDM in frequency selective channels
N_subcar = 64; blocks = 1000;  
%Data is observed randomly.
information = randi([0, 3], [1, blocks*N_subcar]);
inf_bit=zeros(N_subcar*blocks,2);
% Bits are observed from symbols.
for i=1:N_subcar*blocks
    if information(i) == 0
        inf_bit(i,:) = [0 0];
    elseif information(i) == 1
       inf_bit(i,:) = [0 1];
    elseif information(i) == 2
       inf_bit(i,:) = [1 1];
    elseif information(i)==3
         inf_bit(i,:) = [1 0];
    end
end
% QPSK modulation is observed at baseband.
data = pskmod(information,4,pi/4);
% Serial to parallel convertion is applied when FFT size equals 64.
paraleldata = reshape(data,[N_subcar,blocks]);
% Inverse fft is applied.
ifftpardata = sqrt(64)*ifft(paraleldata,N_subcar);
%%Adding Cyclic Prefix at the beginnng of ofdm symbol
cpdata = [ifftpardata((N_subcar-16+1):N_subcar,:); ifftpardata];
% Parallel to serial converter
paralelldata = reshape(cpdata,[1,80*blocks]);
% Channel Part
h = [0.5 0.3 0.2]; hs=sqrt(h);
yh = conv(paralelldata,hs);
yh = yh(1:end-2);
BER = []; SNR = 0:30;
i = 0;
while i<31
    % Noise is added
    z_data = awgn(yh,i);
    %Serial to parallel converter
    z_data_par = reshape(z_data,[80,1000]);
    %Removing cyclic prefix
    z_data_removedcp = z_data_par(17:end,:);
    %one-tap equalizer
    ote = (1/sqrt(64))*fft(z_data_removedcp,N_subcar);
    zote = ote./fft(h',64);
    %Demodulation
    zdemod1 = reshape(zote,[1,blocks*N_subcar]);
    zdemod = pskdemod(zdemod1,4,pi/4);
    zdemod_bit=zeros(64000,2);
    for j=1:64000
        if zdemod(j) == 0
          zdemod_bit(j,:) = [0 0];
        elseif zdemod(j) == 1
           zdemod_bit(j,:) = [0 1];
        elseif zdemod(j) == 2
          zdemod_bit(j,:) = [1 1];
        else
           zdemod_bit(j,:) = [1 0];
        end
    end
    %Error Calculation
    error=0;
    error = biterr(zdemod_bit,inf_bit);
    ber = error/length(information);  BER(i+1) = ber;
    i=i+1;
end
%Plotting
figure
semilogy(SNR,BER,'*')
grid on;
title('BER Analysis for OFDM Frequency Selective Channnel');
xlabel('AVG SNR (dB)');ylabel('BER');