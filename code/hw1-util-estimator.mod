set OUTCOMES;
set EQUATIONS;
param n;
param good_probs{j in OUTCOMES, i in EQUATIONS};
param bad_probs{j in OUTCOMES, i in EQUATIONS};

var utility{j in OUTCOMES}, >=0, <=1;
var margin{i in EQUATIONS}: sum{j in OUTCOMES} good_probs[j,i]*utility[j] - bad_probs[j,i]*utility[j];


maximize total_margin: sum{i in EQUATIONS} margin[i];

s.t. more_utility{i in EQUATIONS}: sum{j in OUTCOMES} good_probs[j,i]*utility[j] >= bad_probs[j,i]*utility[j];


data;
set OUTCOMES := a b c d;
set EQUATIONS := 1 2 3 4;

param n := 4;

param good_probs :=
   a   b   c   d :
1 0.1 0.2 0.3 0.4
2 0.4 0.4 0.1 0.1
3 0.6 0.1 0.0 0.3
4 0.4 0.3 0.2 0.1;

param bad_probs :
   a   b   c   d :=
1 0.1 0.2 0.4 0.3
2 0.4 0.2 0.2 0.2
3 0.4 0.3 0.3 0.0
4 0.5 0.5 0.0 0.0;

end;

