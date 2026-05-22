function crowding = CalculateCrowdingDistance(PopObj, FrontNo)
    [N, M] = size(PopObj);
    crowding = zeros(N, 1);
    fronts = unique(FrontNo(isfinite(FrontNo)));

    for f = fronts(:)'
        frontIdx = find(FrontNo == f);
        if numel(frontIdx) <= 2
            crowding(frontIdx) = inf;
            continue;
        end

        frontObj = PopObj(frontIdx, :);
        fMax = max(frontObj, [], 1);
        fMin = min(frontObj, [], 1);
        for m = 1:M
            [~, rank] = sort(frontObj(:, m));
            crowding(frontIdx(rank(1))) = inf;
            crowding(frontIdx(rank(end))) = inf;

            range = fMax(m) - fMin(m);
            if range <= 0
                continue;
            end

            for j = 2:numel(frontIdx)-1
                idx = frontIdx(rank(j));
                if isfinite(crowding(idx))
                    crowding(idx) = crowding(idx) + ...
                        (frontObj(rank(j + 1), m) - frontObj(rank(j - 1), m)) / range;
                end
            end
        end
    end
end
