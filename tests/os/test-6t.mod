
    p1, p2, p3, p4, p5, p6, c1, c2, c3, c4, c5, c6 :var;
    T1 = 8, C1 = 2, D1 = 8,     T2 = 20, C2 = 5, D2 = 20,     T3 = 50, C3 = 20, D3 = 50,     T4 = 50, C4 = 20, D4 = 50,     T5 = 50, C5 = 20, D5 = 50,     T6 = 50, C6 = 20, D6 = 50: parameter; 

automaton sched

loc idle: while True  wait { c1'=0, c2'=0, c3'=0, c4'=0, c5'=0, c6'=0}
    when p1-T1>=0  do {p1'=0, c1'=C1} goto x1R;
    when p2-T2>=0  do {p2'=0, c2'=C2} goto x2R;
    when p3-T3>=0  do {p3'=0, c3'=C3} goto x3R;
    when p4-T4>=0  do {p4'=0, c4'=C4} goto x4R;
    when p5-T5>=0  do {p5'=0, c5'=C5} goto x5R;
    when p6-T6>=0  do {p6'=0, c6'=C6} goto x6R;


loc x6R : while c6>=0 & p6-D6<=0 wait { c1'=0, c2'=0, c3'=0, c4'=0, c5'=0, c6'=-1}
    when c6 = 0  do {} goto idle;
    when c6>=1 & p6-D6=0 do {} goto error;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x6R ;
    when p1-T1>=0   do {p1'=0, c1'=C1} goto x1R6R;
    when p2-T2>=0   do {p2'=0, c2'=C2} goto x2R6R;
    when p3-T3>=0   do {p3'=0, c3'=C3} goto x3R6R;
    when p4-T4>=0   do {p4'=0, c4'=C4} goto x4R6R;
    when p5-T5>=0   do {p5'=0, c5'=C5} goto x5R6R;

loc x5R : while c5>=0 & p5-D5<=0 wait { c1'=0, c2'=0, c3'=0, c4'=0, c5'=-1, c6'=0}
    when c5 = 0  do {} goto idle;
    when c5>=1 & p5-D5=0 do {} goto error;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x5R ;
    when p1-T1>=0   do {p1'=0, c1'=C1} goto x1R5R;
    when p2-T2>=0   do {p2'=0, c2'=C2} goto x2R5R;
    when p3-T3>=0   do {p3'=0, c3'=C3} goto x3R5R;
    when p4-T4>=0   do {p4'=0, c4'=C4} goto x4R5R;
    when p6-T6>=0   do {p6'=0, c6'=C6} goto x5R6R;

loc x5R6R : while c5>=0 & p5-D5<=0 & c6>=0 & p6-D6<=0 wait { c1'=0, c2'=0, c3'=0, c4'=0, c5'=-1, c6'=-1}
    when c5 = 0  do {} goto x6R;
    when c6 = 0  do {} goto x5R;
    when c5>=1 & p5-D5=0 do {} goto error;
    when c6>=1 & p6-D6=0 do {} goto error;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x5R6R ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x5R6R ;
    when c6>=1&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R5R6W;
    when c6>=1&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R5R6W;
    when c6>=1&p3-T3>=0   do {p3'=0, c3'=C3} goto x3R5R6W;
    when c6>=1&p4-T4>=0   do {p4'=0, c4'=C4} goto x4R5R6W;

loc x4R : while c4>=0 & p4-D4<=0 wait { c1'=0, c2'=0, c3'=0, c4'=-1, c5'=0, c6'=0}
    when c4 = 0  do {} goto idle;
    when c4>=1 & p4-D4=0 do {} goto error;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x4R ;
    when p1-T1>=0   do {p1'=0, c1'=C1} goto x1R4R;
    when p2-T2>=0   do {p2'=0, c2'=C2} goto x2R4R;
    when p3-T3>=0   do {p3'=0, c3'=C3} goto x3R4R;
    when p5-T5>=0   do {p5'=0, c5'=C5} goto x4R5R;
    when p6-T6>=0   do {p6'=0, c6'=C6} goto x4R6R;

loc x4R6R : while c4>=0 & p4-D4<=0 & c6>=0 & p6-D6<=0 wait { c1'=0, c2'=0, c3'=0, c4'=-1, c5'=0, c6'=-1}
    when c4 = 0  do {} goto x6R;
    when c6 = 0  do {} goto x4R;
    when c4>=1 & p4-D4=0 do {} goto error;
    when c6>=1 & p6-D6=0 do {} goto error;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x4R6R ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x4R6R ;
    when c6>=1&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R4R6W;
    when c6>=1&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R4R6W;
    when c6>=1&p3-T3>=0   do {p3'=0, c3'=C3} goto x3R4R6W;
    when c6>=1&p5-T5>=0   do {p5'=0, c5'=C5} goto x4R5R6W;

loc x4R5R : while c4>=0 & p4-D4<=0 & c5>=0 & p5-D5<=0 wait { c1'=0, c2'=0, c3'=0, c4'=-1, c5'=-1, c6'=0}
    when c4 = 0  do {} goto x5R;
    when c5 = 0  do {} goto x4R;
    when c4>=1 & p4-D4=0 do {} goto error;
    when c5>=1 & p5-D5=0 do {} goto error;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x4R5R ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x4R5R ;
    when c5>=1&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R4R5W;
    when c5>=1&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R4R5W;
    when c5>=1&p3-T3>=0   do {p3'=0, c3'=C3} goto x3R4R5W;
    when p6-T6>=0   do {p6'=0, c6'=C6} goto x4R5R6W;

loc x4R5R6W : while c4>=0 & p4-D4<=0 & c5>=0 & p5-D5<=0 & p6-D6<=0 wait { c1'=0, c2'=0, c3'=0, c4'=-1, c5'=-1, c6'=0}
    when c4 = 0  do {} goto x5R6R;
    when c5 = 0  do {} goto x4R6R;
    when c4>=1 & p4-D4=0 do {} goto error;
    when c5>=1 & p5-D5=0 do {} goto error;
    when p6-D6=0 do {} goto error;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x4R5R6W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x4R5R6W ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x4R5R6W;
    when c5>=1&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R4R5W6W;
    when c5>=1&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R4R5W6W;
    when c5>=1&p3-T3>=0   do {p3'=0, c3'=C3} goto x3R4R5W6W;

