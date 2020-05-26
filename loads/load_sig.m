function [handles, file, path] = load_sig(handles,sigtype)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

[file, path] = uigetfile({'*.mat'},['Open ', sigtype]);

if file ~= 0 
    handles.ECGfiletype = 'MAT';
    [handles.ecg_brut select] = DiplayWorkSpace(path, file);
    matfileInfo=whos(matfile([path file]));
    matfileVarNames=struct2cell(matfileInfo);
    matfileVarNames=matfileVarNames(1,:);
    if sum(contains(matfileVarNames,{'SFresults','labels','meta','signal',...
            'param','reference'})) == 6
        % capnoBase file
        [handles] = load_capno(handles, path, file, sigtype);
    elseif sum(contains(matfileVarNames,{'peaks_i'})) > 0
        peakvarname='peaks_i';
        [handles] = load_mat(handles, path, file, sigtype, matfileInfo, peakvarname);
    elseif sum(contains(matfileVarNames,{'R_i'})) > 0
        peakvarname='R_i';
        for ff=1:length(matfileInfo)
            if contains(matfileInfo(ff).name,'ecgfs')
                load([path file],matfileInfo(ff).name);
                set(handles.ecgfs,'String',string(ecgfs))
            elseif contains(matfileInfo(ff).name,'R_i')
                handles.R_i=load([path file],matfileInfo(ff).name);
                handles.R_i=handles.R_i.R_i;
            elseif strcmp(matfileInfo(ff).name,'bw')
                handles.bw_brut=load([path file],matfileInfo(ff).name);
                handles.bw_brut=handles.bw_brut.bw;
            elseif contains(matfileInfo(ff).name,'bwfs')
                load([path file],matfileInfo(ff).name);
                set(handles.bwfs,'String',string(bwfs))
            end
        end
    else
        title=[sigtype, ' peaks missing'];
        message=[sigtype ' peaks are missing from MAT-File. If they exists,',...
            ' please rename the variable peaks_i.'];
        uiwait(msgbox(message,title,'modal'));
        file = 0;
    end
else
    return;
end

end

