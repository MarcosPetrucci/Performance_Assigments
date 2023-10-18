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
t = [0:600]; %for intervals

%Calculating the moments
Mean = sum(sDataSet)/N;
Moment2 = sum(sDataSet .^2)/N;
Moment3 = sum(sDataSet .^3)/N;
coef_var = std(sDataSet)/Mean;

%Fitting the uniform using direct expressions
left_boundary = Mean - sqrt(12*(Moment2 - Mean^2))/2;
right_boundary = Mean + sqrt(12*(Moment2 - Mean^2))/2;

%Fitting the Exponential using direct expressions
expl_lambda = 1/Mean;

%Fitting the Erlang distribution
k = round(1/coef_var^2);
lambda_erlang = k/Mean;
small_set = sDataSet(1:601);
cdf_erlang = cdf('Gamma',small_set, k, lambda_erlang);
cdf_erlang = transpose(cdf_erlang);

%Fitting the Weibull
syms scale shape
initial_guess = 1;
equation1 = Mean == scale * gamma(1 + 1/shape); %Defiing first moment equation
equation2 = Moment2 ==  (scale^2) * gamma(1 + 2/shape); %Second moment (variance) 
weibull_params = vpasolve([equation1, equation2], [scale, shape], [initial_guess, initial_guess]);
weib_scale = double(weibull_params.scale);
weib_shape = double(weibull_params.shape);

%Fitting the Pareto
syms alpha m
eq3 = Mean == (alpha * m) / (alpha - 1); %Equations from slides
eq4 = Moment2 == (alpha * m^2)/(alpha-2);
pareto_params = solve([eq3, eq4], [alpha, m]);
alpha_pareto = double(pareto_params.alpha(1));
m_pareto = double(pareto_params.m(1));

%Hypo-Exponential using MLE method
lambda1 = 1/(0.3*Mean);
lambda2 = 1/(0.7*Mean);
hypo_parameters = mle(DataSet, 'pdf', @(DataSet, lambda1, lambda2)HypoExp_pdf(DataSet,[lambda1, lambda2]), ...
  'Start', [lambda1,lambda2]);

%Hyper_Exponential using MLE method
p1 = 0.4;
lambda1 = 0.8/Mean;
lambda2 = 1.2/Mean;
hyper_parameters = mle(DataSet, 'pdf', @(DataSet, lambda1, lambda2, p1)HyperExp_pdf(DataSet,[lambda1, lambda2, p1]), ...
    'Start', [lambda1,lambda2, p1]);



