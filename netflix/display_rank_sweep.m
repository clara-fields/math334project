function rmses = display_rank_sweep(M, Mtrain)

    ranks = [5 10 20 30];
    
    % Test set = hidden in Mtrain but known in M (excludes never-observed cells)
    testMask = isnan(Mtrain) & ~isnan(M);
    
    % Run completion at each rank
    nR = numel(ranks);
    preds = cell(1, nR);
    rmses = zeros(1, nR);

    for k = 1:nR
        fprintf('Running rank %d...\n', ranks(k));
        preds{k} = matrix_completion(Mtrain, ranks(k));
        err = preds{k}(testMask) - M(testMask);
        rmses(k) = sqrt(mean(err.^2));
        fprintf('  r = %d, test RMSE = %.4f\n', ranks(k), rmses(k));
    end
    
    % Colormap
    anchors = [0.0 0.0 0.5; % Dark blue
        0.5 0.7 1.0; % Light blue
        1.0 1.0 1.0; % White
        1.0 0.6 0.5; % Light red
        0.5 0.0 0.0]; % Dark red
    colors = interp1(linspace(0, 1, 5), anchors, linspace(0, 1, 256));
    missingColor = [0.85 0.85 0.85]; % gray for unobserved cells
    
    % Heatmaps: actual, training input, then one panel per rank
    figure('Name', 'Rank sweep', 'Color', 'w');
    nCols = 3;
    nRows = ceil((nR + 2) / nCols);
    tl = tiledlayout(nRows, nCols, 'TileSpacing', 'compact');
    title(tl, 'Matrix completion across ranks (gray = no rating)');
    
    plotMatrix(M, 'Actual (all known ratings)');
    plotMatrix(Mtrain, 'Training input (10% hidden)');
    for k = 1:nR
        plotMatrix(preds{k}, sprintf('r = %d   RMSE = %.3f', ranks(k), rmses(k)));
    end
    
    cb = colorbar;
    cb.Layout.Tile = 'east';
    cb.Label.String = 'Rating';
    
    % RMSE vs rank, plus predicted-vs-true scatter for each rank
    figure('Name', 'Rank sweep: test error', 'Color', 'w');
    tl2 = tiledlayout(1, 1,'TileSpacing', 'compact');
    title(tl2, 'Test-set accuracy');
    
    nexttile;
    plot(ranks, rmses, '-o', 'LineWidth', 1.5);
    xlabel('Rank r'); ylabel('Test RMSE'); grid on;
    title('RMSE vs rank');
    
    % helper to see colors/missingColor
    function plotMatrix(A, ttl)
        nexttile;
        imagesc(A, 'AlphaData', ~isnan(A), [1 5]);
        set(gca, 'Color', missingColor);
        colormap(gca, colors);
        title(ttl);
        xlabel('User');
        ylabel('Movie');
    end
end

%[appendix]{"version":"1.0"}
%---
