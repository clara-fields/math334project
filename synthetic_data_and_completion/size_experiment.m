rng(112226);
r = 3;
sparsity = 0.5;
user_counts = [10 20 30 40 60 80 100 150 200 300];
movie_counts = round(0.8 * user_counts);
num_trials = 5;
rmses = zeros(num_trials, numel(user_counts));

for s = 1:numel(user_counts)
    num_users = user_counts(s);
    num_movies = movie_counts(s);

    for t = 1:num_trials
        % New ground truth each trial (a different size means a different T)
        [T, ~] = generate_synthetic_data(num_users, num_movies);
        observed = rand(num_users, num_movies) < 1 - sparsity;
        T_observed = T;
        T_observed(~observed) = NaN;

        % evalc runs matrix_completion but swallows its per-iteration printing
        evalc('predicted = matrix_completion(T_observed, r);');
        missing = ~observed;
        rmses(t, s) = sqrt(mean((predicted(missing) - T(missing)).^2));
    end

    fprintf('Size %dx%d  ->  mean RMSE %.4f\n', num_users, num_movies, mean(rmses(:, s)));
end

rmse_mean = mean(rmses, 1);
rmse_std  = std(rmses, 0, 1);

%% RMSE vs matrix size
figure('Name', 'Size experiment', 'Color', 'w');
tl = tiledlayout(1, 1, 'TileSpacing', 'compact');
title(tl, 'Test-set accuracy');
nexttile;
errorbar(user_counts, rmse_mean, rmse_std, '-o', 'LineWidth', 1.5);
xticks(user_counts);
xticklabels(compose('%dx%d', user_counts', movie_counts'));
xtickangle(45);
xlabel('Matrix size (users x movies)');
ylabel('Test RMSE');
grid on;
title(sprintf('RMSE vs matrix size (rank r = %d, %.0f%% missing, %d trials per point)', ...
    r, 100*sparsity, num_trials));