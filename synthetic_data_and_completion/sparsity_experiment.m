rng(112226);
r = 3;
sparsities = 0.05:0.05:0.95;
num_trials = 5;

% Generate one ground-truth matrix
[T, ~] = generate_synthetic_data();
[num_users, num_movies] = size(T);
rmses = zeros(num_trials, numel(sparsities));
for s = 1:numel(sparsities)
    keep_pct = 1 - sparsities(s);
    for t = 1:num_trials
        observed = rand(num_users, num_movies) < keep_pct;
        T_observed = T;
        T_observed(~observed) = NaN;
        predicted = matrix_completion(T_observed, r);
        missing = ~observed;
        rmses(t, s) = sqrt(mean((predicted(missing) - T(missing)).^2));
    end
    fprintf('Sparsity %.2f  ->  mean RMSE %.4f\n', sparsities(s), mean(rmses(:, s)));
end

rmse_mean = mean(rmses, 1);
rmse_std  = std(rmses, 0, 1);

%% RMSE vs sparsity
figure('Name', 'Sparsity experiment', 'Color', 'w');
tl = tiledlayout(1, 1, 'TileSpacing', 'compact');
title(tl, 'Test-set accuracy');
nexttile;
errorbar(sparsities, rmse_mean, rmse_std, '-o', 'LineWidth', 1.5);
xlabel('Sparsity (fraction of entries missing)');
ylabel('Test RMSE');
grid on;
title(sprintf('RMSE vs sparsity (rank r = %d, %d trials per point)', r, num_trials));
xlim([0 1]);