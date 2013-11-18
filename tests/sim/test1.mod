var
    p1, c1, d1, p2, c2, d2, p3, c3, d3,  x,y: clock;
    O1 = 0, T1 = 8, C1 = 2, D1 = 8,     O2 = 0, T2 = 20, C2 = 2, D2 = 20,     O3 = 0, T3 = 50, C3 = 6, D3 = 50, 
    P = 5, Q = 3: parameter;

automaton act1
synclabs : r1;
loc wait_for_offset1 : while p1<=O1 wait 
    when p1=O1 sync r1 do { p1'= 0 } goto wait_for_period1;
loc wait_for_period1 : while p1<=T1 wait 
    when p1=T1 sync r1 do { p1'= 0 } goto wait_for_period1;

end

automaton act2
synclabs : r2;
loc wait_for_offset2 : while p2<=O2 wait 
    when p2=O2 sync r2 do { p2'= 0 } goto wait_for_period2;
loc wait_for_period2 : while p2<=T2 wait 
    when p2=T2 sync r2 do { p2'= 0 } goto wait_for_period2;

end

automaton act3
synclabs : r3;
loc wait_for_offset3 : while p3<=O3 wait 
    when p3=O3 sync r3 do { p3'= 0 } goto wait_for_period3;
loc wait_for_period3 : while p3<=T3 wait 
    when p3=T3 sync r3 do { p3'= 0 } goto wait_for_period3;

end

automaton sched

synclabs : r1, r2, r3,  empty, go, frozen;

loc idle: while True wait
    when True  sync r1 do {c1'=0, d1'=0} goto f1R;
    when True  sync r2 do {c2'=0, d2'=0} goto f2R;
    when True  sync r3 do {c3'=0, d3'=0} goto f3R;


loc x3R : while c3<=C3 & d3<=D3 wait
    when c3 = C3 sync empty do {} goto idle;
    when c3<C3 & d3=D3 do {} goto error;
    when c3<C3 & d3<D3 sync r1 do { c1'=0, d1'=0 } goto x1R3W;
    when c3<C3 & d3<D3 sync r2 do { c2'=0, d2'=0 } goto x2R3W;
    when c3<C3 & d3<D3 sync frozen do {} goto f3R;

loc f3R : while c3<=C3 & d3<=D3 stop { c3 } wait
    when c3<C3 & d3=D3 do {} goto error;
    when c3<C3 & d3<D3 sync r1 do { c1'=0, d1'=0 } goto f1R3W;
    when c3<C3 & d3<D3 sync r2 do { c2'=0, d2'=0 } goto f2R3W;
    when c3<=C3 & d3<=D3 sync go do {} goto x3R;

loc x2R : while c2<=C2 & d2<=D2 wait
    when c2 = C2 sync empty do {} goto idle;
    when c2<C2 & d2=D2 do {} goto error;
    when c2<C2 & d2<D2 sync r1 do { c1'=0, d1'=0 } goto x1R2W;
    when c2<C2 & d2<D2 sync r3 do { c3'=0, d3'=0 } goto x2R3W;
    when c2<C2 & d2<D2 sync frozen do {} goto f2R;

loc f2R : while c2<=C2 & d2<=D2 stop { c2 } wait
    when c2<C2 & d2=D2 do {} goto error;
    when c2<C2 & d2<D2 sync r1 do { c1'=0, d1'=0 } goto f1R2W;
    when c2<C2 & d2<D2 sync r3 do { c3'=0, d3'=0 } goto f2R3W;
    when c2<=C2 & d2<=D2 sync go do {} goto x2R;

loc x2R3W : while c2<=C2 & d2<=D2 & c3<=C3 & d3<=D3 stop { c3 } wait
    when c2 = C2  do {} goto x3R;
    when c2<C2 & d2=D2 do {} goto error;
    when d3=D3 do {} goto error;
    when c2<C2 & d2<D2 & c3<C3 & d3<D3 sync r1 do { c1'=0, d1'=0 } goto x1R2W3W;
    when c2<C2 & d2<D2 & c3<C3 & d3<D3 sync frozen do {} goto f2R3W;

loc f2R3W : while c2<=C2 & d2<=D2 & c3<=C3 & d3<=D3 stop { c2, c3 } wait
    when c2<C2 & d2=D2 do {} goto error;
    when d3=D3 do {} goto error;
    when c2<C2 & d2<D2 & c3<C3 & d3<D3 sync r1 do { c1'=0, d1'=0 } goto f1R2W3W;
    when c2<=C2 & d2<=D2 & c3<=C3 & d3<=D3 sync go do {} goto x2R3W;

loc x1R : while c1<=C1 & d1<=D1 wait
    when c1 = C1 sync empty do {} goto idle;
    when c1<C1 & d1=D1 do {} goto error;
    when c1<C1 & d1<D1 sync r2 do { c2'=0, d2'=0 } goto x1R2W;
    when c1<C1 & d1<D1 sync r3 do { c3'=0, d3'=0 } goto x1R3W;
    when c1<C1 & d1<D1 sync frozen do {} goto f1R;

loc f1R : while c1<=C1 & d1<=D1 stop { c1 } wait
    when c1<C1 & d1=D1 do {} goto error;
    when c1<C1 & d1<D1 sync r2 do { c2'=0, d2'=0 } goto f1R2W;
    when c1<C1 & d1<D1 sync r3 do { c3'=0, d3'=0 } goto f1R3W;
    when c1<=C1 & d1<=D1 sync go do {} goto x1R;

loc x1R3W : while c1<=C1 & d1<=D1 & c3<=C3 & d3<=D3 stop { c3 } wait
    when c1 = C1  do {} goto x3R;
    when c1<C1 & d1=D1 do {} goto error;
    when d3=D3 do {} goto error;
    when c1<C1 & d1<D1 & c3<C3 & d3<D3 sync r2 do { c2'=0, d2'=0 } goto x1R2W3W;
    when c1<C1 & d1<D1 & c3<C3 & d3<D3 sync frozen do {} goto f1R3W;

loc f1R3W : while c1<=C1 & d1<=D1 & c3<=C3 & d3<=D3 stop { c1, c3 } wait
    when c1<C1 & d1=D1 do {} goto error;
    when d3=D3 do {} goto error;
    when c1<C1 & d1<D1 & c3<C3 & d3<D3 sync r2 do { c2'=0, d2'=0 } goto f1R2W3W;
    when c1<=C1 & d1<=D1 & c3<=C3 & d3<=D3 sync go do {} goto x1R3W;

loc x1R2W : while c1<=C1 & d1<=D1 & c2<=C2 & d2<=D2 stop { c2 } wait
    when c1 = C1  do {} goto x2R;
    when c1<C1 & d1=D1 do {} goto error;
    when d2=D2 do {} goto error;
    when c1<C1 & d1<D1 & c2<C2 & d2<D2 sync r3 do { c3'=0, d3'=0 } goto x1R2W3W;
    when c1<C1 & d1<D1 & c2<C2 & d2<D2 sync frozen do {} goto f1R2W;

loc f1R2W : while c1<=C1 & d1<=D1 & c2<=C2 & d2<=D2 stop { c1, c2 } wait
    when c1<C1 & d1=D1 do {} goto error;
    when d2=D2 do {} goto error;
    when c1<C1 & d1<D1 & c2<C2 & d2<D2 sync r3 do { c3'=0, d3'=0 } goto f1R2W3W;
    when c1<=C1 & d1<=D1 & c2<=C2 & d2<=D2 sync go do {} goto x1R2W;

loc x1R2W3W : while c1<=C1 & d1<=D1 & c2<=C2 & d2<=D2 & c3<=C3 & d3<=D3 stop { c2, c3 } wait
    when c1 = C1  do {} goto x2R3W;
    when c1<C1 & d1=D1 do {} goto error;
    when d2=D2 do {} goto error;
    when d3=D3 do {} goto error;
    when c1<C1 & d1<D1 & c2<C2 & d2<D2 & c3<C3 & d3<D3 sync frozen do {} goto f1R2W3W;

loc f1R2W3W : while c1<=C1 & d1<=D1 & c2<=C2 & d2<=D2 & c3<=C3 & d3<=D3 stop { c1, c2, c3 } wait
    when c1<C1 & d1=D1 do {} goto error;
    when d2=D2 do {} goto error;
    when d3=D3 do {} goto error;
    when c1<=C1 & d1<=D1 & c2<=C2 & d2<=D2 & c3<=C3 & d3<=D3 sync go do {} goto x1R2W3W;

 loc error: while True wait {}

end

automaton server

synclabs: r1, r2, r3, empty, go, frozen;
loc idle: while True stop {x,y} wait{}
    when True sync r1 do { x'=0, y'=0 } goto active;
    when True sync r2 do { x'=0, y'=0 } goto active;
    when True sync r3 do { x'=0, y'=0 } goto active;
loc active: while y-x <= P-Q stop{x} wait {}
    when True sync r1 do { } goto active;
    when True sync r2 do { } goto active;
    when True sync r3 do { } goto active;
    when True sync go do {} goto executing;
loc executing: while x <= Q wait {}
    when True sync r1 do { } goto executing;
    when True sync r2 do { } goto executing;
    when True sync r3 do { } goto executing;
    when x = Q sync frozen do {} goto recharging;
    when 5*x >= 3*y sync empty do {  } goto empty;
    when 5*x < 3*y sync empty  do { x'=0,y'=0 } goto idle;
    when x < Q sync frozen do { } goto active;
loc recharging: while y <= P stop {x} wait {}
    when True sync r1 do { } goto recharging;
    when True sync r2 do { } goto recharging;
    when True sync r3 do { } goto recharging;
    when y = P do {x'=0,y'=0} goto active;
loc empty: while 5*x >= 3*y stop { x } wait {}
    when True sync r1 do { } goto active;
    when True sync r2 do { } goto active;
    when True sync r3 do { } goto active;
    when 5*x = 3*y goto idle;
end

var init: region;
init := 
    loc[act1] = wait_for_offset1 & p1=0 &
    loc[act2] = wait_for_offset2 & p2=0 &
    loc[act3] = wait_for_offset3 & p3=0 &
    loc[sched] = idle & c1=0 & d1 = 0 & c2=0 & d2 = 0 & c3=0 & d3 = 0 & 
    loc[server] = idle &x=0 &y=0;
