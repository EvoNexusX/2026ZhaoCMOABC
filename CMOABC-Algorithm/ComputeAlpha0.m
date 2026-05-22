function alpha0 = ComputeAlpha0(concession)
    m = mean(concession(:));
    alpha0 = 1 - (1 - m)^2;
    alpha0 = min(max(alpha0, 0), 1);
end
