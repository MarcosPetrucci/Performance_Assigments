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

%Calculating the moments
Mean = sum(sDataSet)/N;
Moment2 = sum(sDataSet .^2)/N;
Moment3 = sum(sDataSet .^3)/N;

%Fitting the Exponential
lambda = 1/Mean;
t = [0:60];
figure(1)
plot(sDataSet, [1:N]/N, ".", t, Exp_cdf(t, [lambda]))
legend({'DataSet','Exponential CDF'},'Location','southeast')
grid