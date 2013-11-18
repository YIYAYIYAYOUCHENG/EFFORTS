

#		a task set with 2 sporadic tasks and 1 periodic task
#		reachability test to check if the task set if schedulable
#
#		to run the test : ../../binary/xtool --reach -f 03_sporadic2_reach.mod

    p1, c1, d1, p2, c2, d2, p3, c3, d3: var;
    O1 = 0, T1 = 8, C1 = 2, D1 = 8,     O2 = 0, T2 = 20, C2 = 5, D2 = 20,     O3 = 0, T3 = 50, C3 = 20, D3 = 50, H=100
    : parameter;

automaton act1
synclabs : r1;
loc wait_for_offset1 : while p1-O1<=0 wait 
    when p1-O1=0 sync r1 do { p1'= 0 } goto wait_for_period1;
loc wait_for_period1 : while p1-H<=0 wait 
    when p1-T1>=0 sync r1 do { p1'= 0 } goto wait_for_period1;

end

automaton act2
synclabs : r2;
loc wait_for_offset2 : while p2-O2<=0 wait 
    when p2-O2=0 sync r2 do { p2'= 0 } goto wait_for_period2;
loc wait_for_period2 : while p2-H<=0 wait 
    when p2-T2>=0 sync r2 do { p2'= 0 } goto wait_for_period2;

end

automaton act3
synclabs : r3;
loc wait_for_offset3 : while p3-O3<=0 wait 
    when p3-O3=0 sync r3 do { p3'= 0 } goto wait_for_period3;
loc wait_for_period3 : while p3-T3<=0 wait 
    when p3-T3=0 sync r3 do { p3'= 0 } goto wait_for_period3;

end

automaton sched

synclabs : r1, r2, r3,  empty;
loc idle: while True wait
    when True  sync r1 do {c1'=0, d1'=0} goto x1R;
    when True  sync r2 do {c2'=0, d2'=0} goto x2R;
    when True  sync r3 do {c3'=0, d3'=0} goto x3R;


loc x3R : while c3-C3<=0 & d3-D3<=0 wait {  } 
    when c3-C3=0  do {} goto idle;
    when c3-C3<0 & d3-D3=0 do {} goto error;
    when c3-C3<0 & d3-D3<=0 sync r1 do { c1'=0, d1'=0 } goto x1R3W;
    when c3-C3<0 & d3-D3<=0 sync r2 do { c2'=0, d2'=0 } goto x2R3W;

loc x2R : while c2-C2<=0 & d2-D2<=0 wait {  } 
    when c2-C2=0  do {} goto idle;
    when c2-C2<0 & d2-D2=0 do {} goto error;
    when c2-C2<0 & d2-D2<=0 sync r1 do { c1'=0, d1'=0 } goto x1R2W;
    when c2-C2<0 & d2-D2<=0 sync r3 do { c3'=0, d3'=0 } goto x2R3W;

loc x2R3W : while c2-C2<=0 & d2-D2<=0 & c3-C3<=0 & d3-D3<=0 wait { c3'=0 } 
    when c2-C2=0  do {} goto x3R;
    when c2-C2<0 & d2-D2=0 do {} goto error;
    when d3-D3=0 do {} goto error;
    when c2-C2<0 & d2-D2<=0 & c3-C3<0 & d3-D3<=0 sync r1 do { c1'=0, d1'=0 } goto x1R2W3W;

loc x1R : while c1-C1<=0 & d1-D1<=0 wait {  } 
    when c1-C1=0  do {} goto idle;
    when c1-C1<0 & d1-D1=0 do {} goto error;
    when c1-C1<0 & d1-D1<=0 sync r2 do { c2'=0, d2'=0 } goto x1R2W;
    when c1-C1<0 & d1-D1<=0 sync r3 do { c3'=0, d3'=0 } goto x1R3W;

loc x1R3W : while c1-C1<=0 & d1-D1<=0 & c3-C3<=0 & d3-D3<=0 wait { c3'=0 } 
    when c1-C1=0  do {} goto x3R;
    when c1-C1<0 & d1-D1=0 do {} goto error;
    when d3-D3=0 do {} goto error;
    when c1-C1<0 & d1-D1<=0 & c3-C3<0 & d3-D3<=0 sync r2 do { c2'=0, d2'=0 } goto x1R2W3W;

loc x1R2W : while c1-C1<=0 & d1-D1<=0 & c2-C2<=0 & d2-D2<=0 wait { c2'=0 } 
    when c1-C1=0  do {} goto x2R;
    when c1-C1<0 & d1-D1=0 do {} goto error;
    when d2-D2=0 do {} goto error;
    when c1-C1<0 & d1-D1<=0 & c2-C2<0 & d2-D2<=0 sync r3 do { c3'=0, d3'=0 } goto x1R2W3W;

loc x1R2W3W : while c1-C1<=0 & d1-D1<=0 & c2-C2<=0 & d2-D2<=0 & c3-C3<=0 & d3-D3<=0 wait { c2'=0, c3'=0 } 
    when c1-C1=0  do {} goto x2R3W;
    when c1-C1<0 & d1-D1=0 do {} goto error;
    when d2-D2=0 do {} goto error;
    when d3-D3=0 do {} goto error;

 loc error: while True wait {}

end

init := 
    loc[act1] = wait_for_offset1 & 
    loc[act2] = wait_for_offset2 & 
    loc[act3] = wait_for_offset3 & 
    loc[sched] = idle &     p1=0 &
    p2=0 &
    p3=0 &
c1=0 & d1 = 0 & c2=0 & d2 = 0 & c3=0 & d3 = 0 & x=0 &y=0;
bad := loc[sched]=error;
