%%
% EE455 
%Homework 1
%Draw the capacity for time invariant flat fading channel
%and AWGN channel (1 page report + matlab code) 
%Korkut Emre Arslantürk / 250206039
clc
clear all
close all
SNR_db = linspace(0,30,30);    SNR = 10.^(SNR_db/10);
B=1; N_Block=10000;
r = raylrnd(0.7985,N_Block,1);%to obtain the set of SNRs with the desired average.
prob=1/10000;
temp=0; i=1;
Flat_capacity=zeros(1,30); AWGN_capacity=zeros(1,30);
while i<31
        Flat_capacity(i)=sum(B*prob* (log2(1+r*SNR(i))));
        i=i+1;
end
i=1;
while i<31
        AWGN_capacity(i)=B* (log2(1+SNR(i)));
        i=i+1;
end
figure
FlatFading=plot(SNR_db,Flat_capacity,'-+');
hold on;
AWGN=plot(SNR_db,AWGN_capacity,'-*');
legend([AWGN,FlatFading],'AWGN Channel','Flat Fading Channel');
grid on;
xlabel('Average SNR (dB)') ;
ylabel('C/B (Bits/Sec/Hz)') ;
title('The Capacity for Time Invariant Channels') ;
set(gca,'FontSize', 12,'FontName','Arial') ;
