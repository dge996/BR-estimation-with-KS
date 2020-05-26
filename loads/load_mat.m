function [handles] = load_mat(handles, path, file, sigtype, matfileInfo, peakvarname)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

if strcmpi(sigtype, 'ecg')
    for ff=1:length(matfileInfo)
        if contains(matfileInfo(ff).name,'ecg','IgnoreCase',true) && ...
                contains(matfileInfo(ff).name,'fs','IgnoreCase',true)
            ecgfs = extract_var_from_matfile(path, file, matfileInfo(ff).name);
            set(handles.ecgfs,'String',string(ecgfs))
        elseif contains(matfileInfo(ff).name,peakvarname,'IgnoreCase',true)
            R_i = extract_var_from_matfile(path, file, matfileInfo(ff).name);
            handles.R_i=R_i;
        elseif strcmpi(matfileInfo(ff).name,'bw') || ...
                strcmpi(matfileInfo(ff).name,'resp') || ...
                strcmpi(matfileInfo(ff).name,'co2')
            bw = extract_var_from_matfile(path, file, matfileInfo(ff).name);
            handles.bw_brut=bw;
        elseif (contains(matfileInfo(ff).name,'bw','IgnoreCase',true) && ...
                contains(matfileInfo(ff).name,'fs','IgnoreCase',true)) || ...
                (contains(matfileInfo(ff).name,'resp','IgnoreCase',true) && ...
                contains(matfileInfo(ff).name,'fs','IgnoreCase',true)) || ...
                (contains(matfileInfo(ff).name,'co2','IgnoreCase',true) && ...
                contains(matfileInfo(ff).name,'fs','IgnoreCase',true))
            bwfs = extract_var_from_matfile(path, file, matfileInfo(ff).name);
            set(handles.bwfs,'String',string(bwfs))
        end
    end
elseif strcmpi(sigtype, 'ppg')
    for ff=1:length(matfileInfo)
        if (contains(matfileInfo(ff).name,'ppg','IgnoreCase',true) && ...
                contains(matfileInfo(ff).name,'fs','IgnoreCase',true)) || ...
                (contains(matfileInfo(ff).name,'pleth','IgnoreCase',true) && ...
                contains(matfileInfo(ff).name,'fs','IgnoreCase',true))
            ppgfs = extract_var_from_matfile(path, file, matfileInfo(ff).name);
            set(handles.ecgfs,'String',string(ppgfs))
        elseif contains(matfileInfo(ff).name,peakvarname,'IgnoreCase',true)
            R_i = extract_var_from_matfile(path, file, matfileInfo(ff).name);
            handles.R_i=R_i;
        elseif strcmpi(matfileInfo(ff).name,'bw') || ...
                strcmpi(matfileInfo(ff).name,'resp') || ...
                strcmpi(matfileInfo(ff).name,'co2')
            bw = extract_var_from_matfile(path, file, matfileInfo(ff).name);
            handles.bw_brut=bw;
        elseif (contains(matfileInfo(ff).name,'bw','IgnoreCase',true) && ...
                contains(matfileInfo(ff).name,'fs','IgnoreCase',true)) || ...
                (contains(matfileInfo(ff).name,'resp','IgnoreCase',true) && ...
                contains(matfileInfo(ff).name,'fs','IgnoreCase',true)) || ...
                (contains(matfileInfo(ff).name,'co2','IgnoreCase',true) && ...
                contains(matfileInfo(ff).name,'fs','IgnoreCase',true))
            bwfs = extract_var_from_matfile(path, file, matfileInfo(ff).name);
            set(handles.bwfs,'String',string(bwfs))
        end
    end
else
    error('wrong sigtype, must be ecg or ppg')
end

end