loc x3R : while c3>=0 & p3-D3<=0 wait { c1'=0, c2'=0, c3'=-1, c4'=0, c5'=0, c6'=0}
    when c3 = 0  do {} goto idle;
    when c3>=1 & p3-D3=0 do {} goto error;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x3R ;
    when p1-T1>=0   do {p1'=0, c1'=C1} goto x1R3R;
    when p2-T2>=0   do {p2'=0, c2'=C2} goto x2R3R;
    when p4-T4>=0   do {p4'=0, c4'=C4} goto x3R4R;
    when p5-T5>=0   do {p5'=0, c5'=C5} goto x3R5R;
    when p6-T6>=0   do {p6'=0, c6'=C6} goto x3R6R;

loc x3R6R : while c3>=0 & p3-D3<=0 & c6>=0 & p6-D6<=0 wait { c1'=0, c2'=0, c3'=-1, c4'=0, c5'=0, c6'=-1}
    when c3 = 0  do {} goto x6R;
    when c6 = 0  do {} goto x3R;
    when c3>=1 & p3-D3=0 do {} goto error;
    when c6>=1 & p6-D6=0 do {} goto error;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x3R6R ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x3R6R ;
    when c6>=1&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R3R6W;
    when c6>=1&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R3R6W;
    when c6>=1&p4-T4>=0   do {p4'=0, c4'=C4} goto x3R4R6W;
    when c6>=1&p5-T5>=0   do {p5'=0, c5'=C5} goto x3R5R6W;

loc x3R5R : while c3>=0 & p3-D3<=0 & c5>=0 & p5-D5<=0 wait { c1'=0, c2'=0, c3'=-1, c4'=0, c5'=-1, c6'=0}
    when c3 = 0  do {} goto x5R;
    when c5 = 0  do {} goto x3R;
    when c3>=1 & p3-D3=0 do {} goto error;
    when c5>=1 & p5-D5=0 do {} goto error;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x3R5R ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x3R5R ;
    when c5>=1&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R3R5W;
    when c5>=1&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R3R5W;
    when c5>=1&p4-T4>=0   do {p4'=0, c4'=C4} goto x3R4R5W;
    when p6-T6>=0   do {p6'=0, c6'=C6} goto x3R5R6W;

loc x3R5R6W : while c3>=0 & p3-D3<=0 & c5>=0 & p5-D5<=0 & p6-D6<=0 wait { c1'=0, c2'=0, c3'=-1, c4'=0, c5'=-1, c6'=0}
    when c3 = 0  do {} goto x5R6R;
    when c5 = 0  do {} goto x3R6R;
    when c3>=1 & p3-D3=0 do {} goto error;
    when c5>=1 & p5-D5=0 do {} goto error;
    when p6-D6=0 do {} goto error;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x3R5R6W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x3R5R6W ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x3R5R6W;
    when c5>=1&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R3R5W6W;
    when c5>=1&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R3R5W6W;
    when c5>=1&p4-T4>=0   do {p4'=0, c4'=C4} goto x3R4R5W6W;

loc x3R4R : while c3>=0 & p3-D3<=0 & c4>=0 & p4-D4<=0 wait { c1'=0, c2'=0, c3'=-1, c4'=-1, c5'=0, c6'=0}
    when c3 = 0  do {} goto x4R;
    when c4 = 0  do {} goto x3R;
    when c3>=1 & p3-D3=0 do {} goto error;
    when c4>=1 & p4-D4=0 do {} goto error;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x3R4R ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x3R4R ;
    when c4>=1&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R3R4W;
    when c4>=1&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R3R4W;
    when p5-T5>=0   do {p5'=0, c5'=C5} goto x3R4R5W;
    when p6-T6>=0   do {p6'=0, c6'=C6} goto x3R4R6W;

loc x3R4R6W : while c3>=0 & p3-D3<=0 & c4>=0 & p4-D4<=0 & p6-D6<=0 wait { c1'=0, c2'=0, c3'=-1, c4'=-1, c5'=0, c6'=0}
    when c3 = 0  do {} goto x4R6R;
    when c4 = 0  do {} goto x3R6R;
    when c3>=1 & p3-D3=0 do {} goto error;
    when c4>=1 & p4-D4=0 do {} goto error;
    when p6-D6=0 do {} goto error;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x3R4R6W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x3R4R6W ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x3R4R6W;
    when c4>=1&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R3R4W6W;
    when c4>=1&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R3R4W6W;
    when p5-T5>=0   do {p5'=0, c5'=C5} goto x3R4R5W6W;

loc x3R4R5W : while c3>=0 & p3-D3<=0 & c4>=0 & p4-D4<=0 & p5-D5<=0 wait { c1'=0, c2'=0, c3'=-1, c4'=-1, c5'=0, c6'=0}
    when c3 = 0  do {} goto x4R5R;
    when c4 = 0  do {} goto x3R5R;
    when c3>=1 & p3-D3=0 do {} goto error;
    when c4>=1 & p4-D4=0 do {} goto error;
    when p5-D5=0 do {} goto error;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x3R4R5W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x3R4R5W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x3R4R5W;
    when c4>=1&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R3R4W5W;
    when c4>=1&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R3R4W5W;
    when p6-T6>=0   do {p6'=0, c6'=C6} goto x3R4R5W6W;

loc x3R4R5W6W : while c3>=0 & p3-D3<=0 & c4>=0 & p4-D4<=0 & p5-D5<=0 & p6-D6<=0 wait { c1'=0, c2'=0, c3'=-1, c4'=-1, c5'=0, c6'=0}
    when c3 = 0  do {} goto x4R5R6W;
    when c4 = 0  do {} goto x3R5R6W;
    when c3>=1 & p3-D3=0 do {} goto error;
    when c4>=1 & p4-D4=0 do {} goto error;
    when p5-D5=0 do {} goto error;
    when p6-D6=0 do {} goto error;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x3R4R5W6W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x3R4R5W6W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x3R4R5W6W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x3R4R5W6W;
    when c4>=1&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R3R4W5W6W;
    when c4>=1&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R3R4W5W6W;

