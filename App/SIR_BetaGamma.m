function [S,I,R] = SIR_BetaGamma()
% SIR model from 
% https://en.wikipedia.org/wiki/Compartmental_models_in_epidemiology#The_SIR_model
% S' = -Beta*I*(S/N)
% I' = Beta*I*(S/N) - Gamma*I
% R' = Gamma*I
% Note that, by convention, values to the optimised will go first
global Beta_UI Gamma_UI domain N S_init I_init R_init;

Beta = Beta_UI;
Gamma = Gamma_UI;

DiffEq = chebop(@(t,S,I,R) [diff(S) + Beta.*(S/N).*I;
   diff(I) - Beta*I*(S/N) + Gamma*I;
   diff(R) - Gamma*I], domain);
DiffEq.lbc = @(S, I, R) [S-S_init; I-I_init; R-R_init];
options = cheboppref();
options.ivpSolver = 'ode113';
[S,I,R] = solveivp(DiffEq, 0, options); 