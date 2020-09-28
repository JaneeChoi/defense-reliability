functions{
    real failure_form(real shape, real scale, real age){
    
        return fmin((shape/scale) * pow(age/scale, shape-1) * exp(-pow(age/scale, shape)), 1.5);
    } 
}
data {
    int N;
    real complexity;
    real<lower=0,upper=1> age;
    real relative_displacement;
    int engine_count;
    
}

generated quantities{
    real<lower=0> alpha = lognormal_rng(0, 0.5);
    real<lower=0> beta = fabs(normal_rng(1.2, 0.15));
    real<lower=0> gamma = fabs(gamma_rng(5, 2));
    real<lower=0> delta = fabs(normal_rng(1.2, 0.15));
    
    real epsilon = normal_rng(0.8, 0.7);
    real zeta = normal_rng(0.3, 0.5);
    real eta = normal_rng(1, 0.7);
    real theta = normal_rng(0.5, 0.5);

    real early = complexity * epsilon + zeta * log(relative_displacement);
    real wear = complexity * engine_count * eta + theta * log(relative_displacement);
    real lambda = early * failure_form(alpha, beta, age) + wear * failure_form(gamma, delta, age);
    int y[N];
    for(n in 1:N){
        y[n] = poisson_rng(exp(lambda));
    }
}