loc x2R : while c2>=0 & p2-D2<=0 wait { c1'=0, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0}
    when c2 = 0  do {} goto idle;
    when c2>=1 & p2-D2=0 do {} goto error;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R ;
    when p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R;
    when p3-T3>=0   do {p3'=0, c3'=C3} goto x2R3R;
    when p4-T4>=0   do {p4'=0, c4'=C4} goto x2R4R;
    when p5-T5>=0   do {p5'=0, c5'=C5} goto x2R5R;
    when p6-T6>=0   do {p6'=0, c6'=C6} goto x2R6R;

loc x2R6R : while c2>=0 & p2-D2<=0 & c6>=0 & p6-D6<=0 wait { c1'=0, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=-1}
    when c2 = 0  do {} goto x6R;
    when c6 = 0  do {} goto x2R;
    when c2>=1 & p2-D2=0 do {} goto error;
    when c6>=1 & p6-D6=0 do {} goto error;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R6R ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x2R6R ;
    when c6>=1&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R6W;
    when c6>=1&p3-T3>=0   do {p3'=0, c3'=C3} goto x2R3R6W;
    when c6>=1&p4-T4>=0   do {p4'=0, c4'=C4} goto x2R4R6W;
    when c6>=1&p5-T5>=0   do {p5'=0, c5'=C5} goto x2R5R6W;

loc x2R5R : while c2>=0 & p2-D2<=0 & c5>=0 & p5-D5<=0 wait { c1'=0, c2'=-1, c3'=0, c4'=0, c5'=-1, c6'=0}
    when c2 = 0  do {} goto x5R;
    when c5 = 0  do {} goto x2R;
    when c2>=1 & p2-D2=0 do {} goto error;
    when c5>=1 & p5-D5=0 do {} goto error;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R5R ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x2R5R ;
    when c5>=1&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R5W;
    when c5>=1&p3-T3>=0   do {p3'=0, c3'=C3} goto x2R3R5W;
    when c5>=1&p4-T4>=0   do {p4'=0, c4'=C4} goto x2R4R5W;
    when p6-T6>=0   do {p6'=0, c6'=C6} goto x2R5R6W;

loc x2R5R6W : while c2>=0 & p2-D2<=0 & c5>=0 & p5-D5<=0 & p6-D6<=0 wait { c1'=0, c2'=-1, c3'=0, c4'=0, c5'=-1, c6'=0}
    when c2 = 0  do {} goto x5R6R;
    when c5 = 0  do {} goto x2R6R;
    when c2>=1 & p2-D2=0 do {} goto error;
    when c5>=1 & p5-D5=0 do {} goto error;
    when p6-D6=0 do {} goto error;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R5R6W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x2R5R6W ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x2R5R6W;
    when c5>=1&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R5W6W;
    when c5>=1&p3-T3>=0   do {p3'=0, c3'=C3} goto x2R3R5W6W;
    when c5>=1&p4-T4>=0   do {p4'=0, c4'=C4} goto x2R4R5W6W;

loc x2R4R : while c2>=0 & p2-D2<=0 & c4>=0 & p4-D4<=0 wait { c1'=0, c2'=-1, c3'=0, c4'=-1, c5'=0, c6'=0}
    when c2 = 0  do {} goto x4R;
    when c4 = 0  do {} goto x2R;
    when c2>=1 & p2-D2=0 do {} goto error;
    when c4>=1 & p4-D4=0 do {} goto error;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R4R ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x2R4R ;
    when c4>=1&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R4W;
    when c4>=1&p3-T3>=0   do {p3'=0, c3'=C3} goto x2R3R4W;
    when p5-T5>=0   do {p5'=0, c5'=C5} goto x2R4R5W;
    when p6-T6>=0   do {p6'=0, c6'=C6} goto x2R4R6W;

loc x2R4R6W : while c2>=0 & p2-D2<=0 & c4>=0 & p4-D4<=0 & p6-D6<=0 wait { c1'=0, c2'=-1, c3'=0, c4'=-1, c5'=0, c6'=0}
    when c2 = 0  do {} goto x4R6R;
    when c4 = 0  do {} goto x2R6R;
    when c2>=1 & p2-D2=0 do {} goto error;
    when c4>=1 & p4-D4=0 do {} goto error;
    when p6-D6=0 do {} goto error;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R4R6W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x2R4R6W ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x2R4R6W;
    when c4>=1&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R4W6W;
    when c4>=1&p3-T3>=0   do {p3'=0, c3'=C3} goto x2R3R4W6W;
    when p5-T5>=0   do {p5'=0, c5'=C5} goto x2R4R5W6W;

loc x2R4R5W : while c2>=0 & p2-D2<=0 & c4>=0 & p4-D4<=0 & p5-D5<=0 wait { c1'=0, c2'=-1, c3'=0, c4'=-1, c5'=0, c6'=0}
    when c2 = 0  do {} goto x4R5R;
    when c4 = 0  do {} goto x2R5R;
    when c2>=1 & p2-D2=0 do {} goto error;
    when c4>=1 & p4-D4=0 do {} goto error;
    when p5-D5=0 do {} goto error;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R4R5W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x2R4R5W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x2R4R5W;
    when c4>=1&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R4W5W;
    when c4>=1&p3-T3>=0   do {p3'=0, c3'=C3} goto x2R3R4W5W;
    when p6-T6>=0   do {p6'=0, c6'=C6} goto x2R4R5W6W;

loc x2R4R5W6W : while c2>=0 & p2-D2<=0 & c4>=0 & p4-D4<=0 & p5-D5<=0 & p6-D6<=0 wait { c1'=0, c2'=-1, c3'=0, c4'=-1, c5'=0, c6'=0}
    when c2 = 0  do {} goto x4R5R6W;
    when c4 = 0  do {} goto x2R5R6W;
    when c2>=1 & p2-D2=0 do {} goto error;
    when c4>=1 & p4-D4=0 do {} goto error;
    when p5-D5=0 do {} goto error;
    when p6-D6=0 do {} goto error;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R4R5W6W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x2R4R5W6W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x2R4R5W6W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x2R4R5W6W;
    when c4>=1&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R4W5W6W;
    when c4>=1&p3-T3>=0   do {p3'=0, c3'=C3} goto x2R3R4W5W6W;

loc x2R3R : while c2>=0 & p2-D2<=0 & c3>=0 & p3-D3<=0 wait { c1'=0, c2'=-1, c3'=-1, c4'=0, c5'=0, c6'=0}
    when c2 = 0  do {} goto x3R;
    when c3 = 0  do {} goto x2R;
    when c2>=1 & p2-D2=0 do {} goto error;
    when c3>=1 & p3-D3=0 do {} goto error;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R3R ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x2R3R ;
    when c3>=1&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R3W;
    when p4-T4>=0   do {p4'=0, c4'=C4} goto x2R3R4W;
    when p5-T5>=0   do {p5'=0, c5'=C5} goto x2R3R5W;
    when p6-T6>=0   do {p6'=0, c6'=C6} goto x2R3R6W;

loc x2R3R6W : while c2>=0 & p2-D2<=0 & c3>=0 & p3-D3<=0 & p6-D6<=0 wait { c1'=0, c2'=-1, c3'=-1, c4'=0, c5'=0, c6'=0}
    when c2 = 0  do {} goto x3R6R;
    when c3 = 0  do {} goto x2R6R;
    when c2>=1 & p2-D2=0 do {} goto error;
    when c3>=1 & p3-D3=0 do {} goto error;
    when p6-D6=0 do {} goto error;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R3R6W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x2R3R6W ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x2R3R6W;
    when c3>=1&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R3W6W;
    when p4-T4>=0   do {p4'=0, c4'=C4} goto x2R3R4W6W;
    when p5-T5>=0   do {p5'=0, c5'=C5} goto x2R3R5W6W;

loc x2R3R5W : while c2>=0 & p2-D2<=0 & c3>=0 & p3-D3<=0 & p5-D5<=0 wait { c1'=0, c2'=-1, c3'=-1, c4'=0, c5'=0, c6'=0}
    when c2 = 0  do {} goto x3R5R;
    when c3 = 0  do {} goto x2R5R;
    when c2>=1 & p2-D2=0 do {} goto error;
    when c3>=1 & p3-D3=0 do {} goto error;
    when p5-D5=0 do {} goto error;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R3R5W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x2R3R5W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x2R3R5W;
    when c3>=1&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R3W5W;
    when p4-T4>=0   do {p4'=0, c4'=C4} goto x2R3R4W5W;
    when p6-T6>=0   do {p6'=0, c6'=C6} goto x2R3R5W6W;

loc x2R3R5W6W : while c2>=0 & p2-D2<=0 & c3>=0 & p3-D3<=0 & p5-D5<=0 & p6-D6<=0 wait { c1'=0, c2'=-1, c3'=-1, c4'=0, c5'=0, c6'=0}
    when c2 = 0  do {} goto x3R5R6W;
    when c3 = 0  do {} goto x2R5R6W;
    when c2>=1 & p2-D2=0 do {} goto error;
    when c3>=1 & p3-D3=0 do {} goto error;
    when p5-D5=0 do {} goto error;
    when p6-D6=0 do {} goto error;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R3R5W6W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x2R3R5W6W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x2R3R5W6W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x2R3R5W6W;
    when c3>=1&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R3W5W6W;
    when p4-T4>=0   do {p4'=0, c4'=C4} goto x2R3R4W5W6W;

loc x2R3R4W : while c2>=0 & p2-D2<=0 & c3>=0 & p3-D3<=0 & p4-D4<=0 wait { c1'=0, c2'=-1, c3'=-1, c4'=0, c5'=0, c6'=0}
    when c2 = 0  do {} goto x3R4R;
    when c3 = 0  do {} goto x2R4R;
    when c2>=1 & p2-D2=0 do {} goto error;
    when c3>=1 & p3-D3=0 do {} goto error;
    when p4-D4=0 do {} goto error;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R3R4W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x2R3R4W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x2R3R4W;
    when c3>=1&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R3W4W;
    when p5-T5>=0   do {p5'=0, c5'=C5} goto x2R3R4W5W;
    when p6-T6>=0   do {p6'=0, c6'=C6} goto x2R3R4W6W;

loc x2R3R4W6W : while c2>=0 & p2-D2<=0 & c3>=0 & p3-D3<=0 & p4-D4<=0 & p6-D6<=0 wait { c1'=0, c2'=-1, c3'=-1, c4'=0, c5'=0, c6'=0}
    when c2 = 0  do {} goto x3R4R6W;
    when c3 = 0  do {} goto x2R4R6W;
    when c2>=1 & p2-D2=0 do {} goto error;
    when c3>=1 & p3-D3=0 do {} goto error;
    when p4-D4=0 do {} goto error;
    when p6-D6=0 do {} goto error;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R3R4W6W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x2R3R4W6W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x2R3R4W6W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x2R3R4W6W;
    when c3>=1&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R3W4W6W;
    when p5-T5>=0   do {p5'=0, c5'=C5} goto x2R3R4W5W6W;

loc x2R3R4W5W : while c2>=0 & p2-D2<=0 & c3>=0 & p3-D3<=0 & p4-D4<=0 & p5-D5<=0 wait { c1'=0, c2'=-1, c3'=-1, c4'=0, c5'=0, c6'=0}
    when c2 = 0  do {} goto x3R4R5W;
    when c3 = 0  do {} goto x2R4R5W;
    when c2>=1 & p2-D2=0 do {} goto error;
    when c3>=1 & p3-D3=0 do {} goto error;
    when p4-D4=0 do {} goto error;
    when p5-D5=0 do {} goto error;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R3R4W5W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x2R3R4W5W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x2R3R4W5W;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x2R3R4W5W;
    when c3>=1&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R3W4W5W;
    when p6-T6>=0   do {p6'=0, c6'=C6} goto x2R3R4W5W6W;

loc x2R3R4W5W6W : while c2>=0 & p2-D2<=0 & c3>=0 & p3-D3<=0 & p4-D4<=0 & p5-D5<=0 & p6-D6<=0 wait { c1'=0, c2'=-1, c3'=-1, c4'=0, c5'=0, c6'=0}
    when c2 = 0  do {} goto x3R4R5W6W;
    when c3 = 0  do {} goto x2R4R5W6W;
    when c2>=1 & p2-D2=0 do {} goto error;
    when c3>=1 & p3-D3=0 do {} goto error;
    when p4-D4=0 do {} goto error;
    when p5-D5=0 do {} goto error;
    when p6-D6=0 do {} goto error;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R3R4W5W6W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x2R3R4W5W6W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x2R3R4W5W6W;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x2R3R4W5W6W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x2R3R4W5W6W;
    when c3>=1&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R3W4W5W6W;

loc x1R : while c1>=0 & p1-D1<=0 wait { c1'=-1, c2'=0, c3'=0, c4'=0, c5'=0, c6'=0}
    when c1 = 0  do {} goto idle;
    when c1>=1 & p1-D1=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R ;
    when p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R;
    when p3-T3>=0   do {p3'=0, c3'=C3} goto x1R3R;
    when p4-T4>=0   do {p4'=0, c4'=C4} goto x1R4R;
    when p5-T5>=0   do {p5'=0, c5'=C5} goto x1R5R;
    when p6-T6>=0   do {p6'=0, c6'=C6} goto x1R6R;

loc x1R6R : while c1>=0 & p1-D1<=0 & c6>=0 & p6-D6<=0 wait { c1'=-1, c2'=0, c3'=0, c4'=0, c5'=0, c6'=-1}
    when c1 = 0  do {} goto x6R;
    when c6 = 0  do {} goto x1R;
    when c1>=1 & p1-D1=0 do {} goto error;
    when c6>=1 & p6-D6=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R6R ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R6R ;
    when c6>=1&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R6W;
    when c6>=1&p3-T3>=0   do {p3'=0, c3'=C3} goto x1R3R6W;
    when c6>=1&p4-T4>=0   do {p4'=0, c4'=C4} goto x1R4R6W;
    when c6>=1&p5-T5>=0   do {p5'=0, c5'=C5} goto x1R5R6W;

loc x1R5R : while c1>=0 & p1-D1<=0 & c5>=0 & p5-D5<=0 wait { c1'=-1, c2'=0, c3'=0, c4'=0, c5'=-1, c6'=0}
    when c1 = 0  do {} goto x5R;
    when c5 = 0  do {} goto x1R;
    when c1>=1 & p1-D1=0 do {} goto error;
    when c5>=1 & p5-D5=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R5R ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R5R ;
    when c5>=1&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R5W;
    when c5>=1&p3-T3>=0   do {p3'=0, c3'=C3} goto x1R3R5W;
    when c5>=1&p4-T4>=0   do {p4'=0, c4'=C4} goto x1R4R5W;
    when p6-T6>=0   do {p6'=0, c6'=C6} goto x1R5R6W;

loc x1R5R6W : while c1>=0 & p1-D1<=0 & c5>=0 & p5-D5<=0 & p6-D6<=0 wait { c1'=-1, c2'=0, c3'=0, c4'=0, c5'=-1, c6'=0}
    when c1 = 0  do {} goto x5R6R;
    when c5 = 0  do {} goto x1R6R;
    when c1>=1 & p1-D1=0 do {} goto error;
    when c5>=1 & p5-D5=0 do {} goto error;
    when p6-D6=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R5R6W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R5R6W ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R5R6W;
    when c5>=1&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R5W6W;
    when c5>=1&p3-T3>=0   do {p3'=0, c3'=C3} goto x1R3R5W6W;
    when c5>=1&p4-T4>=0   do {p4'=0, c4'=C4} goto x1R4R5W6W;

loc x1R4R : while c1>=0 & p1-D1<=0 & c4>=0 & p4-D4<=0 wait { c1'=-1, c2'=0, c3'=0, c4'=-1, c5'=0, c6'=0}
    when c1 = 0  do {} goto x4R;
    when c4 = 0  do {} goto x1R;
    when c1>=1 & p1-D1=0 do {} goto error;
    when c4>=1 & p4-D4=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R4R ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R4R ;
    when c4>=1&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R4W;
    when c4>=1&p3-T3>=0   do {p3'=0, c3'=C3} goto x1R3R4W;
    when p5-T5>=0   do {p5'=0, c5'=C5} goto x1R4R5W;
    when p6-T6>=0   do {p6'=0, c6'=C6} goto x1R4R6W;

loc x1R4R6W : while c1>=0 & p1-D1<=0 & c4>=0 & p4-D4<=0 & p6-D6<=0 wait { c1'=-1, c2'=0, c3'=0, c4'=-1, c5'=0, c6'=0}
    when c1 = 0  do {} goto x4R6R;
    when c4 = 0  do {} goto x1R6R;
    when c1>=1 & p1-D1=0 do {} goto error;
    when c4>=1 & p4-D4=0 do {} goto error;
    when p6-D6=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R4R6W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R4R6W ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R4R6W;
    when c4>=1&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R4W6W;
    when c4>=1&p3-T3>=0   do {p3'=0, c3'=C3} goto x1R3R4W6W;
    when p5-T5>=0   do {p5'=0, c5'=C5} goto x1R4R5W6W;

loc x1R4R5W : while c1>=0 & p1-D1<=0 & c4>=0 & p4-D4<=0 & p5-D5<=0 wait { c1'=-1, c2'=0, c3'=0, c4'=-1, c5'=0, c6'=0}
    when c1 = 0  do {} goto x4R5R;
    when c4 = 0  do {} goto x1R5R;
    when c1>=1 & p1-D1=0 do {} goto error;
    when c4>=1 & p4-D4=0 do {} goto error;
    when p5-D5=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R4R5W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R4R5W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R4R5W;
    when c4>=1&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R4W5W;
    when c4>=1&p3-T3>=0   do {p3'=0, c3'=C3} goto x1R3R4W5W;
    when p6-T6>=0   do {p6'=0, c6'=C6} goto x1R4R5W6W;

loc x1R4R5W6W : while c1>=0 & p1-D1<=0 & c4>=0 & p4-D4<=0 & p5-D5<=0 & p6-D6<=0 wait { c1'=-1, c2'=0, c3'=0, c4'=-1, c5'=0, c6'=0}
    when c1 = 0  do {} goto x4R5R6W;
    when c4 = 0  do {} goto x1R5R6W;
    when c1>=1 & p1-D1=0 do {} goto error;
    when c4>=1 & p4-D4=0 do {} goto error;
    when p5-D5=0 do {} goto error;
    when p6-D6=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R4R5W6W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R4R5W6W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R4R5W6W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R4R5W6W;
    when c4>=1&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R4W5W6W;
    when c4>=1&p3-T3>=0   do {p3'=0, c3'=C3} goto x1R3R4W5W6W;

loc x1R3R : while c1>=0 & p1-D1<=0 & c3>=0 & p3-D3<=0 wait { c1'=-1, c2'=0, c3'=-1, c4'=0, c5'=0, c6'=0}
    when c1 = 0  do {} goto x3R;
    when c3 = 0  do {} goto x1R;
    when c1>=1 & p1-D1=0 do {} goto error;
    when c3>=1 & p3-D3=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R3R ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R3R ;
    when c3>=1&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R3W;
    when p4-T4>=0   do {p4'=0, c4'=C4} goto x1R3R4W;
    when p5-T5>=0   do {p5'=0, c5'=C5} goto x1R3R5W;
    when p6-T6>=0   do {p6'=0, c6'=C6} goto x1R3R6W;

loc x1R3R6W : while c1>=0 & p1-D1<=0 & c3>=0 & p3-D3<=0 & p6-D6<=0 wait { c1'=-1, c2'=0, c3'=-1, c4'=0, c5'=0, c6'=0}
    when c1 = 0  do {} goto x3R6R;
    when c3 = 0  do {} goto x1R6R;
    when c1>=1 & p1-D1=0 do {} goto error;
    when c3>=1 & p3-D3=0 do {} goto error;
    when p6-D6=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R3R6W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R3R6W ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R3R6W;
    when c3>=1&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R3W6W;
    when p4-T4>=0   do {p4'=0, c4'=C4} goto x1R3R4W6W;
    when p5-T5>=0   do {p5'=0, c5'=C5} goto x1R3R5W6W;

loc x1R3R5W : while c1>=0 & p1-D1<=0 & c3>=0 & p3-D3<=0 & p5-D5<=0 wait { c1'=-1, c2'=0, c3'=-1, c4'=0, c5'=0, c6'=0}
    when c1 = 0  do {} goto x3R5R;
    when c3 = 0  do {} goto x1R5R;
    when c1>=1 & p1-D1=0 do {} goto error;
    when c3>=1 & p3-D3=0 do {} goto error;
    when p5-D5=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R3R5W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R3R5W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R3R5W;
    when c3>=1&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R3W5W;
    when p4-T4>=0   do {p4'=0, c4'=C4} goto x1R3R4W5W;
    when p6-T6>=0   do {p6'=0, c6'=C6} goto x1R3R5W6W;

loc x1R3R5W6W : while c1>=0 & p1-D1<=0 & c3>=0 & p3-D3<=0 & p5-D5<=0 & p6-D6<=0 wait { c1'=-1, c2'=0, c3'=-1, c4'=0, c5'=0, c6'=0}
    when c1 = 0  do {} goto x3R5R6W;
    when c3 = 0  do {} goto x1R5R6W;
    when c1>=1 & p1-D1=0 do {} goto error;
    when c3>=1 & p3-D3=0 do {} goto error;
    when p5-D5=0 do {} goto error;
    when p6-D6=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R3R5W6W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R3R5W6W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R3R5W6W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R3R5W6W;
    when c3>=1&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R3W5W6W;
    when p4-T4>=0   do {p4'=0, c4'=C4} goto x1R3R4W5W6W;

loc x1R3R4W : while c1>=0 & p1-D1<=0 & c3>=0 & p3-D3<=0 & p4-D4<=0 wait { c1'=-1, c2'=0, c3'=-1, c4'=0, c5'=0, c6'=0}
    when c1 = 0  do {} goto x3R4R;
    when c3 = 0  do {} goto x1R4R;
    when c1>=1 & p1-D1=0 do {} goto error;
    when c3>=1 & p3-D3=0 do {} goto error;
    when p4-D4=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R3R4W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R3R4W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R3R4W;
    when c3>=1&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R3W4W;
    when p5-T5>=0   do {p5'=0, c5'=C5} goto x1R3R4W5W;
    when p6-T6>=0   do {p6'=0, c6'=C6} goto x1R3R4W6W;

loc x1R3R4W6W : while c1>=0 & p1-D1<=0 & c3>=0 & p3-D3<=0 & p4-D4<=0 & p6-D6<=0 wait { c1'=-1, c2'=0, c3'=-1, c4'=0, c5'=0, c6'=0}
    when c1 = 0  do {} goto x3R4R6W;
    when c3 = 0  do {} goto x1R4R6W;
    when c1>=1 & p1-D1=0 do {} goto error;
    when c3>=1 & p3-D3=0 do {} goto error;
    when p4-D4=0 do {} goto error;
    when p6-D6=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R3R4W6W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R3R4W6W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R3R4W6W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R3R4W6W;
    when c3>=1&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R3W4W6W;
    when p5-T5>=0   do {p5'=0, c5'=C5} goto x1R3R4W5W6W;

loc x1R3R4W5W : while c1>=0 & p1-D1<=0 & c3>=0 & p3-D3<=0 & p4-D4<=0 & p5-D5<=0 wait { c1'=-1, c2'=0, c3'=-1, c4'=0, c5'=0, c6'=0}
    when c1 = 0  do {} goto x3R4R5W;
    when c3 = 0  do {} goto x1R4R5W;
    when c1>=1 & p1-D1=0 do {} goto error;
    when c3>=1 & p3-D3=0 do {} goto error;
    when p4-D4=0 do {} goto error;
    when p5-D5=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R3R4W5W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R3R4W5W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R3R4W5W;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R3R4W5W;
    when c3>=1&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R3W4W5W;
    when p6-T6>=0   do {p6'=0, c6'=C6} goto x1R3R4W5W6W;

loc x1R3R4W5W6W : while c1>=0 & p1-D1<=0 & c3>=0 & p3-D3<=0 & p4-D4<=0 & p5-D5<=0 & p6-D6<=0 wait { c1'=-1, c2'=0, c3'=-1, c4'=0, c5'=0, c6'=0}
    when c1 = 0  do {} goto x3R4R5W6W;
    when c3 = 0  do {} goto x1R4R5W6W;
    when c1>=1 & p1-D1=0 do {} goto error;
    when c3>=1 & p3-D3=0 do {} goto error;
    when p4-D4=0 do {} goto error;
    when p5-D5=0 do {} goto error;
    when p6-D6=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R3R4W5W6W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R3R4W5W6W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R3R4W5W6W;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R3R4W5W6W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R3R4W5W6W;
    when c3>=1&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R3W4W5W6W;

loc x1R2R : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0}
    when c1 = 0  do {} goto x2R;
    when c2 = 0  do {} goto x1R;
    when c1>=1 & p1-D1=0 do {} goto error;
    when c2>=1 & p2-D2=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R ;
    when p3-T3>=0   do {p3'=0, c3'=C3} goto x1R2R3W;
    when p4-T4>=0   do {p4'=0, c4'=C4} goto x1R2R4W;
    when p5-T5>=0   do {p5'=0, c5'=C5} goto x1R2R5W;
    when p6-T6>=0   do {p6'=0, c6'=C6} goto x1R2R6W;

loc x1R2R6W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p6-D6<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0}
    when c1 = 0  do {} goto x2R6R;
    when c2 = 0  do {} goto x1R6R;
    when c1>=1 & p1-D1=0 do {} goto error;
    when c2>=1 & p2-D2=0 do {} goto error;
    when p6-D6=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R6W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R6W ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R2R6W;
    when p3-T3>=0   do {p3'=0, c3'=C3} goto x1R2R3W6W;
    when p4-T4>=0   do {p4'=0, c4'=C4} goto x1R2R4W6W;
    when p5-T5>=0   do {p5'=0, c5'=C5} goto x1R2R5W6W;

