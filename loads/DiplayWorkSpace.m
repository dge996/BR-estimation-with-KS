%--------------------------------------------------------------------------
%---------------Choix de la variable---------------------------------------
%--------------------------------------------------------------------------

% --------------------------------------------------------------------
% Affichage des variables disponibles dans un fichier .mat
function [X, select] = DiplayWorkSpace(path, file)
global select%Solution peu academique qui permet de recuperer un param��?tre
X=[];
if file~= 0
    AllVars=load ([path file]);
    vars = fieldnames(AllVars) ;
    cmd=['AllVars.'];
    select=0;
    lb(vars);
    cmd=[cmd select];
    X=eval(cmd);
    while isstruct(X)
        vars = fieldnames(X) ;
        select = 0;
        lb(vars);
        cmd=[cmd '.' select];
        X=eval(cmd);
    end
end