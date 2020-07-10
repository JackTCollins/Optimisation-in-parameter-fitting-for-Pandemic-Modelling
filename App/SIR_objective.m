function Diffs=SIR_objective(C)
global Dates Smooth N domain S_init I_init R_init TotalInfected;
Beta = C(1);  Gamma = C(2);

DiffEq = chebop(@(t,S,I,R) [diff(S) + Beta.*(S/N).*I;
   diff(I) - Beta*I*(S/N) + Gamma*I;
   diff(R) - Gamma*I], domain);
DiffEq.lbc = @(S, I, R) [S-S_init; I-I_init; R-R_init];
options = cheboppref();
options.ivpSolver = 'ode113';
[~,I,~] = solveivp(DiffEq, 0, options); 
Diffs = I(Dates)-Smooth; 
save
end