loc x1R2R5W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p5-D5<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0}
    when c1 = 0  do {} goto x2R5R;
    when c2 = 0  do {} goto x1R5R;
    when c1>=1 & p1-D1=0 do {} goto error;
    when c2>=1 & p2-D2=0 do {} goto error;
    when p5-D5=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R5W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R5W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R2R5W;
    when p3-T3>=0   do {p3'=0, c3'=C3} goto x1R2R3W5W;
    when p4-T4>=0   do {p4'=0, c4'=C4} goto x1R2R4W5W;
    when p6-T6>=0   do {p6'=0, c6'=C6} goto x1R2R5W6W;

loc x1R2R5W6W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p5-D5<=0 & p6-D6<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0}
    when c1 = 0  do {} goto x2R5R6W;
    when c2 = 0  do {} goto x1R5R6W;
    when c1>=1 & p1-D1=0 do {} goto error;
    when c2>=1 & p2-D2=0 do {} goto error;
    when p5-D5=0 do {} goto error;
    when p6-D6=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R5W6W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R5W6W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R2R5W6W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R2R5W6W;
    when p3-T3>=0   do {p3'=0, c3'=C3} goto x1R2R3W5W6W;
    when p4-T4>=0   do {p4'=0, c4'=C4} goto x1R2R4W5W6W;

