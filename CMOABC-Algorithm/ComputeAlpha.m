function alpha = ComputeAlpha(alpha0, Global)
    T = max(Global.maxgen, 1);
    t = min(max(Global.gen - 1, 0), T);
    alpha = alpha0 * (1 - t / T);
    alpha = min(max(alpha, 0), 1);
end
