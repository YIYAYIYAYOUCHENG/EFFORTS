
    p1, c1, p2, c2, p3, c3, p4, c4 :var;
    T1 = 8, C1 = 2, D1 = 8,     T2 = 20, C2 = 5, D2 = 20,     T3 = 50, C3 = 20, D3 = 50,     T4 = 100, C4 = 2, D4 = 100: parameter; 

automaton sched

loc idle: while True  wait { c1'=0, c2'=0, c3'=0, c4'=0}
    when p1-T1>=0  do {p1'=0, c1'=C1} goto x1R;
    when p2-T2>=0  do {p2'=0, c2'=C2} goto x2R;
    when p3-T3>=0  do {p3'=0, c3'=C3} goto x3R;
    when p4-T4>=0  do {p4'=0, c4'=C4} goto x4R;


loc x4R : while c4>=0 & p4-D4<=0 wait { c1'=0, c2'=0, c3'=0, c4'=-1}
    when c4 = 0  do {} goto idle;
    when c4>0 & p4-D4=0 do {} goto error;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x4R ;
    when c4>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R4R;
    when c4>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R4R;
    when c4>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x3R4R;

loc x3R : while c3>=0 & p3-D3<=0 wait { c1'=0, c2'=0, c3'=-1, c4'=0}
    when c3 = 0  do {} goto idle;
    when c3>0 & p3-D3=0 do {} goto error;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x3R ;
    when c3>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R3R;
    when c3>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R3R;
    when c3>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x3R4R;

loc x3R4R : while c3>=0 & p3-D3<=0 & c4>=0 & p4-D4<=0 wait { c1'=0, c2'=0, c3'=-1, c4'=-1}
    when c3 = 0  do {} goto x4R;
    when c4 = 0  do {} goto x3R;
    when c3>0 & p3-D3=0 do {} goto error;
    when c4>0 & p4-D4=0 do {} goto error;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x3R4R ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x3R4R ;
    when c3>0 & c4>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R3R4W;
    when c3>0 & c4>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R3R4W;

loc x2R : while c2>=0 & p2-D2<=0 wait { c1'=0, c2'=-1, c3'=0, c4'=0}
    when c2 = 0  do {} goto idle;
    when c2>0 & p2-D2=0 do {} goto error;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R ;
    when c2>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R;
    when c2>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x2R3R;
    when c2>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x2R4R;

loc x2R4R : while c2>=0 & p2-D2<=0 & c4>=0 & p4-D4<=0 wait { c1'=0, c2'=-1, c3'=0, c4'=-1}
    when c2 = 0  do {} goto x4R;
    when c4 = 0  do {} goto x2R;
    when c2>0 & p2-D2=0 do {} goto error;
    when c4>0 & p4-D4=0 do {} goto error;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R4R ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x2R4R ;
    when c2>0 & c4>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R4W;
    when c2>0 & c4>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x2R3R4W;

loc x2R3R : while c2>=0 & p2-D2<=0 & c3>=0 & p3-D3<=0 wait { c1'=0, c2'=-1, c3'=-1, c4'=0}
    when c2 = 0  do {} goto x3R;
    when c3 = 0  do {} goto x2R;
    when c2>0 & p2-D2=0 do {} goto error;
    when c3>0 & p3-D3=0 do {} goto error;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R3R ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x2R3R ;
    when c2>0 & c3>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R3W;
    when c2>0 & c3>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x2R3R4W;

loc x2R3R4W : while c2>=0 & p2-D2<=0 & c3>=0 & p3-D3<=0 & p4-D4<=0 wait { c1'=0, c2'=-1, c3'=-1, c4'=0}
    when c2 = 0  do {} goto x3R4R;
    when c3 = 0  do {} goto x2R4R;
    when c2>0 & p2-D2=0 do {} goto error;
    when c3>0 & p3-D3=0 do {} goto error;
    when p4-D4=0 do {} goto error;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R3R4W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x2R3R4W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x2R3R4W;
    when c2>0 & c3>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R3W4W;

loc x1R : while c1>=0 & p1-D1<=0 wait { c1'=-1, c2'=0, c3'=0, c4'=0}
    when c1 = 0  do {} goto idle;
    when c1>0 & p1-D1=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R ;
    when c1>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R;
    when c1>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x1R3R;
    when c1>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x1R4R;

loc x1R4R : while c1>=0 & p1-D1<=0 & c4>=0 & p4-D4<=0 wait { c1'=-1, c2'=0, c3'=0, c4'=-1}
    when c1 = 0  do {} goto x4R;
    when c4 = 0  do {} goto x1R;
    when c1>0 & p1-D1=0 do {} goto error;
    when c4>0 & p4-D4=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R4R ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R4R ;
    when c1>0 & c4>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R4W;
    when c1>0 & c4>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x1R3R4W;

loc x1R3R : while c1>=0 & p1-D1<=0 & c3>=0 & p3-D3<=0 wait { c1'=-1, c2'=0, c3'=-1, c4'=0}
    when c1 = 0  do {} goto x3R;
    when c3 = 0  do {} goto x1R;
    when c1>0 & p1-D1=0 do {} goto error;
    when c3>0 & p3-D3=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R3R ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R3R ;
    when c1>0 & c3>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R3W;
    when c1>0 & c3>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x1R3R4W;

loc x1R3R4W : while c1>=0 & p1-D1<=0 & c3>=0 & p3-D3<=0 & p4-D4<=0 wait { c1'=-1, c2'=0, c3'=-1, c4'=0}
    when c1 = 0  do {} goto x3R4R;
    when c3 = 0  do {} goto x1R4R;
    when c1>0 & p1-D1=0 do {} goto error;
    when c3>0 & p3-D3=0 do {} goto error;
    when p4-D4=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R3R4W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R3R4W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R3R4W;
    when c1>0 & c3>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R3W4W;

loc x1R2R : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0}
    when c1 = 0  do {} goto x2R;
    when c2 = 0  do {} goto x1R;
    when c1>0 & p1-D1=0 do {} goto error;
    when c2>0 & p2-D2=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R ;
    when c1>0 & c2>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x1R2R3W;
    when c1>0 & c2>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x1R2R4W;

loc x1R2R4W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p4-D4<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0}
    when c1 = 0  do {} goto x2R4R;
    when c2 = 0  do {} goto x1R4R;
    when c1>0 & p1-D1=0 do {} goto error;
    when c2>0 & p2-D2=0 do {} goto error;
    when p4-D4=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R4W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R4W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R2R4W;
    when c1>0 & c2>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x1R2R3W4W;

loc x1R2R3W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p3-D3<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0}
    when c1 = 0  do {} goto x2R3R;
    when c2 = 0  do {} goto x1R3R;
    when c1>0 & p1-D1=0 do {} goto error;
    when c2>0 & p2-D2=0 do {} goto error;
    when p3-D3=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R3W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R3W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R2R3W;
    when c1>0 & c2>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x1R2R3W4W;

loc x1R2R3W4W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p3-D3<=0 & p4-D4<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0}
    when c1 = 0  do {} goto x2R3R4W;
    when c2 = 0  do {} goto x1R3R4W;
    when c1>0 & p1-D1=0 do {} goto error;
    when c2>0 & p2-D2=0 do {} goto error;
    when p3-D3=0 do {} goto error;
    when p4-D4=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R3W4W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R3W4W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R2R3W4W;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R2R3W4W;

loc error: while True wait {}

end

init := 
    loc[sched] = idle & 
    p1=0 & c1=0 &
    p2=0 & c2=0 &
    p3=0 & c3=0 &
    p4=0 & c4=0;
bad := loc[sched]=error;
