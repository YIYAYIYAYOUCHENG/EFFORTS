
#   to run the test case : ../binary/xtool --imcr -f test2_imcr.mod

    p1, c1, d1, p2, c2, d2  : var;
    O1 = 0, T1 = 8, C1 , D1 = 8,     O2 = 0, T2 = 20, C2 = 2, D2 = 20 
    : parameter;
    C1 = 2: im_parameter;

automaton act1
synclabs : r1;
loc wait_for_offset1 : while p1-O1<=0 wait 
    when p1-O1=0 sync r1 do { p1'= 0 } goto wait_for_period1;
loc wait_for_period1 : while p1-T1<=0 wait 
    when p1-T1=0 sync r1 do { p1'= 0 } goto wait_for_period1;

end

automaton act2
synclabs : r2;
loc wait_for_offset2 : while p2-O2<=0 wait 
    when p2-O2=0 sync r2 do { p2'= 0 } goto wait_for_period2;
loc wait_for_period2 : while p2-T2<=0 wait 
    when p2-T2=0 sync r2 do { p2'= 0 } goto wait_for_period2;

end

automaton sched

synclabs : r1, r2,  empty;
loc idle: while True wait
    when True  sync r1 do {c1'=0, d1'=0} goto x1R;
    when True  sync r2 do {c2'=0, d2'=0} goto x2R;


loc x2R : while c2-C2<=0 & d2-D2<=0 wait {  } 
    when c2-C2=0 sync empty do {} goto idle;
    when c2-C2<=0 & d2-D2=0 do {} goto error;
    when c2-C2<=0 & d2-D2<=0 sync r1 do { c1'=0, d1'=0 } goto x1R2W;

loc x1R : while c1-C1<=0 & d1-D1<=0 wait {  } 
    when c1-C1=0 sync empty do {} goto idle;
    when c1-C1<=0 & d1-D1=0 do {} goto error;
    when c1-C1<=0 & d1-D1<=0 sync r2 do { c2'=0, d2'=0 } goto x1R2W;

loc x1R2W : while c1-C1<=0 & d1-D1<=0 & c2-C2<=0 & d2-D2<=0 wait { c2'=0 } 
    when c1-C1=0  do {} goto x2R;
    when c1-C1<=0 & d1-D1=0 do {} goto error;
    when d2-D2=0 do {} goto error;

 loc error: while True wait {}

end

init := 
    loc[act1] = wait_for_offset1 & 
    loc[act2] = wait_for_offset2 & 
    loc[sched] = idle &     p1=0 &
    p2=0 &
c1=0 & d1 = 0 & c2=0 & d2 = 0 ;
#bad := loc[sched]=error;
