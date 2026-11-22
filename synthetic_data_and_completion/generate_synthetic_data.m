function [T, T_observed] = generate_synthetic_data(num_users, num_movies)
    if nargin < 1
        num_users = 100;
    end
    if nargin < 2
        num_movies = 80;
    end
    
    num_genres = 3; 
    keep_pct = 1.0;
    display_mode = false;

    % Generate random user-genre preferences 
    % Element P(i, j) is how much user_i likes genre_j
    P = 1 + 4 * (rand(num_users, num_genres));

    % Generate random movie-genre relations (each row sums to 1)
    % Element G(i, j) is what percent of movie_i relates to genre_j
    G = rand(num_movies, num_genres).^5;
    row_sum = sum(G, 2);
    G = G./ row_sum;

    % T is the true ratings matrix
    % Each user's preference can be viewed as a weighted average:
    % their preference for a genre multiplied by how much a movie relates
    % to that genre.
    % This is a linear combination of the user-genre preference and the 
    % movie-genre relations. T(i, j) is user_i rating for movie_j
    T = P*G';
    
    % Add a movie quality score
    movie_qualities_vector = 1 - (2 * rand(1, num_movies));
    movie_qualities_matrix = repmat(movie_qualities_vector, num_users, 1);
    T = T + movie_qualities_matrix;
    T = min(max(T, 1), 5);
    
    % Add some random noise
    max_random_noise = 0.75;
    T = T + max_random_noise * (2 * rand(size(T)) - 1);
    T = min(max(T, 1), 5);


    % Block some number of observations 
    observed = rand(num_users, num_movies) < keep_pct;
    T_observed = T;
    T_observed(~observed) = NaN;
    
    if display_mode

        % Display the matrices
        disp(T);
        disp(T_observed);

        % Plot a heatmap of the matrices
        figure;
        tiledlayout(1, 2);
    
        nexttile;
        imagesc(T, [1 5]);
        colorbar;
        title('True Ratings');
        xlabel('Movie');
        ylabel('User');
    
        nexttile;
        h = imagesc(T_observed, [1 5]);
    
        % Make missing entries transparent, revealing a black background
        h.AlphaData = ~isnan(T_observed);
        set(gca, 'Color', [0.0 0.0 0.0]);
    
        colorbar;
        title('Observed Ratings');
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

end
