function [filtsig] = butterfilt(sig,sigfs,fMin,fMax,ordre)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

wp2 = fMin/(sigfs/2);
ws2 = fMax/(sigfs/2);
wn = [wp2 ws2];
[A,B] = butter(ordre,wn);
filtsig = filtfilt(A,B,sig);

end

