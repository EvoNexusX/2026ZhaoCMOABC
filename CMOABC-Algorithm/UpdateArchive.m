function Archive = UpdateArchive(NewSolutions, Archive, maxSize, DM, weights, alpha)
    if isempty(NewSolutions) && isempty(Archive)
        Archive = [];
        return;
    end
    if isempty(Archive)
        Combined = NewSolutions;
    elseif isempty(NewSolutions)
        Combined = Archive;
    else
        Combined = [Archive, NewSolutions];
    end
    [~, uid] = unique(Combined.decs, 'rows', 'stable');
    Combined = Combined(uid);
    if isempty(Combined)
        Archive = [];
        return;
    end
    [~, S_comb, ~, ~] = ComputeMixedScore(Combined.objs, DM, weights, alpha);
    S_comb = S_comb(:);
    keep = S_comb <= min(S_comb) + 0.5;
    if ~any(keep)
        [~, idx] = min(S_comb);
        keep(idx) = true;
    end
    Archive = Combined(keep);
    if length(Archive) > maxSize
        s_arch = S_comb(keep);
        [~, idx] = sort(s_arch);
        Archive = Archive(idx(1:maxSize));
    end
end
