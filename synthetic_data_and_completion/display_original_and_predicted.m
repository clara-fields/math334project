function display_original_and_predicted(T, T_observed, predicted_matrix)

    missing = isnan(T_observed);
    rmse = sqrt(mean((predicted_matrix(missing) - T(missing)).^2));
    
    disp("RMSE:")
    disp(rmse)
    
    % Plot a heatmap of the matrices
    figure;
    tiledlayout(1, 2);
    
    nexttile;
    imagesc(T, [1 5]);
    colorbar;
    title('Actual Ratings');
    xlabel('Movie');
    ylabel('User');
    
    nexttile;
    imagesc(predicted_matrix, [1 5]);
    colorbar;
    title('Predicted Ratings');
    xlabel('Movie');
    ylabel('User');
    
    anchors = [0.0 0.0 0.5;   % Dark blue
        0.5 0.7 1.0;   % Light blue
        1.0 1.0 1.0;   % White
        1.0 0.6 0.5;   % Light red
        0.5 0.0 0.0];  % Dark red
    
    colors = interp1(linspace(0, 1, 5), anchors, linspace(0, 1, 256));
    
    colormap(colors);

end