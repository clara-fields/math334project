function predicted_matrix = matrix_completion(T_observed)

    M = zeros(size(T_observed));
    observed = ~isnan(T_observed);
    r = 3;
    display_mode = false;

    for k = 1:3000

        W = M;
        W(observed) = T_observed(observed);
        
        [U, S, V] = svd(W);
        S(r+1:end, r+1:end) = 0;
        M = U*S*V';

    end

    predicted_matrix = M;

    if display_mode
        disp(predicted_matrix)
    end

end