% Marcos Vinicius Firmino Pietrucci
% 10914211
% Assigment 4

%Reading the Traces
DataSet = csvread('Trace1.csv');
% DataSet = csvread('Trace2.csv');
% DataSet = csvread('Trace3.csv');

%Creating the DataSet
sDataSet = sort(DataSet);
N = length(sDataSet);
t = [0:60]; %for intervals

%Calculating the moments
Mean = sum(sDataSet)/N;
Moment2 = sum(sDataSet .^2)/N;
Moment3 = sum(sDataSet .^3)/N;
coef_var = std(sDataSet)/Mean;

%Fitting the uniform using direct expressions
left_boundary = Mean - sqrt(12*(Moment2 - Mean^2))/2;
right_boundary = Mean + sqrt(12*(Moment2 - Mean^2))/2;
figure(1)
plot(sDataSet, [1:N]/N, ".", t, Unif_cdf(t, [left_boundary, right_boundary]))
title('Uniform Distribution Trace1');
legend({'DataSet','Uniform Distribution'},'Location','southeast')
grid

%Fitting the Exponential using direct expressions
lambda = 1/Mean;
figure(2)
plot(sDataSet, [1:N]/N, ".", t, Exp_cdf(t, [lambda]))
legend({'DataSet','Exponential Distribution'},'Location','southeast')
title('Exponential Distribution Trace1');
grid


%Hyper-Exponential/Hypo-Exponential using MLE method