loc x1R2R4W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p4-D4<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0}
    when c1 = 0  do {} goto x2R4R;
    when c2 = 0  do {} goto x1R4R;
    when c1>=1 & p1-D1=0 do {} goto error;
    when c2>=1 & p2-D2=0 do {} goto error;
    when p4-D4=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R4W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R4W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R2R4W;
    when p3-T3>=0   do {p3'=0, c3'=C3} goto x1R2R3W4W;
    when p5-T5>=0   do {p5'=0, c5'=C5} goto x1R2R4W5W;
    when p6-T6>=0   do {p6'=0, c6'=C6} goto x1R2R4W6W;

loc x1R2R4W6W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p4-D4<=0 & p6-D6<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0}
    when c1 = 0  do {} goto x2R4R6W;
    when c2 = 0  do {} goto x1R4R6W;
    when c1>=1 & p1-D1=0 do {} goto error;
    when c2>=1 & p2-D2=0 do {} goto error;
    when p4-D4=0 do {} goto error;
    when p6-D6=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R4W6W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R4W6W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R2R4W6W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R2R4W6W;
    when p3-T3>=0   do {p3'=0, c3'=C3} goto x1R2R3W4W6W;
    when p5-T5>=0   do {p5'=0, c5'=C5} goto x1R2R4W5W6W;

