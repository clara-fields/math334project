[T, T_observed] = generate_synthetic_data();
predicted_matrix = matrix_completion(T_observed);
display_original_and_predicted(T, T_observed, predicted_matrix)