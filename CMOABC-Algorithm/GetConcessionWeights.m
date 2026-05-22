function [concession, weights] = GetConcessionWeights(Global)
    dm_num = length(Global.DM);
    probName = class(Global.problem);
    if any(strcmp(probName, {'MPDMP1','MPDMP2','MPDMP3','MPDMP4','MPDMP5','MPDMP6', ...
                             'MPDMP7','MPDMP8','MPDMP9','MPDMP10','MPDMP11','MPDMP12'}))
        concession = zeros(1, dm_num);
    elseif ismethod(Global.problem, 'GetConcession')
        concession = Global.problem.GetConcession();
    else
        concession = zeros(1, dm_num);
    end
    if isempty(concession), concession = zeros(1, dm_num); end
    weights = 1 - concession(:)';
    denom = sum(weights);
    if denom > 0
        weights = weights / denom;
    else
        weights = ones(1, dm_num) / dm_num;
    end
end
