
    p1, c1, p2, c2 :var;
    T1 = 8, C1 = 2, D1 = 8,     T2 = 20, C2 = 5, D2 = 20: parameter; 

automaton sched

loc idle: while True  wait { c1'=0, c2'=0}
    when p1-T1>=0  do {p1'=0, c1'=C1} goto x1R;
    when p2-T2>=0  do {p2'=0, c2'=C2} goto x2R;


loc x2R : while c2>=0 & p2-D2<=0 wait { c1'=0, c2'=-1}
    when c2 = 0  do {} goto idle;
    when c2>0 & p2-D2=0 do {} goto error;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R ;
    when c2>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2W;

loc x1R : while c1>=0 & p1-D1<=0 wait { c1'=-1, c2'=0}
    when c1 = 0  do {} goto idle;
    when c1>0 & p1-D1=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R ;
    when c1>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2W;

loc x1R2W : while c1>=0 & p1-D1<=0 & p2-D2<=0 wait { c1'=-1, c2'=0}
    when c1 = 0  do {} goto x2R;
    when c1>0 & p1-D1=0 do {} goto error;
    when p2-D2=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2W;

loc error: while True wait {}

end

init := 
    loc[sched] = idle & 
    p1=0 & c1=0 &
    p2=0 & c2=0;
bad := loc[sched]=error;
