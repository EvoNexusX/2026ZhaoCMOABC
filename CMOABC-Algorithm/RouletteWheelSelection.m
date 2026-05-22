function selected = RouletteWheelSelection(prob)
    r = rand();
    cumprob = cumsum(prob);
    selected = find(cumprob >= r, 1, 'first');
    if isempty(selected)
        selected = length(prob);
    end
end
