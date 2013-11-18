
    p1, c1 :var;
    T1 = 8, C1 = 2, D1 = 8: parameter; 

automaton sched

loc idle: while True  wait { c1'=0}
    when p1-T1>=0  do {p1'=0, c1'=C1} goto x1R;


loc x1R : while c1>=0 & p1-D1<=0 wait { c1'=-1}
    when c1 = 0  do {} goto idle;
    when c1>0 & p1-D1=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R ;

loc error: while True wait {}

end

init := 
    loc[sched] = idle & 
    p1=0 & c1=0;
bad := loc[sched]=error;
