%% ========================================================================
%%PUSH
function PUSH(x)
%  ========================================================================
global trajectory;
x=reshape(x,[numel(x),1]);

% If trajectory is empty, set trajectory=x
if numel(trajectory)==0
    trajectory=x;
    return
end

% Search for x in trajectory. Append x to trajectory if not found.
if isempty(find(ismember(trajectory',x','rows'),1))        %BG modification 
    trajectory=[trajectory x];
end
%disp('trajectory')
%disp( trajectory)
end