loc x1R2R4W5W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p4-D4<=0 & p5-D5<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0}
    when c1 = 0  do {} goto x2R4R5W;
    when c2 = 0  do {} goto x1R4R5W;
    when c1>=1 & p1-D1=0 do {} goto error;
    when c2>=1 & p2-D2=0 do {} goto error;
    when p4-D4=0 do {} goto error;
    when p5-D5=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R4W5W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R4W5W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R2R4W5W;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R2R4W5W;
    when p3-T3>=0   do {p3'=0, c3'=C3} goto x1R2R3W4W5W;
    when p6-T6>=0   do {p6'=0, c6'=C6} goto x1R2R4W5W6W;

loc x1R2R4W5W6W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p4-D4<=0 & p5-D5<=0 & p6-D6<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0}
    when c1 = 0  do {} goto x2R4R5W6W;
    when c2 = 0  do {} goto x1R4R5W6W;
    when c1>=1 & p1-D1=0 do {} goto error;
    when c2>=1 & p2-D2=0 do {} goto error;
    when p4-D4=0 do {} goto error;
    when p5-D5=0 do {} goto error;
    when p6-D6=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R4W5W6W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R4W5W6W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R2R4W5W6W;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R2R4W5W6W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R2R4W5W6W;
    when p3-T3>=0   do {p3'=0, c3'=C3} goto x1R2R3W4W5W6W;

