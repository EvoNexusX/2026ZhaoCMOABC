function [Population, trial_counter, L_pop, S_pop] = GreedySelection(Population, New_i, i, trial_counter, DM, weights, alpha, L_pop, S_pop)
    all_objs = [Population.objs; New_i.objs];
    [L_all, S_all, ~, ~] = ComputeMixedScore(all_objs, DM, weights, alpha);
    S_old = S_all(i);
    S_new = S_all(end);
    L_new = L_all(end, :);
    if S_new < S_old - 1e-10
        Population(i) = New_i;
        trial_counter(i) = 0;
        L_pop(i, :) = L_new;
        S_pop(i) = S_new;
    elseif S_old < S_new - 1e-10
        trial_counter(i) = trial_counter(i) + 1;
    else
        max_L_old = max(L_all(i, :));
        max_L_new = max(L_new);
        if max_L_new < max_L_old || (max_L_new == max_L_old && rand() < 0.5)
            Population(i) = New_i;
            trial_counter(i) = 0;
            L_pop(i, :) = L_new;
            S_pop(i) = S_new;
        else
            trial_counter(i) = trial_counter(i) + 1;
        end
    end
end
