% Perform Benjamini Hochberch for generalization based on exp1 and exp2

fdr=0.1;

p1Adapt=[0.015 0.616 0.092 0.001 0.021 0.190 0.049 0.003 0.002]';
[h1Adapt,pAdj1Adapt,i1] = BenjaminiHochberg(p1Adapt,fdr);

p2Adapt=[0.002 0.722 0.793 0.907 0.760 0.997]';
[h2Adapt,pAdj2Adapt,i1] = BenjaminiHochberg(p2Adapt,fdr);

p1OGpost=[0.017 0.402 0.021 0.071 0.196 0.056 0.028 0.049 0.172 0.252 0.972 0.553]';
[h1OGpost,pAdj1OGpost,i1] = BenjaminiHochberg(p1OGpost,fdr); 