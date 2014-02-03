set OBJECT;
set CAPACITY_CONSTRAINT;
param cost{i in OBJECT, j in CAPACITY_CONSTRAINT};
param limit{j in CAPACITY_CONSTRAINT};
param availability{i in OBJECT};
param value{i in OBJECT};
var quantity{i in OBJECT}, integer, >= 0;
maximize total_value: sum{i in OBJECT} quantity[i]*value[i];
s.t. capacity_constraints {j in CAPACITY_CONSTRAINT}: sum{i in OBJECT} cost[i,j]*quantity[i] <= limit[j];
s.t. availability_constraints {i in OBJECT}: quantity[i] <= availability[i];

data;
set OBJECT := a b c;
set CAPACITY_CONSTRAINT := weight volume;
param cost: weight volume :=
   a 16 3
   b 4 4
   c 6 3;
param limit:= weight 30 volume 20;
param availability:= a 3 b 4 c 1;
param value:= a 11 b 4 c 9;
end;