loc x1R2R3W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p3-D3<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0}
    when c1 = 0  do {} goto x2R3R;
    when c2 = 0  do {} goto x1R3R;
    when c1>=1 & p1-D1=0 do {} goto error;
    when c2>=1 & p2-D2=0 do {} goto error;
    when p3-D3=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R3W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R3W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R2R3W;
    when p4-T4>=0   do {p4'=0, c4'=C4} goto x1R2R3W4W;
    when p5-T5>=0   do {p5'=0, c5'=C5} goto x1R2R3W5W;
    when p6-T6>=0   do {p6'=0, c6'=C6} goto x1R2R3W6W;

loc x1R2R3W6W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p3-D3<=0 & p6-D6<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0}
    when c1 = 0  do {} goto x2R3R6W;
    when c2 = 0  do {} goto x1R3R6W;
    when c1>=1 & p1-D1=0 do {} goto error;
    when c2>=1 & p2-D2=0 do {} goto error;
    when p3-D3=0 do {} goto error;
    when p6-D6=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R3W6W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R3W6W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R2R3W6W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R2R3W6W;
    when p4-T4>=0   do {p4'=0, c4'=C4} goto x1R2R3W4W6W;
    when p5-T5>=0   do {p5'=0, c5'=C5} goto x1R2R3W5W6W;

