function [var] = extract_var_from_matfile(path, file, varname)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

ld=load([path file],varname);
var2load=fieldnames(ld);
var2load=var2load{1};
var=getfield(ld,var2load);

end

