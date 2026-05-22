function prob = CalculateProbability(S_vec)
    fitness = 1 ./ (S_vec + 1);
    prob = fitness / sum(fitness);
end
