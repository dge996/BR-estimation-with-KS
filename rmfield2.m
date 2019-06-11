function [struc] = rmfield2(struc,varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

for hh=1:nargin-1
    fld=varargin{hh};
    if isfield(struc,fld)
        struc=rmfield(struc,fld);
    end
end
