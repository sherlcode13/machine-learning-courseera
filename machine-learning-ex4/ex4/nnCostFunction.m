function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

% Add ones column for theta0 in X
X = [ones(m,1) X];

%-------------------Part 1 ---------------------
% Initializing activation matrix for input layer
a1 = X;

%Calculating activation matrix for first hidden layer 
z2 = a1*Theta1';
a2 = sigmoid(z2);

a2 = [ones(m,1) a2];

%Calculating activation matrix for output layer
z3 = a2*Theta2';
a3 = sigmoid(z3);

% Converting y into 1-10 input vector
yd = eye(num_labels);
y = yd(y,:);

%Calculating intermediate result for cost function
logFin = (-y).*(log(a3)) - (1-y).*log(1-a3);

% Converting theta1 and theta2 to particular form for regularization
theta1s = Theta1(:,2:end);
theta2s = Theta2(:,2:end);

%Calculating J

J = ((1/m).*sum(sum(logFin))) + (lambda/(2*m)).*(sum(sum(theta1s.^2)) + sum(sum(theta2s.^2)));


%--------------------Part 2 -------------------

D1 = 0;
D2 = 0;
z2 = [ones(m,1) z2];

% Calculate error between hypothesis and output vector
delta3 = a3 - y;
delta2 = (delta3*Theta2).*sigmoidGradient(z2);

delta2 = delta2(:,2:end);
%Calculate the partial derivative corresponding to layers
D1 = D1 + delta2'*a1;
D2 = D2 + delta3'*a2;

% Calculate the gradient
Theta1_grad = (1/m).*D1;
Theta2_grad =(1/m).*D2;

theta1s = [zeros(size(theta1s,1),1) theta1s];
theta2s = [zeros(size(theta2s,1),1) theta2s];

Theta1_grad = Theta1_grad + (lambda/m).*(theta1s);
Theta2_grad = Theta2_grad + (lambda/m).*(theta2s);











% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
