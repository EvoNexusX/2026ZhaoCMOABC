function v = GenerateNewSolution(Population, i, Archive, Global, DM, weights, alpha, S_MP_arch, S_MO_arch)
    x_i = Population(i).dec;
    j = randi(length(x_i));
    x_k = SelectReference(Population, i, Archive, DM, weights, alpha, S_MP_arch, S_MO_arch);
    phi = 2 * rand() - 1;
    v = x_i;
    v(j) = x_i(j) + phi * (x_i(j) - x_k(j));
    v = max(min(v, Global.upper), Global.lower);
end

function x_k = SelectReference(Population, i, Archive, DM, weights, alpha, S_MP_arch, S_MO_arch)
    if ~isempty(Archive)
        if length(Archive) == 1
            x_k = Archive(1).dec;
            return;
        end
        if rand() < 1 - alpha && ~isempty(S_MP_arch)
            score = S_MP_arch(:);
        else
            score = S_MO_arch(:);
        end
        if isempty(score)
            k = randi(length(Archive));
        else
            c1 = randi(length(Archive));
            c2 = randi(length(Archive));
            if score(c1) <= score(c2), k = c1; else, k = c2; end
        end
        x_k = Archive(k).dec;
    else
        cand = setdiff(1:length(Population), i);
        if isempty(cand)
            x_k = Population(i).dec;
            return;
        end
        [~, s, ~, ~] = ComputeMixedScore(Population(cand).objs, DM, weights, alpha);
        c1 = randi(length(cand));
        c2 = randi(length(cand));
        if s(c1) <= s(c2), k = cand(c1); else, k = cand(c2); end
        x_k = Population(k).dec;
    end
end
