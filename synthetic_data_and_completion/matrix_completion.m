function predicted_matrix = matrix_completion(T_observed, r)

    if nargin < 2
        r = 3;
    end

    M = zeros(size(T_observed));
    observed = ~isnan(T_observed);
    display_mode = false;

    for k = 1:500

        disp("Iteration:")
        disp(k)
        disp("")

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