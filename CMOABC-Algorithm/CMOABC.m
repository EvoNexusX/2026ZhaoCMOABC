% <algorithm>
% CMOABC - Concession-aware Multi-Party Multi-Objective Artificial Bee Colony

function CMOABC(Global, epsilon, sigma)
    N = Global.N;
    limit = N * Global.D;

    [concession, weights] = GetConcessionWeights(Global);
    DM = Global.DM;
    alpha0 = ComputeAlpha0(concession);
    alpha = ComputeAlpha(alpha0, Global);
    if nargin < 2 || isempty(epsilon)
        [epsilon, sigma] = Global.ParameterSet(0.9, 0.12);
    elseif nargin < 3 || isempty(sigma)
        sigma = 0.12;
    end
    fprintf('[CMOABC] alpha0=%.4f, alpha=%.4f, epsilon=%.3f, sigma=%.3f, concession=[%s]\n', ...
        alpha0, alpha, epsilon, sigma, num2str(concession));

    Population = BuildStartPopulation(Global, N);
    trial_counter = zeros(1, length(Population));
    [L_pop, S_pop, ~, ~] = ComputeMixedScore(Population.objs, DM, weights, alpha);
    Archive = UpdateArchive(Population, [], Global.N, DM, weights, alpha);

    while Global.NotTermination(Archive)
        alpha = ComputeAlpha(alpha0, Global);
        if ~isempty(Archive)
            [~, ~, S_MP_arch, S_MO_arch] = ComputeMixedScore(Archive.objs, DM, weights, alpha);
        else
            S_MP_arch = [];
            S_MO_arch = [];
        end

        Ncur = length(Population);
        NewSolutions = [];
        for i = 1:Ncur
            v_i = GenerateNewSolution(Population, i, Archive, Global, DM, weights, alpha, S_MP_arch, S_MO_arch);
            New_i = INDIVIDUAL(v_i);
            NewSolutions = [NewSolutions, New_i];
            [Population, trial_counter, L_pop, S_pop] = GreedySelection( ...
                Population, New_i, i, trial_counter, DM, weights, alpha, L_pop, S_pop);
        end

        prob = CalculateProbability(S_pop);
        for i = 1:Ncur
            selected = RouletteWheelSelection(prob);
            v_i = GenerateNewSolution(Population, selected, Archive, Global, DM, weights, alpha, S_MP_arch, S_MO_arch);
            New_i = INDIVIDUAL(v_i);
            NewSolutions = [NewSolutions, New_i];
            [Population, trial_counter, L_pop, S_pop] = GreedySelection( ...
                Population, New_i, selected, trial_counter, DM, weights, alpha, L_pop, S_pop);
        end

        for i = 1:length(Population)
            if trial_counter(i) > limit
                NewDec = DirectionalScout(Archive, Global, sigma, epsilon);
                New_i = INDIVIDUAL(NewDec);
                Population(i) = New_i;
                trial_counter(i) = 0;
                NewSolutions = [NewSolutions, New_i];
                [L_new, S_new, ~, ~] = ComputeMixedScore(New_i.objs, DM, weights, alpha);
                L_pop(i, :) = L_new;
                S_pop(i) = S_new;
            end
        end

        Archive = UpdateArchive(NewSolutions, Archive, Global.N, DM, weights, alpha);

        Combined = [Population, Archive];
        [~, uniqueIdx] = unique(Combined.decs, 'rows', 'stable');
        Combined = Combined(uniqueIdx);
        [L_comb, S_comb, ~, ~] = ComputeMixedScore(Combined.objs, DM, weights, alpha);
        S_comb = S_comb(:);

        [~, sortIdx] = sort(S_comb);
        keepN = min(N, length(sortIdx));
        Population = Combined(sortIdx(1:keepN));
        L_pop = L_comb(sortIdx(1:keepN), :);
        S_pop = S_comb(sortIdx(1:keepN));
        trial_counter = zeros(1, length(Population));
    end
end
