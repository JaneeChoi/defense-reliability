functions{
    real failure_form(real shape, real scale, real age){
    
        return fmin((shape/scale) * pow(age/scale, shape-1) * exp(-pow(age/scale, shape)), 1.5);
    } 
}

data {
    int N;
    int y[N];
    real complexity;
    real<lower=0,upper=1> age;
    real relative_displacement;
    int engine_count;
    
}

parameters {
    real<lower=0> alpha;
    real<lower=0> beta;
    real<lower=0> gamma;
    real<lower=0> delta;

    real epsilon;
    real zeta;
    real eta;
    real theta;
}

transformed parameters {
    real early;
    real wear;
    real lambda;
    early = complexity * epsilon;// + zeta * log(relative_displacement);
    wear = complexity * engine_count * eta - theta * log(relative_displacement);
    lambda = failure_form(alpha, beta, age) + wear * failure_form(gamma, delta, age);
}

model {
    alpha ~ normal(0.05, 0.3);
    beta ~ normal(1.2, 0.05);
    gamma ~ normal(2.5, 0.5);
    delta ~ normal(1.2, 0.1);
    
    epsilon ~ normal(0.8, 0.7);
    zeta ~ normal(0.3, 0.5);
    eta ~ normal(0.5, 0.7);
    theta ~ normal(0.2, 0.3);
    
    y ~ poisson(exp(lambda));
}

generated quantities{
    int post_y[N];
    for(i in 1:N){
        post_y[i] = poisson_rng(exp(lambda));
    }
}