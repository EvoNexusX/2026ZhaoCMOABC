function [L_mat, S_vec, S_MP, S_MO] = ComputeMixedScore(objs, DM, weights, alpha)
    n = size(objs, 1);
    num_dm = length(DM);
    L_mat = zeros(n, num_dm);

    for m = 1:num_dm
        L_m = NDSort(objs(:, DM{m}), n);
        L_m = L_m(:);
        if length(L_m) ~= n
            L_m = L_m(1:min(n, length(L_m)));
            if length(L_m) < n
                L_m = [L_m; ones(n-length(L_m), 1) * L_m(end)];
            end
        end
        L_mat(:, m) = NormalizeRank(L_m, n);
    end

    S_MP = L_mat * weights(:);
    all_obj_cols = unique([DM{:}]);
    max_col = size(objs, 2);
    all_obj_cols = all_obj_cols(all_obj_cols >= 1 & all_obj_cols <= max_col);
    if isempty(all_obj_cols)
        all_obj_cols = 1:max_col;
    end
    objs_all = objs(:, all_obj_cols);
    L_all = NDSort(objs_all, n);
    L_all = L_all(:);
    crowding = CalculateCrowdingDistance(objs_all, L_all);
    crowding_norm = NormalizeCrowdingDistance(crowding);
    front_priority = L_all - min(L_all);
    S_MO = front_priority + 0.999 * (1 - crowding_norm);
    S_MO = NormalizeScore(S_MO);
    S_vec = (1 - alpha) * S_MP + alpha * S_MO;
end

function rankNorm = NormalizeRank(rankValue, popSize)
    rankValue = rankValue(:);
    if popSize <= 1
        rankNorm = zeros(size(rankValue));
    else
        rankNorm = (rankValue - 1) / (popSize - 1);
        rankNorm = min(max(rankNorm, 0), 1);
    end
end

function scoreNorm = NormalizeScore(score)
    score = score(:);
    score = score - min(score);
    maxScore = max(score);
    if maxScore > 0
        scoreNorm = score ./ maxScore;
    else
        scoreNorm = zeros(size(score));
    end
end

function crowdingNorm = NormalizeCrowdingDistance(crowding)
    crowding = crowding(:);
    crowdingNorm = zeros(size(crowding));
    if isempty(crowding)
        return;
    end

    finiteCrowding = crowding(isfinite(crowding));
    if isempty(finiteCrowding)
        crowdingNorm(:) = 1;
        return;
    end

    maxFinite = max(finiteCrowding);
    if maxFinite <= 0
        crowdingNorm(isinf(crowding)) = 1;
        return;
    end

    crowdingNorm(isfinite(crowding)) = crowding(isfinite(crowding)) ./ maxFinite;
    crowdingNorm(isinf(crowding)) = 1;
    crowdingNorm = min(max(crowdingNorm, 0), 1);
end
