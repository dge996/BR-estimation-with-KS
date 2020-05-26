function [handles, path, file] = load_ref(handles)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here

[file, path] = uigetfile({'*.mat'},'Open reference respiratory signal');
if contains(file,'.mat')
    handles.BWfiletype = 'MAT';
    [handles.bw_brut select] = DiplayWorkSpace(path, file);
    matfileInfo=whos(matfile([path file]));
    for ff=1:length(matfileInfo)
        if contains(matfileInfo(ff).name,'param')
            load([path file],matfileInfo(ff).name);
            set(handles.bwfs,'String',string(param.samplingrate.co2))
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
    return;
end

end

