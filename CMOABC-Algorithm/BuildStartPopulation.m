function Population = BuildStartPopulation(Global, N)
    if ~isempty(Global.PFpop)
        Population = Global.PFpop;
        if length(Population) < N
            Population = [Population, Global.Initialization(N - length(Population))];
        elseif length(Population) > N
            [~, idx] = unique(Population.decs, 'rows', 'stable');
            Population = Population(idx);
            Population = Population(1:min(N, length(Population)));
            if length(Population) < N
                Population = [Population, Global.Initialization(N - length(Population))];
            end
        end
    else
        Population = Global.Initialization(N);
    end
    Global.PFpop = [];
end
