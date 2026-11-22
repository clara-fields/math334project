%Image completion

% Import a .jpg image and convert to grayscale
image = imread('shibarank10.jpg');
gray_image = im2gray(image);

% Convert the image to a matrix of doubles
gray_image = im2double(gray_image);

%Randomly remove 60% of entries
m = size(gray_image, 1)
n = size(gray_image, 2)
observed = rand(m, n) < 0.4;
T_observed = gray_image;
T_observed(~observed) = NaN;

%set threshold (this can change!)
r = 5

addpath("synthetic_data_and_completion/")
predicted_matrix = matrix_completion(T_observed, r)
imshow(predicted_matrix)