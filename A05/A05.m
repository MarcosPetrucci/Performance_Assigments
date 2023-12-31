% Marcos Vinicius Firmino Pietrucci
% 10914211
% Assigment 5

%%% Generate 10000 random numbers using Lin. Cong. Gen.
N = 10000;
m = 2^32; %Given values
a = 1664525;
c = 1013904223;
seed = 521191478;
random_nums = zeros(1, N);

x = seed; %The first "random" value
random_nums(1) = x/m;
i = 2;
while i <= N %Calculating all the others
    x = mod(a*x + c, m);
    random_nums(i) = x/m;
    i = i + 1;
end

%%% Generating distributions with random values %%%%%
t = [1:10000]/400; % A lot of points from 0 to 25
lambda_exp = 0.1;
alpha_p = 1.5;
m_p = 5;
k_erl = 4;
lambda_erl = 0.4;
hypo_l1 = 0.5;
hypo_l2 = 0.125;
hyper_l1 = 0.5;
hyper_l2 = 0.05;
hyper_p = 0.55;

%Exponential
exponential_emp = zeros(1,N);
exponential_emp = -log(random_nums)./lambda_exp;
figure(1)
plot(sort(exponential_emp),[1:N]/N, ".", t, Exp_cdf(t, [lambda_exp]),"-")
title("Exponential - N1");
xlim([0 25]);
legend({'Empirical','Theoretical'},'Location','southeast')
grid

%Pareto
pareto_emp = zeros(1,N);
pareto_emp = m_p ./ ((random_nums).^(1/alpha_p));

figure(2)
plot(sort(pareto_emp), [1:N]/N, '.', t, Pareto_cdf(t, [alpha_p, m_p]), '-');
title("Pareto  - N2");
legend({'Empirical','Theoretical'},'Location','southeast')
xlim([0 25])
grid

%Erlang
erlang_emp = zeros(1,N/k_erl);
aux = zeros(1,N/k_erl);
value = 1;
i = 1;
    %Here I am dividing the 10000 values into 4x2500 just like in class
while i <= N/k_erl
    aux(1:4,i) = random_nums(((i-1)*4+1):((i-1)*4+1) + 3);
    i = i+1;
end
    %Than using prod just  like in class
erlang_emp = -log(prod(aux)) ./ lambda_erl;
figure(3);
plot(sort(erlang_emp), [1:2500]/2500, '.', t, gamcdf(t, k_erl, 1/lambda_erl), '-');
title("Erlang  - N3");
xlim([0 25]);
legend({'Empirical','Theoretical'},'Location','southeast')
grid

%HypoExponential
hypoExp_emp = zeros(1, N/2);
exponential_aux = -log(random_nums);
i = 1;
index_aux = 1;
while i <= N
    hypoExp_emp (index_aux) = exponential_aux(i)/hypo_l1 + exponential_aux(i+1)/hypo_l2;
    i = i + 2;
    index_aux = index_aux + 1;
end
figure(4);
plot(sort(hypoExp_emp), [1:5000]/5000, '.', ...
    t, HypoExp_cdf(t, [hypo_l1, hypo_l2]), '-');
title("HypoExp  - N4");
legend({'Empirical','Theoretical'},'Location','southeast');
xlim([0 25]);
grid

%HyperExponential
hyperExp_emp = zeros(1, N/2);
prob = hyper_p;
lambda = [hyper_l1,hyper_l2, hyper_p];

for i=1:(N/2)
    if random_nums(i) <= prob
        hyperExp_emp(i) = - log(random_nums(5000+i))/lambda(1);
    else
        hyperExp_emp(i) = - log(random_nums(5000+i))/lambda(2);
    end
end

figure(5);
plot(sort(hyperExp_emp), [1:5000]/5000, '.', ...
    t, HyperExp_cdf(t, [lambda]), '-');
title("HyperExp  - N5");
xlim([0 25]);
legend({'Empirical','Theoretical'},'Location','southeast');
grid

%%%%% Calculating the potential costs %%%%%
cost1 = 0.01; %$ per GB if the file is less than 10GB
cost2 = 0.02; %$ per GB if the file is more than 10GB
cost = [cost1,cost2];

% Exponential cost
exp_cost = sum(exponential_emp * cost(1) .* (exponential_emp < 10) ...
                    + exponential_emp* cost(2) .* (exponential_emp >= 10));
% Pareto cost
pareto_cost = sum(pareto_emp * cost(1) .* (pareto_emp < 10) ...
                    + pareto_emp* cost(2) .* (pareto_emp > 10));
% Erlang cost
erlang_cost = sum(erlang_emp * cost(1) .* (erlang_emp < 10) ...
                    + erlang_emp* cost(2) .* (erlang_emp > 10));
% HypoExp Distribution cost
hypo_cost = sum(hypoExp_emp * cost(1) .* (hypoExp_emp < 10) ...
                    + hypoExp_emp* cost(2) .* (hypoExp_emp > 10));
% HyperExp Distribution cost
hyper_cost = sum(hyperExp_emp * cost(1) .* (hyperExp_emp < 10) ...
                    + hyperExp_emp* cost(2) .* (hyperExp_emp > 10));

%%%%%% Presenting the results %%%%%%
fprintf("\n");
fprintf("\nFirst generated random value: %.5f", random_nums(1));
fprintf("\nSecond generated random value: %.5f", random_nums(2));
fprintf("\nThird generated random value: %.5f", random_nums(3));
fprintf("\nFile N1 cost: $%.2f", exp_cost);
fprintf("\nFile N2 cost: $%.2f", pareto_cost);
fprintf("\nFile N3 cost: $%.2f", erlang_cost);
fprintf("\nFile N4 cost: $%.2f", hypo_cost);
fprintf("\nFile N5 cost: $%.2f", hyper_cost);
fprintf("\n");

function F = Pareto_cdf(x, p)
	alpha = p(1); %alpha value (shape)
	m = p(2); %m value (scale)
    
    i = 1;
    while i ~= length(x)  + 1
        if(x(i) >= m)
	        F(i) = 1 - (m/x(i))^alpha;
        else
            F(i) = 0;
        end
        i = i+1;
    end
end

function samples = linear_congruential_generator(m, a, c, seed, n)
    samples = zeros(1, n);
    x = seed;

    for i = 1:n
        x = mod(a * x + c, m);
        samples(i) = x / m;
    end
end

