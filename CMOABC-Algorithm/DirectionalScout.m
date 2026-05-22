function NewDec = DirectionalScout(Archive, Global, sigma, epsilon)
    if isempty(Archive) || rand() < epsilon
        NewDec = unifrnd(Global.lower, Global.upper);
        return;
    end
    anchor = randi(length(Archive));
    x_ref = Archive(anchor).dec;
    perturb = (2 * rand(1, length(x_ref)) - 1) .* sigma .* (Global.upper - Global.lower);
    NewDec = max(min(x_ref + perturb, Global.upper), Global.lower);
end