loc x1R2R3W5W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p3-D3<=0 & p5-D5<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0}
    when c1 = 0  do {} goto x2R3R5W;
    when c2 = 0  do {} goto x1R3R5W;
    when c1>=1 & p1-D1=0 do {} goto error;
    when c2>=1 & p2-D2=0 do {} goto error;
    when p3-D3=0 do {} goto error;
    when p5-D5=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R3W5W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R3W5W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R2R3W5W;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R2R3W5W;
    when p4-T4>=0   do {p4'=0, c4'=C4} goto x1R2R3W4W5W;
    when p6-T6>=0   do {p6'=0, c6'=C6} goto x1R2R3W5W6W;

loc x1R2R3W5W6W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p3-D3<=0 & p5-D5<=0 & p6-D6<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0}
    when c1 = 0  do {} goto x2R3R5W6W;
    when c2 = 0  do {} goto x1R3R5W6W;
    when c1>=1 & p1-D1=0 do {} goto error;
    when c2>=1 & p2-D2=0 do {} goto error;
    when p3-D3=0 do {} goto error;
    when p5-D5=0 do {} goto error;
    when p6-D6=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R3W5W6W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R3W5W6W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R2R3W5W6W;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R2R3W5W6W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R2R3W5W6W;
    when p4-T4>=0   do {p4'=0, c4'=C4} goto x1R2R3W4W5W6W;

loc x1R2R3W4W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p3-D3<=0 & p4-D4<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0}
    when c1 = 0  do {} goto x2R3R4W;
    when c2 = 0  do {} goto x1R3R4W;
    when c1>=1 & p1-D1=0 do {} goto error;
    when c2>=1 & p2-D2=0 do {} goto error;
    when p3-D3=0 do {} goto error;
    when p4-D4=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R3W4W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R3W4W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R2R3W4W;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R2R3W4W;
    when p5-T5>=0   do {p5'=0, c5'=C5} goto x1R2R3W4W5W;
    when p6-T6>=0   do {p6'=0, c6'=C6} goto x1R2R3W4W6W;

loc x1R2R3W4W6W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p3-D3<=0 & p4-D4<=0 & p6-D6<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0}
    when c1 = 0  do {} goto x2R3R4W6W;
    when c2 = 0  do {} goto x1R3R4W6W;
    when c1>=1 & p1-D1=0 do {} goto error;
    when c2>=1 & p2-D2=0 do {} goto error;
    when p3-D3=0 do {} goto error;
    when p4-D4=0 do {} goto error;
    when p6-D6=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R3W4W6W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R3W4W6W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R2R3W4W6W;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R2R3W4W6W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R2R3W4W6W;
    when p5-T5>=0   do {p5'=0, c5'=C5} goto x1R2R3W4W5W6W;

loc x1R2R3W4W5W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p3-D3<=0 & p4-D4<=0 & p5-D5<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0}
    when c1 = 0  do {} goto x2R3R4W5W;
    when c2 = 0  do {} goto x1R3R4W5W;
    when c1>=1 & p1-D1=0 do {} goto error;
    when c2>=1 & p2-D2=0 do {} goto error;
    when p3-D3=0 do {} goto error;
    when p4-D4=0 do {} goto error;
    when p5-D5=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R3W4W5W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R3W4W5W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R2R3W4W5W;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R2R3W4W5W;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R2R3W4W5W;
    when p6-T6>=0   do {p6'=0, c6'=C6} goto x1R2R3W4W5W6W;

loc x1R2R3W4W5W6W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p3-D3<=0 & p4-D4<=0 & p5-D5<=0 & p6-D6<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0}
    when c1 = 0  do {} goto x2R3R4W5W6W;
    when c2 = 0  do {} goto x1R3R4W5W6W;
    when c1>=1 & p1-D1=0 do {} goto error;
    when c2>=1 & p2-D2=0 do {} goto error;
    when p3-D3=0 do {} goto error;
    when p4-D4=0 do {} goto error;
    when p5-D5=0 do {} goto error;
    when p6-D6=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R3W4W5W6W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R3W4W5W6W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R2R3W4W5W6W;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R2R3W4W5W6W;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R2R3W4W5W6W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R2R3W4W5W6W;

loc error: while True wait {}

end

init := 
    loc[sched] = idle & 
    p1>=0 & c1=0 &
    p2>=0 & c2=0 &
    p3>=0 & c3=0 &
    p4>=0 & c4=0 &
    p5>=0 & c5=0 &
    p6>=0 & c6=0;
bad := loc[sched]=error;
