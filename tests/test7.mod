
    p1, p2, p3, p4, p5, p6, p7, c1, c2, c3, c4, c5, c6, c7 :var;
    T1 = 11, C1 = 1, D1 = 11,     T2 = 12, C2 = 1, D2 = 12,     T3 = 19, C3 = 2, D3 = 19,     T4 = 20, C4 = 3, D4 = 20,     T5 = 24, C5 = 1, D5 = 24,     T6 = 29, C6 = 7, D6 = 29,     T7 = 29, C7 = 11, D7 = 29: parameter; 

automaton sched

loc idle: while True  wait { c1'=0, c2'=0, c3'=0, c4'=0, c5'=0, c6'=0, c7'=0}
    when p1-T1>=0  do {p1'=0, c1'=C1} goto x1R;
    when p2-T2>=0  do {p2'=0, c2'=C2} goto x2R;
    when p3-T3>=0  do {p3'=0, c3'=C3} goto x3R;
    when p4-T4>=0  do {p4'=0, c4'=C4} goto x4R;
    when p5-T5>=0  do {p5'=0, c5'=C5} goto x5R;
    when p6-T6>=0  do {p6'=0, c6'=C6} goto x6R;
    when p7-T7>=0  do {p7'=0, c7'=C7} goto x7R;


loc x7R : while c7>=0 & p7-D7<=0 wait { c1'=0, c2'=0, c3'=0, c4'=0, c5'=0, c6'=0, c7'=-1}
    when c7 = 0  do {} goto idle;
    when c7>0 & p7-D7=0 do {} goto error;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x7R ;
    when c7>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R7R;
    when c7>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R7R;
    when c7>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x3R7R;
    when c7>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x4R7R;
    when c7>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x5R7R;
    when c7>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x6R7R;

loc x6R : while c6>=0 & p6-D6<=0 wait { c1'=0, c2'=0, c3'=0, c4'=0, c5'=0, c6'=-1, c7'=0}
    when c6 = 0  do {} goto idle;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x6R ;
    when c6>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R6R;
    when c6>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R6R;
    when c6>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x3R6R;
    when c6>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x4R6R;
    when c6>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x5R6R;
    when c6>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x6R7R;

loc x6R7R : while c6>=0 & p6-D6<=0 & c7>=0 & p7-D7<=0 wait { c1'=0, c2'=0, c3'=0, c4'=0, c5'=0, c6'=-1, c7'=-1}
    when c6 = 0  do {} goto x7R;
    when c7 = 0  do {} goto x6R;
    when c7>0 & p7-D7=0 do {} goto error;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x6R7R ;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x6R7R ;
    when c6>0 & c7>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R6R7W;
    when c6>0 & c7>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R6R7W;
    when c6>0 & c7>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x3R6R7W;
    when c6>0 & c7>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x4R6R7W;
    when c6>0 & c7>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x5R6R7W;

loc x5R : while c5>=0 & p5-D5<=0 wait { c1'=0, c2'=0, c3'=0, c4'=0, c5'=-1, c6'=0, c7'=0}
    when c5 = 0  do {} goto idle;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x5R ;
    when c5>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R5R;
    when c5>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R5R;
    when c5>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x3R5R;
    when c5>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x4R5R;
    when c5>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x5R6R;
    when c5>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x5R7R;

loc x5R7R : while c5>=0 & p5-D5<=0 & c7>=0 & p7-D7<=0 wait { c1'=0, c2'=0, c3'=0, c4'=0, c5'=-1, c6'=0, c7'=-1}
    when c5 = 0  do {} goto x7R;
    when c7 = 0  do {} goto x5R;
    when c7>0 & p7-D7=0 do {} goto error;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x5R7R ;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x5R7R ;
    when c5>0 & c7>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R5R7W;
    when c5>0 & c7>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R5R7W;
    when c5>0 & c7>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x3R5R7W;
    when c5>0 & c7>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x4R5R7W;
    when c5>0 & c7>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x5R6R7W;

loc x5R6R : while c5>=0 & p5-D5<=0 & c6>=0 & p6-D6<=0 wait { c1'=0, c2'=0, c3'=0, c4'=0, c5'=-1, c6'=-1, c7'=0}
    when c5 = 0  do {} goto x6R;
    when c6 = 0  do {} goto x5R;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x5R6R ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x5R6R ;
    when c5>0 & c6>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R5R6W;
    when c5>0 & c6>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R5R6W;
    when c5>0 & c6>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x3R5R6W;
    when c5>0 & c6>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x4R5R6W;
    when c5>0 & c6>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x5R6R7W;

loc x5R6R7W : while c5>=0 & p5-D5<=0 & c6>=0 & p6-D6<=0 & p7-D7<=0 wait { c1'=0, c2'=0, c3'=0, c4'=0, c5'=-1, c6'=-1, c7'=0}
    when c5 = 0  do {} goto x6R7R;
    when c6 = 0  do {} goto x5R7R;
    when p7-D7=0 do {} goto error;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x5R6R7W ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x5R6R7W ;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x5R6R7W;
    when c5>0 & c6>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R5R6W7W;
    when c5>0 & c6>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R5R6W7W;
    when c5>0 & c6>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x3R5R6W7W;
    when c5>0 & c6>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x4R5R6W7W;

loc x4R : while c4>=0 & p4-D4<=0 wait { c1'=0, c2'=0, c3'=0, c4'=-1, c5'=0, c6'=0, c7'=0}
    when c4 = 0  do {} goto idle;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x4R ;
    when c4>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R4R;
    when c4>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R4R;
    when c4>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x3R4R;
    when c4>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x4R5R;
    when c4>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x4R6R;
    when c4>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x4R7R;

loc x4R7R : while c4>=0 & p4-D4<=0 & c7>=0 & p7-D7<=0 wait { c1'=0, c2'=0, c3'=0, c4'=-1, c5'=0, c6'=0, c7'=-1}
    when c4 = 0  do {} goto x7R;
    when c7 = 0  do {} goto x4R;
    when c7>0 & p7-D7=0 do {} goto error;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x4R7R ;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x4R7R ;
    when c4>0 & c7>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R4R7W;
    when c4>0 & c7>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R4R7W;
    when c4>0 & c7>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x3R4R7W;
    when c4>0 & c7>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x4R5R7W;
    when c4>0 & c7>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x4R6R7W;

loc x4R6R : while c4>=0 & p4-D4<=0 & c6>=0 & p6-D6<=0 wait { c1'=0, c2'=0, c3'=0, c4'=-1, c5'=0, c6'=-1, c7'=0}
    when c4 = 0  do {} goto x6R;
    when c6 = 0  do {} goto x4R;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x4R6R ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x4R6R ;
    when c4>0 & c6>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R4R6W;
    when c4>0 & c6>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R4R6W;
    when c4>0 & c6>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x3R4R6W;
    when c4>0 & c6>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x4R5R6W;
    when c4>0 & c6>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x4R6R7W;

loc x4R6R7W : while c4>=0 & p4-D4<=0 & c6>=0 & p6-D6<=0 & p7-D7<=0 wait { c1'=0, c2'=0, c3'=0, c4'=-1, c5'=0, c6'=-1, c7'=0}
    when c4 = 0  do {} goto x6R7R;
    when c6 = 0  do {} goto x4R7R;
    when p7-D7=0 do {} goto error;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x4R6R7W ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x4R6R7W ;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x4R6R7W;
    when c4>0 & c6>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R4R6W7W;
    when c4>0 & c6>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R4R6W7W;
    when c4>0 & c6>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x3R4R6W7W;
    when c4>0 & c6>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x4R5R6W7W;

loc x4R5R : while c4>=0 & p4-D4<=0 & c5>=0 & p5-D5<=0 wait { c1'=0, c2'=0, c3'=0, c4'=-1, c5'=-1, c6'=0, c7'=0}
    when c4 = 0  do {} goto x5R;
    when c5 = 0  do {} goto x4R;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x4R5R ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x4R5R ;
    when c4>0 & c5>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R4R5W;
    when c4>0 & c5>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R4R5W;
    when c4>0 & c5>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x3R4R5W;
    when c4>0 & c5>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x4R5R6W;
    when c4>0 & c5>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x4R5R7W;

loc x4R5R7W : while c4>=0 & p4-D4<=0 & c5>=0 & p5-D5<=0 & p7-D7<=0 wait { c1'=0, c2'=0, c3'=0, c4'=-1, c5'=-1, c6'=0, c7'=0}
    when c4 = 0  do {} goto x5R7R;
    when c5 = 0  do {} goto x4R7R;
    when p7-D7=0 do {} goto error;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x4R5R7W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x4R5R7W ;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x4R5R7W;
    when c4>0 & c5>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R4R5W7W;
    when c4>0 & c5>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R4R5W7W;
    when c4>0 & c5>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x3R4R5W7W;
    when c4>0 & c5>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x4R5R6W7W;

loc x4R5R6W : while c4>=0 & p4-D4<=0 & c5>=0 & p5-D5<=0 & p6-D6<=0 wait { c1'=0, c2'=0, c3'=0, c4'=-1, c5'=-1, c6'=0, c7'=0}
    when c4 = 0  do {} goto x5R6R;
    when c5 = 0  do {} goto x4R6R;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x4R5R6W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x4R5R6W ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x4R5R6W;
    when c4>0 & c5>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R4R5W6W;
    when c4>0 & c5>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R4R5W6W;
    when c4>0 & c5>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x3R4R5W6W;
    when c4>0 & c5>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x4R5R6W7W;

loc x4R5R6W7W : while c4>=0 & p4-D4<=0 & c5>=0 & p5-D5<=0 & p6-D6<=0 & p7-D7<=0 wait { c1'=0, c2'=0, c3'=0, c4'=-1, c5'=-1, c6'=0, c7'=0}
    when c4 = 0  do {} goto x5R6R7W;
    when c5 = 0  do {} goto x4R6R7W;
    when p7-D7=0 do {} goto error;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x4R5R6W7W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x4R5R6W7W ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x4R5R6W7W;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x4R5R6W7W;
    when c4>0 & c5>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R4R5W6W7W;
    when c4>0 & c5>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R4R5W6W7W;
    when c4>0 & c5>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x3R4R5W6W7W;

loc x3R : while c3>=0 & p3-D3<=0 wait { c1'=0, c2'=0, c3'=-1, c4'=0, c5'=0, c6'=0, c7'=0}
    when c3 = 0  do {} goto idle;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x3R ;
    when c3>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R3R;
    when c3>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R3R;
    when c3>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x3R4R;
    when c3>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x3R5R;
    when c3>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x3R6R;
    when c3>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x3R7R;

loc x3R7R : while c3>=0 & p3-D3<=0 & c7>=0 & p7-D7<=0 wait { c1'=0, c2'=0, c3'=-1, c4'=0, c5'=0, c6'=0, c7'=-1}
    when c3 = 0  do {} goto x7R;
    when c7 = 0  do {} goto x3R;
    when c7>0 & p7-D7=0 do {} goto error;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x3R7R ;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x3R7R ;
    when c3>0 & c7>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R3R7W;
    when c3>0 & c7>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R3R7W;
    when c3>0 & c7>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x3R4R7W;
    when c3>0 & c7>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x3R5R7W;
    when c3>0 & c7>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x3R6R7W;

loc x3R6R : while c3>=0 & p3-D3<=0 & c6>=0 & p6-D6<=0 wait { c1'=0, c2'=0, c3'=-1, c4'=0, c5'=0, c6'=-1, c7'=0}
    when c3 = 0  do {} goto x6R;
    when c6 = 0  do {} goto x3R;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x3R6R ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x3R6R ;
    when c3>0 & c6>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R3R6W;
    when c3>0 & c6>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R3R6W;
    when c3>0 & c6>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x3R4R6W;
    when c3>0 & c6>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x3R5R6W;
    when c3>0 & c6>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x3R6R7W;

loc x3R6R7W : while c3>=0 & p3-D3<=0 & c6>=0 & p6-D6<=0 & p7-D7<=0 wait { c1'=0, c2'=0, c3'=-1, c4'=0, c5'=0, c6'=-1, c7'=0}
    when c3 = 0  do {} goto x6R7R;
    when c6 = 0  do {} goto x3R7R;
    when p7-D7=0 do {} goto error;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x3R6R7W ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x3R6R7W ;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x3R6R7W;
    when c3>0 & c6>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R3R6W7W;
    when c3>0 & c6>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R3R6W7W;
    when c3>0 & c6>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x3R4R6W7W;
    when c3>0 & c6>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x3R5R6W7W;

loc x3R5R : while c3>=0 & p3-D3<=0 & c5>=0 & p5-D5<=0 wait { c1'=0, c2'=0, c3'=-1, c4'=0, c5'=-1, c6'=0, c7'=0}
    when c3 = 0  do {} goto x5R;
    when c5 = 0  do {} goto x3R;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x3R5R ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x3R5R ;
    when c3>0 & c5>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R3R5W;
    when c3>0 & c5>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R3R5W;
    when c3>0 & c5>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x3R4R5W;
    when c3>0 & c5>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x3R5R6W;
    when c3>0 & c5>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x3R5R7W;

loc x3R5R7W : while c3>=0 & p3-D3<=0 & c5>=0 & p5-D5<=0 & p7-D7<=0 wait { c1'=0, c2'=0, c3'=-1, c4'=0, c5'=-1, c6'=0, c7'=0}
    when c3 = 0  do {} goto x5R7R;
    when c5 = 0  do {} goto x3R7R;
    when p7-D7=0 do {} goto error;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x3R5R7W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x3R5R7W ;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x3R5R7W;
    when c3>0 & c5>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R3R5W7W;
    when c3>0 & c5>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R3R5W7W;
    when c3>0 & c5>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x3R4R5W7W;
    when c3>0 & c5>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x3R5R6W7W;

loc x3R5R6W : while c3>=0 & p3-D3<=0 & c5>=0 & p5-D5<=0 & p6-D6<=0 wait { c1'=0, c2'=0, c3'=-1, c4'=0, c5'=-1, c6'=0, c7'=0}
    when c3 = 0  do {} goto x5R6R;
    when c5 = 0  do {} goto x3R6R;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x3R5R6W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x3R5R6W ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x3R5R6W;
    when c3>0 & c5>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R3R5W6W;
    when c3>0 & c5>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R3R5W6W;
    when c3>0 & c5>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x3R4R5W6W;
    when c3>0 & c5>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x3R5R6W7W;

loc x3R5R6W7W : while c3>=0 & p3-D3<=0 & c5>=0 & p5-D5<=0 & p6-D6<=0 & p7-D7<=0 wait { c1'=0, c2'=0, c3'=-1, c4'=0, c5'=-1, c6'=0, c7'=0}
    when c3 = 0  do {} goto x5R6R7W;
    when c5 = 0  do {} goto x3R6R7W;
    when p7-D7=0 do {} goto error;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x3R5R6W7W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x3R5R6W7W ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x3R5R6W7W;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x3R5R6W7W;
    when c3>0 & c5>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R3R5W6W7W;
    when c3>0 & c5>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R3R5W6W7W;
    when c3>0 & c5>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x3R4R5W6W7W;

loc x3R4R : while c3>=0 & p3-D3<=0 & c4>=0 & p4-D4<=0 wait { c1'=0, c2'=0, c3'=-1, c4'=-1, c5'=0, c6'=0, c7'=0}
    when c3 = 0  do {} goto x4R;
    when c4 = 0  do {} goto x3R;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x3R4R ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x3R4R ;
    when c3>0 & c4>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R3R4W;
    when c3>0 & c4>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R3R4W;
    when c3>0 & c4>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x3R4R5W;
    when c3>0 & c4>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x3R4R6W;
    when c3>0 & c4>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x3R4R7W;

loc x3R4R7W : while c3>=0 & p3-D3<=0 & c4>=0 & p4-D4<=0 & p7-D7<=0 wait { c1'=0, c2'=0, c3'=-1, c4'=-1, c5'=0, c6'=0, c7'=0}
    when c3 = 0  do {} goto x4R7R;
    when c4 = 0  do {} goto x3R7R;
    when p7-D7=0 do {} goto error;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x3R4R7W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x3R4R7W ;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x3R4R7W;
    when c3>0 & c4>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R3R4W7W;
    when c3>0 & c4>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R3R4W7W;
    when c3>0 & c4>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x3R4R5W7W;
    when c3>0 & c4>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x3R4R6W7W;

loc x3R4R6W : while c3>=0 & p3-D3<=0 & c4>=0 & p4-D4<=0 & p6-D6<=0 wait { c1'=0, c2'=0, c3'=-1, c4'=-1, c5'=0, c6'=0, c7'=0}
    when c3 = 0  do {} goto x4R6R;
    when c4 = 0  do {} goto x3R6R;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x3R4R6W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x3R4R6W ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x3R4R6W;
    when c3>0 & c4>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R3R4W6W;
    when c3>0 & c4>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R3R4W6W;
    when c3>0 & c4>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x3R4R5W6W;
    when c3>0 & c4>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x3R4R6W7W;

loc x3R4R6W7W : while c3>=0 & p3-D3<=0 & c4>=0 & p4-D4<=0 & p6-D6<=0 & p7-D7<=0 wait { c1'=0, c2'=0, c3'=-1, c4'=-1, c5'=0, c6'=0, c7'=0}
    when c3 = 0  do {} goto x4R6R7W;
    when c4 = 0  do {} goto x3R6R7W;
    when p7-D7=0 do {} goto error;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x3R4R6W7W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x3R4R6W7W ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x3R4R6W7W;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x3R4R6W7W;
    when c3>0 & c4>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R3R4W6W7W;
    when c3>0 & c4>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R3R4W6W7W;
    when c3>0 & c4>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x3R4R5W6W7W;

loc x3R4R5W : while c3>=0 & p3-D3<=0 & c4>=0 & p4-D4<=0 & p5-D5<=0 wait { c1'=0, c2'=0, c3'=-1, c4'=-1, c5'=0, c6'=0, c7'=0}
    when c3 = 0  do {} goto x4R5R;
    when c4 = 0  do {} goto x3R5R;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x3R4R5W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x3R4R5W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x3R4R5W;
    when c3>0 & c4>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R3R4W5W;
    when c3>0 & c4>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R3R4W5W;
    when c3>0 & c4>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x3R4R5W6W;
    when c3>0 & c4>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x3R4R5W7W;

loc x3R4R5W7W : while c3>=0 & p3-D3<=0 & c4>=0 & p4-D4<=0 & p5-D5<=0 & p7-D7<=0 wait { c1'=0, c2'=0, c3'=-1, c4'=-1, c5'=0, c6'=0, c7'=0}
    when c3 = 0  do {} goto x4R5R7W;
    when c4 = 0  do {} goto x3R5R7W;
    when p7-D7=0 do {} goto error;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x3R4R5W7W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x3R4R5W7W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x3R4R5W7W;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x3R4R5W7W;
    when c3>0 & c4>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R3R4W5W7W;
    when c3>0 & c4>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R3R4W5W7W;
    when c3>0 & c4>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x3R4R5W6W7W;

loc x3R4R5W6W : while c3>=0 & p3-D3<=0 & c4>=0 & p4-D4<=0 & p5-D5<=0 & p6-D6<=0 wait { c1'=0, c2'=0, c3'=-1, c4'=-1, c5'=0, c6'=0, c7'=0}
    when c3 = 0  do {} goto x4R5R6W;
    when c4 = 0  do {} goto x3R5R6W;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x3R4R5W6W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x3R4R5W6W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x3R4R5W6W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x3R4R5W6W;
    when c3>0 & c4>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R3R4W5W6W;
    when c3>0 & c4>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R3R4W5W6W;
    when c3>0 & c4>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x3R4R5W6W7W;

loc x3R4R5W6W7W : while c3>=0 & p3-D3<=0 & c4>=0 & p4-D4<=0 & p5-D5<=0 & p6-D6<=0 & p7-D7<=0 wait { c1'=0, c2'=0, c3'=-1, c4'=-1, c5'=0, c6'=0, c7'=0}
    when c3 = 0  do {} goto x4R5R6W7W;
    when c4 = 0  do {} goto x3R5R6W7W;
    when p7-D7=0 do {} goto error;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x3R4R5W6W7W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x3R4R5W6W7W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x3R4R5W6W7W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x3R4R5W6W7W;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x3R4R5W6W7W;
    when c3>0 & c4>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R3R4W5W6W7W;
    when c3>0 & c4>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x2R3R4W5W6W7W;

loc x2R : while c2>=0 & p2-D2<=0 wait { c1'=0, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0, c7'=0}
    when c2 = 0  do {} goto idle;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R ;
    when c2>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R;
    when c2>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x2R3R;
    when c2>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x2R4R;
    when c2>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x2R5R;
    when c2>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x2R6R;
    when c2>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x2R7R;

loc x2R7R : while c2>=0 & p2-D2<=0 & c7>=0 & p7-D7<=0 wait { c1'=0, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0, c7'=-1}
    when c2 = 0  do {} goto x7R;
    when c7 = 0  do {} goto x2R;
    when c7>0 & p7-D7=0 do {} goto error;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R7R ;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x2R7R ;
    when c2>0 & c7>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R7W;
    when c2>0 & c7>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x2R3R7W;
    when c2>0 & c7>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x2R4R7W;
    when c2>0 & c7>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x2R5R7W;
    when c2>0 & c7>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x2R6R7W;

loc x2R6R : while c2>=0 & p2-D2<=0 & c6>=0 & p6-D6<=0 wait { c1'=0, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=-1, c7'=0}
    when c2 = 0  do {} goto x6R;
    when c6 = 0  do {} goto x2R;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R6R ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x2R6R ;
    when c2>0 & c6>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R6W;
    when c2>0 & c6>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x2R3R6W;
    when c2>0 & c6>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x2R4R6W;
    when c2>0 & c6>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x2R5R6W;
    when c2>0 & c6>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x2R6R7W;

loc x2R6R7W : while c2>=0 & p2-D2<=0 & c6>=0 & p6-D6<=0 & p7-D7<=0 wait { c1'=0, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=-1, c7'=0}
    when c2 = 0  do {} goto x6R7R;
    when c6 = 0  do {} goto x2R7R;
    when p7-D7=0 do {} goto error;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R6R7W ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x2R6R7W ;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x2R6R7W;
    when c2>0 & c6>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R6W7W;
    when c2>0 & c6>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x2R3R6W7W;
    when c2>0 & c6>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x2R4R6W7W;
    when c2>0 & c6>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x2R5R6W7W;

loc x2R5R : while c2>=0 & p2-D2<=0 & c5>=0 & p5-D5<=0 wait { c1'=0, c2'=-1, c3'=0, c4'=0, c5'=-1, c6'=0, c7'=0}
    when c2 = 0  do {} goto x5R;
    when c5 = 0  do {} goto x2R;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R5R ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x2R5R ;
    when c2>0 & c5>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R5W;
    when c2>0 & c5>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x2R3R5W;
    when c2>0 & c5>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x2R4R5W;
    when c2>0 & c5>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x2R5R6W;
    when c2>0 & c5>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x2R5R7W;

loc x2R5R7W : while c2>=0 & p2-D2<=0 & c5>=0 & p5-D5<=0 & p7-D7<=0 wait { c1'=0, c2'=-1, c3'=0, c4'=0, c5'=-1, c6'=0, c7'=0}
    when c2 = 0  do {} goto x5R7R;
    when c5 = 0  do {} goto x2R7R;
    when p7-D7=0 do {} goto error;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R5R7W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x2R5R7W ;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x2R5R7W;
    when c2>0 & c5>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R5W7W;
    when c2>0 & c5>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x2R3R5W7W;
    when c2>0 & c5>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x2R4R5W7W;
    when c2>0 & c5>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x2R5R6W7W;

loc x2R5R6W : while c2>=0 & p2-D2<=0 & c5>=0 & p5-D5<=0 & p6-D6<=0 wait { c1'=0, c2'=-1, c3'=0, c4'=0, c5'=-1, c6'=0, c7'=0}
    when c2 = 0  do {} goto x5R6R;
    when c5 = 0  do {} goto x2R6R;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R5R6W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x2R5R6W ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x2R5R6W;
    when c2>0 & c5>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R5W6W;
    when c2>0 & c5>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x2R3R5W6W;
    when c2>0 & c5>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x2R4R5W6W;
    when c2>0 & c5>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x2R5R6W7W;

loc x2R5R6W7W : while c2>=0 & p2-D2<=0 & c5>=0 & p5-D5<=0 & p6-D6<=0 & p7-D7<=0 wait { c1'=0, c2'=-1, c3'=0, c4'=0, c5'=-1, c6'=0, c7'=0}
    when c2 = 0  do {} goto x5R6R7W;
    when c5 = 0  do {} goto x2R6R7W;
    when p7-D7=0 do {} goto error;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R5R6W7W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x2R5R6W7W ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x2R5R6W7W;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x2R5R6W7W;
    when c2>0 & c5>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R5W6W7W;
    when c2>0 & c5>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x2R3R5W6W7W;
    when c2>0 & c5>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x2R4R5W6W7W;

loc x2R4R : while c2>=0 & p2-D2<=0 & c4>=0 & p4-D4<=0 wait { c1'=0, c2'=-1, c3'=0, c4'=-1, c5'=0, c6'=0, c7'=0}
    when c2 = 0  do {} goto x4R;
    when c4 = 0  do {} goto x2R;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R4R ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x2R4R ;
    when c2>0 & c4>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R4W;
    when c2>0 & c4>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x2R3R4W;
    when c2>0 & c4>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x2R4R5W;
    when c2>0 & c4>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x2R4R6W;
    when c2>0 & c4>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x2R4R7W;

loc x2R4R7W : while c2>=0 & p2-D2<=0 & c4>=0 & p4-D4<=0 & p7-D7<=0 wait { c1'=0, c2'=-1, c3'=0, c4'=-1, c5'=0, c6'=0, c7'=0}
    when c2 = 0  do {} goto x4R7R;
    when c4 = 0  do {} goto x2R7R;
    when p7-D7=0 do {} goto error;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R4R7W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x2R4R7W ;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x2R4R7W;
    when c2>0 & c4>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R4W7W;
    when c2>0 & c4>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x2R3R4W7W;
    when c2>0 & c4>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x2R4R5W7W;
    when c2>0 & c4>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x2R4R6W7W;

loc x2R4R6W : while c2>=0 & p2-D2<=0 & c4>=0 & p4-D4<=0 & p6-D6<=0 wait { c1'=0, c2'=-1, c3'=0, c4'=-1, c5'=0, c6'=0, c7'=0}
    when c2 = 0  do {} goto x4R6R;
    when c4 = 0  do {} goto x2R6R;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R4R6W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x2R4R6W ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x2R4R6W;
    when c2>0 & c4>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R4W6W;
    when c2>0 & c4>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x2R3R4W6W;
    when c2>0 & c4>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x2R4R5W6W;
    when c2>0 & c4>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x2R4R6W7W;

loc x2R4R6W7W : while c2>=0 & p2-D2<=0 & c4>=0 & p4-D4<=0 & p6-D6<=0 & p7-D7<=0 wait { c1'=0, c2'=-1, c3'=0, c4'=-1, c5'=0, c6'=0, c7'=0}
    when c2 = 0  do {} goto x4R6R7W;
    when c4 = 0  do {} goto x2R6R7W;
    when p7-D7=0 do {} goto error;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R4R6W7W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x2R4R6W7W ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x2R4R6W7W;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x2R4R6W7W;
    when c2>0 & c4>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R4W6W7W;
    when c2>0 & c4>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x2R3R4W6W7W;
    when c2>0 & c4>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x2R4R5W6W7W;

loc x2R4R5W : while c2>=0 & p2-D2<=0 & c4>=0 & p4-D4<=0 & p5-D5<=0 wait { c1'=0, c2'=-1, c3'=0, c4'=-1, c5'=0, c6'=0, c7'=0}
    when c2 = 0  do {} goto x4R5R;
    when c4 = 0  do {} goto x2R5R;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R4R5W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x2R4R5W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x2R4R5W;
    when c2>0 & c4>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R4W5W;
    when c2>0 & c4>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x2R3R4W5W;
    when c2>0 & c4>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x2R4R5W6W;
    when c2>0 & c4>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x2R4R5W7W;

loc x2R4R5W7W : while c2>=0 & p2-D2<=0 & c4>=0 & p4-D4<=0 & p5-D5<=0 & p7-D7<=0 wait { c1'=0, c2'=-1, c3'=0, c4'=-1, c5'=0, c6'=0, c7'=0}
    when c2 = 0  do {} goto x4R5R7W;
    when c4 = 0  do {} goto x2R5R7W;
    when p7-D7=0 do {} goto error;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R4R5W7W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x2R4R5W7W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x2R4R5W7W;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x2R4R5W7W;
    when c2>0 & c4>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R4W5W7W;
    when c2>0 & c4>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x2R3R4W5W7W;
    when c2>0 & c4>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x2R4R5W6W7W;

loc x2R4R5W6W : while c2>=0 & p2-D2<=0 & c4>=0 & p4-D4<=0 & p5-D5<=0 & p6-D6<=0 wait { c1'=0, c2'=-1, c3'=0, c4'=-1, c5'=0, c6'=0, c7'=0}
    when c2 = 0  do {} goto x4R5R6W;
    when c4 = 0  do {} goto x2R5R6W;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R4R5W6W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x2R4R5W6W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x2R4R5W6W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x2R4R5W6W;
    when c2>0 & c4>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R4W5W6W;
    when c2>0 & c4>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x2R3R4W5W6W;
    when c2>0 & c4>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x2R4R5W6W7W;

loc x2R4R5W6W7W : while c2>=0 & p2-D2<=0 & c4>=0 & p4-D4<=0 & p5-D5<=0 & p6-D6<=0 & p7-D7<=0 wait { c1'=0, c2'=-1, c3'=0, c4'=-1, c5'=0, c6'=0, c7'=0}
    when c2 = 0  do {} goto x4R5R6W7W;
    when c4 = 0  do {} goto x2R5R6W7W;
    when p7-D7=0 do {} goto error;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R4R5W6W7W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x2R4R5W6W7W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x2R4R5W6W7W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x2R4R5W6W7W;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x2R4R5W6W7W;
    when c2>0 & c4>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R4W5W6W7W;
    when c2>0 & c4>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x2R3R4W5W6W7W;

loc x2R3R : while c2>=0 & p2-D2<=0 & c3>=0 & p3-D3<=0 wait { c1'=0, c2'=-1, c3'=-1, c4'=0, c5'=0, c6'=0, c7'=0}
    when c2 = 0  do {} goto x3R;
    when c3 = 0  do {} goto x2R;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R3R ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x2R3R ;
    when c2>0 & c3>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R3W;
    when c2>0 & c3>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x2R3R4W;
    when c2>0 & c3>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x2R3R5W;
    when c2>0 & c3>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x2R3R6W;
    when c2>0 & c3>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x2R3R7W;

loc x2R3R7W : while c2>=0 & p2-D2<=0 & c3>=0 & p3-D3<=0 & p7-D7<=0 wait { c1'=0, c2'=-1, c3'=-1, c4'=0, c5'=0, c6'=0, c7'=0}
    when c2 = 0  do {} goto x3R7R;
    when c3 = 0  do {} goto x2R7R;
    when p7-D7=0 do {} goto error;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R3R7W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x2R3R7W ;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x2R3R7W;
    when c2>0 & c3>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R3W7W;
    when c2>0 & c3>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x2R3R4W7W;
    when c2>0 & c3>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x2R3R5W7W;
    when c2>0 & c3>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x2R3R6W7W;

loc x2R3R6W : while c2>=0 & p2-D2<=0 & c3>=0 & p3-D3<=0 & p6-D6<=0 wait { c1'=0, c2'=-1, c3'=-1, c4'=0, c5'=0, c6'=0, c7'=0}
    when c2 = 0  do {} goto x3R6R;
    when c3 = 0  do {} goto x2R6R;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R3R6W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x2R3R6W ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x2R3R6W;
    when c2>0 & c3>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R3W6W;
    when c2>0 & c3>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x2R3R4W6W;
    when c2>0 & c3>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x2R3R5W6W;
    when c2>0 & c3>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x2R3R6W7W;

loc x2R3R6W7W : while c2>=0 & p2-D2<=0 & c3>=0 & p3-D3<=0 & p6-D6<=0 & p7-D7<=0 wait { c1'=0, c2'=-1, c3'=-1, c4'=0, c5'=0, c6'=0, c7'=0}
    when c2 = 0  do {} goto x3R6R7W;
    when c3 = 0  do {} goto x2R6R7W;
    when p7-D7=0 do {} goto error;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R3R6W7W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x2R3R6W7W ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x2R3R6W7W;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x2R3R6W7W;
    when c2>0 & c3>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R3W6W7W;
    when c2>0 & c3>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x2R3R4W6W7W;
    when c2>0 & c3>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x2R3R5W6W7W;

loc x2R3R5W : while c2>=0 & p2-D2<=0 & c3>=0 & p3-D3<=0 & p5-D5<=0 wait { c1'=0, c2'=-1, c3'=-1, c4'=0, c5'=0, c6'=0, c7'=0}
    when c2 = 0  do {} goto x3R5R;
    when c3 = 0  do {} goto x2R5R;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R3R5W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x2R3R5W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x2R3R5W;
    when c2>0 & c3>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R3W5W;
    when c2>0 & c3>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x2R3R4W5W;
    when c2>0 & c3>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x2R3R5W6W;
    when c2>0 & c3>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x2R3R5W7W;

loc x2R3R5W7W : while c2>=0 & p2-D2<=0 & c3>=0 & p3-D3<=0 & p5-D5<=0 & p7-D7<=0 wait { c1'=0, c2'=-1, c3'=-1, c4'=0, c5'=0, c6'=0, c7'=0}
    when c2 = 0  do {} goto x3R5R7W;
    when c3 = 0  do {} goto x2R5R7W;
    when p7-D7=0 do {} goto error;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R3R5W7W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x2R3R5W7W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x2R3R5W7W;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x2R3R5W7W;
    when c2>0 & c3>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R3W5W7W;
    when c2>0 & c3>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x2R3R4W5W7W;
    when c2>0 & c3>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x2R3R5W6W7W;

loc x2R3R5W6W : while c2>=0 & p2-D2<=0 & c3>=0 & p3-D3<=0 & p5-D5<=0 & p6-D6<=0 wait { c1'=0, c2'=-1, c3'=-1, c4'=0, c5'=0, c6'=0, c7'=0}
    when c2 = 0  do {} goto x3R5R6W;
    when c3 = 0  do {} goto x2R5R6W;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R3R5W6W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x2R3R5W6W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x2R3R5W6W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x2R3R5W6W;
    when c2>0 & c3>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R3W5W6W;
    when c2>0 & c3>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x2R3R4W5W6W;
    when c2>0 & c3>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x2R3R5W6W7W;

loc x2R3R5W6W7W : while c2>=0 & p2-D2<=0 & c3>=0 & p3-D3<=0 & p5-D5<=0 & p6-D6<=0 & p7-D7<=0 wait { c1'=0, c2'=-1, c3'=-1, c4'=0, c5'=0, c6'=0, c7'=0}
    when c2 = 0  do {} goto x3R5R6W7W;
    when c3 = 0  do {} goto x2R5R6W7W;
    when p7-D7=0 do {} goto error;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R3R5W6W7W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x2R3R5W6W7W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x2R3R5W6W7W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x2R3R5W6W7W;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x2R3R5W6W7W;
    when c2>0 & c3>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R3W5W6W7W;
    when c2>0 & c3>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x2R3R4W5W6W7W;

loc x2R3R4W : while c2>=0 & p2-D2<=0 & c3>=0 & p3-D3<=0 & p4-D4<=0 wait { c1'=0, c2'=-1, c3'=-1, c4'=0, c5'=0, c6'=0, c7'=0}
    when c2 = 0  do {} goto x3R4R;
    when c3 = 0  do {} goto x2R4R;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R3R4W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x2R3R4W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x2R3R4W;
    when c2>0 & c3>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R3W4W;
    when c2>0 & c3>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x2R3R4W5W;
    when c2>0 & c3>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x2R3R4W6W;
    when c2>0 & c3>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x2R3R4W7W;

loc x2R3R4W7W : while c2>=0 & p2-D2<=0 & c3>=0 & p3-D3<=0 & p4-D4<=0 & p7-D7<=0 wait { c1'=0, c2'=-1, c3'=-1, c4'=0, c5'=0, c6'=0, c7'=0}
    when c2 = 0  do {} goto x3R4R7W;
    when c3 = 0  do {} goto x2R4R7W;
    when p7-D7=0 do {} goto error;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R3R4W7W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x2R3R4W7W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x2R3R4W7W;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x2R3R4W7W;
    when c2>0 & c3>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R3W4W7W;
    when c2>0 & c3>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x2R3R4W5W7W;
    when c2>0 & c3>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x2R3R4W6W7W;

loc x2R3R4W6W : while c2>=0 & p2-D2<=0 & c3>=0 & p3-D3<=0 & p4-D4<=0 & p6-D6<=0 wait { c1'=0, c2'=-1, c3'=-1, c4'=0, c5'=0, c6'=0, c7'=0}
    when c2 = 0  do {} goto x3R4R6W;
    when c3 = 0  do {} goto x2R4R6W;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R3R4W6W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x2R3R4W6W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x2R3R4W6W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x2R3R4W6W;
    when c2>0 & c3>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R3W4W6W;
    when c2>0 & c3>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x2R3R4W5W6W;
    when c2>0 & c3>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x2R3R4W6W7W;

loc x2R3R4W6W7W : while c2>=0 & p2-D2<=0 & c3>=0 & p3-D3<=0 & p4-D4<=0 & p6-D6<=0 & p7-D7<=0 wait { c1'=0, c2'=-1, c3'=-1, c4'=0, c5'=0, c6'=0, c7'=0}
    when c2 = 0  do {} goto x3R4R6W7W;
    when c3 = 0  do {} goto x2R4R6W7W;
    when p7-D7=0 do {} goto error;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R3R4W6W7W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x2R3R4W6W7W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x2R3R4W6W7W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x2R3R4W6W7W;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x2R3R4W6W7W;
    when c2>0 & c3>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R3W4W6W7W;
    when c2>0 & c3>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x2R3R4W5W6W7W;

loc x2R3R4W5W : while c2>=0 & p2-D2<=0 & c3>=0 & p3-D3<=0 & p4-D4<=0 & p5-D5<=0 wait { c1'=0, c2'=-1, c3'=-1, c4'=0, c5'=0, c6'=0, c7'=0}
    when c2 = 0  do {} goto x3R4R5W;
    when c3 = 0  do {} goto x2R4R5W;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R3R4W5W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x2R3R4W5W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x2R3R4W5W;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x2R3R4W5W;
    when c2>0 & c3>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R3W4W5W;
    when c2>0 & c3>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x2R3R4W5W6W;
    when c2>0 & c3>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x2R3R4W5W7W;

loc x2R3R4W5W7W : while c2>=0 & p2-D2<=0 & c3>=0 & p3-D3<=0 & p4-D4<=0 & p5-D5<=0 & p7-D7<=0 wait { c1'=0, c2'=-1, c3'=-1, c4'=0, c5'=0, c6'=0, c7'=0}
    when c2 = 0  do {} goto x3R4R5W7W;
    when c3 = 0  do {} goto x2R4R5W7W;
    when p7-D7=0 do {} goto error;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R3R4W5W7W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x2R3R4W5W7W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x2R3R4W5W7W;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x2R3R4W5W7W;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x2R3R4W5W7W;
    when c2>0 & c3>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R3W4W5W7W;
    when c2>0 & c3>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x2R3R4W5W6W7W;

loc x2R3R4W5W6W : while c2>=0 & p2-D2<=0 & c3>=0 & p3-D3<=0 & p4-D4<=0 & p5-D5<=0 & p6-D6<=0 wait { c1'=0, c2'=-1, c3'=-1, c4'=0, c5'=0, c6'=0, c7'=0}
    when c2 = 0  do {} goto x3R4R5W6W;
    when c3 = 0  do {} goto x2R4R5W6W;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R3R4W5W6W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x2R3R4W5W6W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x2R3R4W5W6W;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x2R3R4W5W6W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x2R3R4W5W6W;
    when c2>0 & c3>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R3W4W5W6W;
    when c2>0 & c3>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x2R3R4W5W6W7W;

loc x2R3R4W5W6W7W : while c2>=0 & p2-D2<=0 & c3>=0 & p3-D3<=0 & p4-D4<=0 & p5-D5<=0 & p6-D6<=0 & p7-D7<=0 wait { c1'=0, c2'=-1, c3'=-1, c4'=0, c5'=0, c6'=0, c7'=0}
    when c2 = 0  do {} goto x3R4R5W6W7W;
    when c3 = 0  do {} goto x2R4R5W6W7W;
    when p7-D7=0 do {} goto error;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x2R3R4W5W6W7W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x2R3R4W5W6W7W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x2R3R4W5W6W7W;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x2R3R4W5W6W7W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x2R3R4W5W6W7W;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x2R3R4W5W6W7W;
    when c2>0 & c3>0&p1-T1>=0   do {p1'=0, c1'=C1} goto x1R2R3W4W5W6W7W;

loc x1R : while c1>=0 & p1-D1<=0 wait { c1'=-1, c2'=0, c3'=0, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto idle;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R ;
    when c1>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R;
    when c1>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x1R3R;
    when c1>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x1R4R;
    when c1>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x1R5R;
    when c1>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x1R6R;
    when c1>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x1R7R;

loc x1R7R : while c1>=0 & p1-D1<=0 & c7>=0 & p7-D7<=0 wait { c1'=-1, c2'=0, c3'=0, c4'=0, c5'=0, c6'=0, c7'=-1}
    when c1 = 0  do {} goto x7R;
    when c7 = 0  do {} goto x1R;
    when c7>0 & p7-D7=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R7R ;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x1R7R ;
    when c1>0 & c7>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R7W;
    when c1>0 & c7>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x1R3R7W;
    when c1>0 & c7>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x1R4R7W;
    when c1>0 & c7>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x1R5R7W;
    when c1>0 & c7>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x1R6R7W;

loc x1R6R : while c1>=0 & p1-D1<=0 & c6>=0 & p6-D6<=0 wait { c1'=-1, c2'=0, c3'=0, c4'=0, c5'=0, c6'=-1, c7'=0}
    when c1 = 0  do {} goto x6R;
    when c6 = 0  do {} goto x1R;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R6R ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R6R ;
    when c1>0 & c6>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R6W;
    when c1>0 & c6>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x1R3R6W;
    when c1>0 & c6>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x1R4R6W;
    when c1>0 & c6>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x1R5R6W;
    when c1>0 & c6>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x1R6R7W;

loc x1R6R7W : while c1>=0 & p1-D1<=0 & c6>=0 & p6-D6<=0 & p7-D7<=0 wait { c1'=-1, c2'=0, c3'=0, c4'=0, c5'=0, c6'=-1, c7'=0}
    when c1 = 0  do {} goto x6R7R;
    when c6 = 0  do {} goto x1R7R;
    when p7-D7=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R6R7W ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R6R7W ;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x1R6R7W;
    when c1>0 & c6>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R6W7W;
    when c1>0 & c6>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x1R3R6W7W;
    when c1>0 & c6>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x1R4R6W7W;
    when c1>0 & c6>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x1R5R6W7W;

loc x1R5R : while c1>=0 & p1-D1<=0 & c5>=0 & p5-D5<=0 wait { c1'=-1, c2'=0, c3'=0, c4'=0, c5'=-1, c6'=0, c7'=0}
    when c1 = 0  do {} goto x5R;
    when c5 = 0  do {} goto x1R;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R5R ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R5R ;
    when c1>0 & c5>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R5W;
    when c1>0 & c5>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x1R3R5W;
    when c1>0 & c5>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x1R4R5W;
    when c1>0 & c5>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x1R5R6W;
    when c1>0 & c5>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x1R5R7W;

loc x1R5R7W : while c1>=0 & p1-D1<=0 & c5>=0 & p5-D5<=0 & p7-D7<=0 wait { c1'=-1, c2'=0, c3'=0, c4'=0, c5'=-1, c6'=0, c7'=0}
    when c1 = 0  do {} goto x5R7R;
    when c5 = 0  do {} goto x1R7R;
    when p7-D7=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R5R7W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R5R7W ;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x1R5R7W;
    when c1>0 & c5>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R5W7W;
    when c1>0 & c5>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x1R3R5W7W;
    when c1>0 & c5>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x1R4R5W7W;
    when c1>0 & c5>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x1R5R6W7W;

loc x1R5R6W : while c1>=0 & p1-D1<=0 & c5>=0 & p5-D5<=0 & p6-D6<=0 wait { c1'=-1, c2'=0, c3'=0, c4'=0, c5'=-1, c6'=0, c7'=0}
    when c1 = 0  do {} goto x5R6R;
    when c5 = 0  do {} goto x1R6R;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R5R6W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R5R6W ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R5R6W;
    when c1>0 & c5>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R5W6W;
    when c1>0 & c5>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x1R3R5W6W;
    when c1>0 & c5>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x1R4R5W6W;
    when c1>0 & c5>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x1R5R6W7W;

loc x1R5R6W7W : while c1>=0 & p1-D1<=0 & c5>=0 & p5-D5<=0 & p6-D6<=0 & p7-D7<=0 wait { c1'=-1, c2'=0, c3'=0, c4'=0, c5'=-1, c6'=0, c7'=0}
    when c1 = 0  do {} goto x5R6R7W;
    when c5 = 0  do {} goto x1R6R7W;
    when p7-D7=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R5R6W7W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R5R6W7W ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R5R6W7W;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x1R5R6W7W;
    when c1>0 & c5>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R5W6W7W;
    when c1>0 & c5>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x1R3R5W6W7W;
    when c1>0 & c5>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x1R4R5W6W7W;

loc x1R4R : while c1>=0 & p1-D1<=0 & c4>=0 & p4-D4<=0 wait { c1'=-1, c2'=0, c3'=0, c4'=-1, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x4R;
    when c4 = 0  do {} goto x1R;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R4R ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R4R ;
    when c1>0 & c4>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R4W;
    when c1>0 & c4>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x1R3R4W;
    when c1>0 & c4>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x1R4R5W;
    when c1>0 & c4>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x1R4R6W;
    when c1>0 & c4>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x1R4R7W;

loc x1R4R7W : while c1>=0 & p1-D1<=0 & c4>=0 & p4-D4<=0 & p7-D7<=0 wait { c1'=-1, c2'=0, c3'=0, c4'=-1, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x4R7R;
    when c4 = 0  do {} goto x1R7R;
    when p7-D7=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R4R7W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R4R7W ;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x1R4R7W;
    when c1>0 & c4>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R4W7W;
    when c1>0 & c4>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x1R3R4W7W;
    when c1>0 & c4>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x1R4R5W7W;
    when c1>0 & c4>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x1R4R6W7W;

loc x1R4R6W : while c1>=0 & p1-D1<=0 & c4>=0 & p4-D4<=0 & p6-D6<=0 wait { c1'=-1, c2'=0, c3'=0, c4'=-1, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x4R6R;
    when c4 = 0  do {} goto x1R6R;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R4R6W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R4R6W ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R4R6W;
    when c1>0 & c4>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R4W6W;
    when c1>0 & c4>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x1R3R4W6W;
    when c1>0 & c4>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x1R4R5W6W;
    when c1>0 & c4>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x1R4R6W7W;

loc x1R4R6W7W : while c1>=0 & p1-D1<=0 & c4>=0 & p4-D4<=0 & p6-D6<=0 & p7-D7<=0 wait { c1'=-1, c2'=0, c3'=0, c4'=-1, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x4R6R7W;
    when c4 = 0  do {} goto x1R6R7W;
    when p7-D7=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R4R6W7W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R4R6W7W ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R4R6W7W;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x1R4R6W7W;
    when c1>0 & c4>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R4W6W7W;
    when c1>0 & c4>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x1R3R4W6W7W;
    when c1>0 & c4>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x1R4R5W6W7W;

loc x1R4R5W : while c1>=0 & p1-D1<=0 & c4>=0 & p4-D4<=0 & p5-D5<=0 wait { c1'=-1, c2'=0, c3'=0, c4'=-1, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x4R5R;
    when c4 = 0  do {} goto x1R5R;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R4R5W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R4R5W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R4R5W;
    when c1>0 & c4>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R4W5W;
    when c1>0 & c4>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x1R3R4W5W;
    when c1>0 & c4>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x1R4R5W6W;
    when c1>0 & c4>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x1R4R5W7W;

loc x1R4R5W7W : while c1>=0 & p1-D1<=0 & c4>=0 & p4-D4<=0 & p5-D5<=0 & p7-D7<=0 wait { c1'=-1, c2'=0, c3'=0, c4'=-1, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x4R5R7W;
    when c4 = 0  do {} goto x1R5R7W;
    when p7-D7=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R4R5W7W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R4R5W7W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R4R5W7W;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x1R4R5W7W;
    when c1>0 & c4>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R4W5W7W;
    when c1>0 & c4>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x1R3R4W5W7W;
    when c1>0 & c4>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x1R4R5W6W7W;

loc x1R4R5W6W : while c1>=0 & p1-D1<=0 & c4>=0 & p4-D4<=0 & p5-D5<=0 & p6-D6<=0 wait { c1'=-1, c2'=0, c3'=0, c4'=-1, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x4R5R6W;
    when c4 = 0  do {} goto x1R5R6W;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R4R5W6W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R4R5W6W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R4R5W6W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R4R5W6W;
    when c1>0 & c4>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R4W5W6W;
    when c1>0 & c4>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x1R3R4W5W6W;
    when c1>0 & c4>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x1R4R5W6W7W;

loc x1R4R5W6W7W : while c1>=0 & p1-D1<=0 & c4>=0 & p4-D4<=0 & p5-D5<=0 & p6-D6<=0 & p7-D7<=0 wait { c1'=-1, c2'=0, c3'=0, c4'=-1, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x4R5R6W7W;
    when c4 = 0  do {} goto x1R5R6W7W;
    when p7-D7=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R4R5W6W7W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R4R5W6W7W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R4R5W6W7W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R4R5W6W7W;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x1R4R5W6W7W;
    when c1>0 & c4>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R4W5W6W7W;
    when c1>0 & c4>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x1R3R4W5W6W7W;

loc x1R3R : while c1>=0 & p1-D1<=0 & c3>=0 & p3-D3<=0 wait { c1'=-1, c2'=0, c3'=-1, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x3R;
    when c3 = 0  do {} goto x1R;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R3R ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R3R ;
    when c1>0 & c3>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R3W;
    when c1>0 & c3>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x1R3R4W;
    when c1>0 & c3>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x1R3R5W;
    when c1>0 & c3>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x1R3R6W;
    when c1>0 & c3>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x1R3R7W;

loc x1R3R7W : while c1>=0 & p1-D1<=0 & c3>=0 & p3-D3<=0 & p7-D7<=0 wait { c1'=-1, c2'=0, c3'=-1, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x3R7R;
    when c3 = 0  do {} goto x1R7R;
    when p7-D7=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R3R7W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R3R7W ;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x1R3R7W;
    when c1>0 & c3>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R3W7W;
    when c1>0 & c3>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x1R3R4W7W;
    when c1>0 & c3>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x1R3R5W7W;
    when c1>0 & c3>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x1R3R6W7W;

loc x1R3R6W : while c1>=0 & p1-D1<=0 & c3>=0 & p3-D3<=0 & p6-D6<=0 wait { c1'=-1, c2'=0, c3'=-1, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x3R6R;
    when c3 = 0  do {} goto x1R6R;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R3R6W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R3R6W ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R3R6W;
    when c1>0 & c3>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R3W6W;
    when c1>0 & c3>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x1R3R4W6W;
    when c1>0 & c3>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x1R3R5W6W;
    when c1>0 & c3>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x1R3R6W7W;

loc x1R3R6W7W : while c1>=0 & p1-D1<=0 & c3>=0 & p3-D3<=0 & p6-D6<=0 & p7-D7<=0 wait { c1'=-1, c2'=0, c3'=-1, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x3R6R7W;
    when c3 = 0  do {} goto x1R6R7W;
    when p7-D7=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R3R6W7W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R3R6W7W ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R3R6W7W;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x1R3R6W7W;
    when c1>0 & c3>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R3W6W7W;
    when c1>0 & c3>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x1R3R4W6W7W;
    when c1>0 & c3>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x1R3R5W6W7W;

loc x1R3R5W : while c1>=0 & p1-D1<=0 & c3>=0 & p3-D3<=0 & p5-D5<=0 wait { c1'=-1, c2'=0, c3'=-1, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x3R5R;
    when c3 = 0  do {} goto x1R5R;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R3R5W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R3R5W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R3R5W;
    when c1>0 & c3>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R3W5W;
    when c1>0 & c3>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x1R3R4W5W;
    when c1>0 & c3>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x1R3R5W6W;
    when c1>0 & c3>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x1R3R5W7W;

loc x1R3R5W7W : while c1>=0 & p1-D1<=0 & c3>=0 & p3-D3<=0 & p5-D5<=0 & p7-D7<=0 wait { c1'=-1, c2'=0, c3'=-1, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x3R5R7W;
    when c3 = 0  do {} goto x1R5R7W;
    when p7-D7=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R3R5W7W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R3R5W7W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R3R5W7W;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x1R3R5W7W;
    when c1>0 & c3>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R3W5W7W;
    when c1>0 & c3>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x1R3R4W5W7W;
    when c1>0 & c3>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x1R3R5W6W7W;

loc x1R3R5W6W : while c1>=0 & p1-D1<=0 & c3>=0 & p3-D3<=0 & p5-D5<=0 & p6-D6<=0 wait { c1'=-1, c2'=0, c3'=-1, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x3R5R6W;
    when c3 = 0  do {} goto x1R5R6W;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R3R5W6W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R3R5W6W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R3R5W6W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R3R5W6W;
    when c1>0 & c3>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R3W5W6W;
    when c1>0 & c3>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x1R3R4W5W6W;
    when c1>0 & c3>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x1R3R5W6W7W;

loc x1R3R5W6W7W : while c1>=0 & p1-D1<=0 & c3>=0 & p3-D3<=0 & p5-D5<=0 & p6-D6<=0 & p7-D7<=0 wait { c1'=-1, c2'=0, c3'=-1, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x3R5R6W7W;
    when c3 = 0  do {} goto x1R5R6W7W;
    when p7-D7=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R3R5W6W7W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R3R5W6W7W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R3R5W6W7W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R3R5W6W7W;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x1R3R5W6W7W;
    when c1>0 & c3>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R3W5W6W7W;
    when c1>0 & c3>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x1R3R4W5W6W7W;

loc x1R3R4W : while c1>=0 & p1-D1<=0 & c3>=0 & p3-D3<=0 & p4-D4<=0 wait { c1'=-1, c2'=0, c3'=-1, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x3R4R;
    when c3 = 0  do {} goto x1R4R;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R3R4W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R3R4W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R3R4W;
    when c1>0 & c3>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R3W4W;
    when c1>0 & c3>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x1R3R4W5W;
    when c1>0 & c3>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x1R3R4W6W;
    when c1>0 & c3>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x1R3R4W7W;

loc x1R3R4W7W : while c1>=0 & p1-D1<=0 & c3>=0 & p3-D3<=0 & p4-D4<=0 & p7-D7<=0 wait { c1'=-1, c2'=0, c3'=-1, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x3R4R7W;
    when c3 = 0  do {} goto x1R4R7W;
    when p7-D7=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R3R4W7W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R3R4W7W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R3R4W7W;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x1R3R4W7W;
    when c1>0 & c3>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R3W4W7W;
    when c1>0 & c3>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x1R3R4W5W7W;
    when c1>0 & c3>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x1R3R4W6W7W;

loc x1R3R4W6W : while c1>=0 & p1-D1<=0 & c3>=0 & p3-D3<=0 & p4-D4<=0 & p6-D6<=0 wait { c1'=-1, c2'=0, c3'=-1, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x3R4R6W;
    when c3 = 0  do {} goto x1R4R6W;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R3R4W6W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R3R4W6W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R3R4W6W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R3R4W6W;
    when c1>0 & c3>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R3W4W6W;
    when c1>0 & c3>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x1R3R4W5W6W;
    when c1>0 & c3>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x1R3R4W6W7W;

loc x1R3R4W6W7W : while c1>=0 & p1-D1<=0 & c3>=0 & p3-D3<=0 & p4-D4<=0 & p6-D6<=0 & p7-D7<=0 wait { c1'=-1, c2'=0, c3'=-1, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x3R4R6W7W;
    when c3 = 0  do {} goto x1R4R6W7W;
    when p7-D7=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R3R4W6W7W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R3R4W6W7W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R3R4W6W7W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R3R4W6W7W;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x1R3R4W6W7W;
    when c1>0 & c3>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R3W4W6W7W;
    when c1>0 & c3>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x1R3R4W5W6W7W;

loc x1R3R4W5W : while c1>=0 & p1-D1<=0 & c3>=0 & p3-D3<=0 & p4-D4<=0 & p5-D5<=0 wait { c1'=-1, c2'=0, c3'=-1, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x3R4R5W;
    when c3 = 0  do {} goto x1R4R5W;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R3R4W5W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R3R4W5W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R3R4W5W;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R3R4W5W;
    when c1>0 & c3>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R3W4W5W;
    when c1>0 & c3>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x1R3R4W5W6W;
    when c1>0 & c3>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x1R3R4W5W7W;

loc x1R3R4W5W7W : while c1>=0 & p1-D1<=0 & c3>=0 & p3-D3<=0 & p4-D4<=0 & p5-D5<=0 & p7-D7<=0 wait { c1'=-1, c2'=0, c3'=-1, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x3R4R5W7W;
    when c3 = 0  do {} goto x1R4R5W7W;
    when p7-D7=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R3R4W5W7W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R3R4W5W7W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R3R4W5W7W;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R3R4W5W7W;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x1R3R4W5W7W;
    when c1>0 & c3>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R3W4W5W7W;
    when c1>0 & c3>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x1R3R4W5W6W7W;

loc x1R3R4W5W6W : while c1>=0 & p1-D1<=0 & c3>=0 & p3-D3<=0 & p4-D4<=0 & p5-D5<=0 & p6-D6<=0 wait { c1'=-1, c2'=0, c3'=-1, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x3R4R5W6W;
    when c3 = 0  do {} goto x1R4R5W6W;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R3R4W5W6W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R3R4W5W6W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R3R4W5W6W;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R3R4W5W6W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R3R4W5W6W;
    when c1>0 & c3>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R3W4W5W6W;
    when c1>0 & c3>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x1R3R4W5W6W7W;

loc x1R3R4W5W6W7W : while c1>=0 & p1-D1<=0 & c3>=0 & p3-D3<=0 & p4-D4<=0 & p5-D5<=0 & p6-D6<=0 & p7-D7<=0 wait { c1'=-1, c2'=0, c3'=-1, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x3R4R5W6W7W;
    when c3 = 0  do {} goto x1R4R5W6W7W;
    when p7-D7=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R3R4W5W6W7W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R3R4W5W6W7W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R3R4W5W6W7W;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R3R4W5W6W7W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R3R4W5W6W7W;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x1R3R4W5W6W7W;
    when c1>0 & c3>0&p2-T2>=0   do {p2'=0, c2'=C2} goto x1R2R3W4W5W6W7W;

loc x1R2R : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x2R;
    when c2 = 0  do {} goto x1R;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R ;
    when c1>0 & c2>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x1R2R3W;
    when c1>0 & c2>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x1R2R4W;
    when c1>0 & c2>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x1R2R5W;
    when c1>0 & c2>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x1R2R6W;
    when c1>0 & c2>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x1R2R7W;

loc x1R2R7W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p7-D7<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x2R7R;
    when c2 = 0  do {} goto x1R7R;
    when p7-D7=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R7W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R7W ;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x1R2R7W;
    when c1>0 & c2>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x1R2R3W7W;
    when c1>0 & c2>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x1R2R4W7W;
    when c1>0 & c2>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x1R2R5W7W;
    when c1>0 & c2>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x1R2R6W7W;

loc x1R2R6W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p6-D6<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x2R6R;
    when c2 = 0  do {} goto x1R6R;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R6W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R6W ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R2R6W;
    when c1>0 & c2>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x1R2R3W6W;
    when c1>0 & c2>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x1R2R4W6W;
    when c1>0 & c2>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x1R2R5W6W;
    when c1>0 & c2>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x1R2R6W7W;

loc x1R2R6W7W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p6-D6<=0 & p7-D7<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x2R6R7W;
    when c2 = 0  do {} goto x1R6R7W;
    when p7-D7=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R6W7W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R6W7W ;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R2R6W7W;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x1R2R6W7W;
    when c1>0 & c2>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x1R2R3W6W7W;
    when c1>0 & c2>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x1R2R4W6W7W;
    when c1>0 & c2>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x1R2R5W6W7W;

loc x1R2R5W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p5-D5<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x2R5R;
    when c2 = 0  do {} goto x1R5R;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R5W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R5W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R2R5W;
    when c1>0 & c2>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x1R2R3W5W;
    when c1>0 & c2>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x1R2R4W5W;
    when c1>0 & c2>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x1R2R5W6W;
    when c1>0 & c2>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x1R2R5W7W;

loc x1R2R5W7W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p5-D5<=0 & p7-D7<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x2R5R7W;
    when c2 = 0  do {} goto x1R5R7W;
    when p7-D7=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R5W7W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R5W7W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R2R5W7W;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x1R2R5W7W;
    when c1>0 & c2>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x1R2R3W5W7W;
    when c1>0 & c2>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x1R2R4W5W7W;
    when c1>0 & c2>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x1R2R5W6W7W;

loc x1R2R5W6W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p5-D5<=0 & p6-D6<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x2R5R6W;
    when c2 = 0  do {} goto x1R5R6W;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R5W6W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R5W6W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R2R5W6W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R2R5W6W;
    when c1>0 & c2>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x1R2R3W5W6W;
    when c1>0 & c2>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x1R2R4W5W6W;
    when c1>0 & c2>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x1R2R5W6W7W;

loc x1R2R5W6W7W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p5-D5<=0 & p6-D6<=0 & p7-D7<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x2R5R6W7W;
    when c2 = 0  do {} goto x1R5R6W7W;
    when p7-D7=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R5W6W7W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R5W6W7W ;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R2R5W6W7W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R2R5W6W7W;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x1R2R5W6W7W;
    when c1>0 & c2>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x1R2R3W5W6W7W;
    when c1>0 & c2>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x1R2R4W5W6W7W;

loc x1R2R4W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p4-D4<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x2R4R;
    when c2 = 0  do {} goto x1R4R;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R4W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R4W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R2R4W;
    when c1>0 & c2>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x1R2R3W4W;
    when c1>0 & c2>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x1R2R4W5W;
    when c1>0 & c2>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x1R2R4W6W;
    when c1>0 & c2>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x1R2R4W7W;

loc x1R2R4W7W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p4-D4<=0 & p7-D7<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x2R4R7W;
    when c2 = 0  do {} goto x1R4R7W;
    when p7-D7=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R4W7W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R4W7W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R2R4W7W;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x1R2R4W7W;
    when c1>0 & c2>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x1R2R3W4W7W;
    when c1>0 & c2>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x1R2R4W5W7W;
    when c1>0 & c2>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x1R2R4W6W7W;

loc x1R2R4W6W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p4-D4<=0 & p6-D6<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x2R4R6W;
    when c2 = 0  do {} goto x1R4R6W;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R4W6W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R4W6W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R2R4W6W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R2R4W6W;
    when c1>0 & c2>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x1R2R3W4W6W;
    when c1>0 & c2>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x1R2R4W5W6W;
    when c1>0 & c2>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x1R2R4W6W7W;

loc x1R2R4W6W7W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p4-D4<=0 & p6-D6<=0 & p7-D7<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x2R4R6W7W;
    when c2 = 0  do {} goto x1R4R6W7W;
    when p7-D7=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R4W6W7W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R4W6W7W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R2R4W6W7W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R2R4W6W7W;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x1R2R4W6W7W;
    when c1>0 & c2>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x1R2R3W4W6W7W;
    when c1>0 & c2>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x1R2R4W5W6W7W;

loc x1R2R4W5W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p4-D4<=0 & p5-D5<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x2R4R5W;
    when c2 = 0  do {} goto x1R4R5W;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R4W5W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R4W5W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R2R4W5W;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R2R4W5W;
    when c1>0 & c2>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x1R2R3W4W5W;
    when c1>0 & c2>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x1R2R4W5W6W;
    when c1>0 & c2>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x1R2R4W5W7W;

loc x1R2R4W5W7W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p4-D4<=0 & p5-D5<=0 & p7-D7<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x2R4R5W7W;
    when c2 = 0  do {} goto x1R4R5W7W;
    when p7-D7=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R4W5W7W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R4W5W7W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R2R4W5W7W;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R2R4W5W7W;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x1R2R4W5W7W;
    when c1>0 & c2>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x1R2R3W4W5W7W;
    when c1>0 & c2>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x1R2R4W5W6W7W;

loc x1R2R4W5W6W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p4-D4<=0 & p5-D5<=0 & p6-D6<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x2R4R5W6W;
    when c2 = 0  do {} goto x1R4R5W6W;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R4W5W6W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R4W5W6W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R2R4W5W6W;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R2R4W5W6W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R2R4W5W6W;
    when c1>0 & c2>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x1R2R3W4W5W6W;
    when c1>0 & c2>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x1R2R4W5W6W7W;

loc x1R2R4W5W6W7W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p4-D4<=0 & p5-D5<=0 & p6-D6<=0 & p7-D7<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x2R4R5W6W7W;
    when c2 = 0  do {} goto x1R4R5W6W7W;
    when p7-D7=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R4W5W6W7W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R4W5W6W7W ;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R2R4W5W6W7W;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R2R4W5W6W7W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R2R4W5W6W7W;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x1R2R4W5W6W7W;
    when c1>0 & c2>0&p3-T3>=0   do {p3'=0, c3'=C3} goto x1R2R3W4W5W6W7W;

loc x1R2R3W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p3-D3<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x2R3R;
    when c2 = 0  do {} goto x1R3R;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R3W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R3W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R2R3W;
    when c1>0 & c2>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x1R2R3W4W;
    when c1>0 & c2>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x1R2R3W5W;
    when c1>0 & c2>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x1R2R3W6W;
    when c1>0 & c2>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x1R2R3W7W;

loc x1R2R3W7W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p3-D3<=0 & p7-D7<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x2R3R7W;
    when c2 = 0  do {} goto x1R3R7W;
    when p7-D7=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R3W7W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R3W7W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R2R3W7W;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x1R2R3W7W;
    when c1>0 & c2>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x1R2R3W4W7W;
    when c1>0 & c2>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x1R2R3W5W7W;
    when c1>0 & c2>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x1R2R3W6W7W;

loc x1R2R3W6W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p3-D3<=0 & p6-D6<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x2R3R6W;
    when c2 = 0  do {} goto x1R3R6W;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R3W6W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R3W6W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R2R3W6W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R2R3W6W;
    when c1>0 & c2>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x1R2R3W4W6W;
    when c1>0 & c2>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x1R2R3W5W6W;
    when c1>0 & c2>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x1R2R3W6W7W;

loc x1R2R3W6W7W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p3-D3<=0 & p6-D6<=0 & p7-D7<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x2R3R6W7W;
    when c2 = 0  do {} goto x1R3R6W7W;
    when p7-D7=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R3W6W7W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R3W6W7W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R2R3W6W7W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R2R3W6W7W;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x1R2R3W6W7W;
    when c1>0 & c2>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x1R2R3W4W6W7W;
    when c1>0 & c2>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x1R2R3W5W6W7W;

loc x1R2R3W5W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p3-D3<=0 & p5-D5<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x2R3R5W;
    when c2 = 0  do {} goto x1R3R5W;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R3W5W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R3W5W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R2R3W5W;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R2R3W5W;
    when c1>0 & c2>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x1R2R3W4W5W;
    when c1>0 & c2>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x1R2R3W5W6W;
    when c1>0 & c2>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x1R2R3W5W7W;

loc x1R2R3W5W7W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p3-D3<=0 & p5-D5<=0 & p7-D7<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x2R3R5W7W;
    when c2 = 0  do {} goto x1R3R5W7W;
    when p7-D7=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R3W5W7W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R3W5W7W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R2R3W5W7W;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R2R3W5W7W;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x1R2R3W5W7W;
    when c1>0 & c2>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x1R2R3W4W5W7W;
    when c1>0 & c2>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x1R2R3W5W6W7W;

loc x1R2R3W5W6W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p3-D3<=0 & p5-D5<=0 & p6-D6<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x2R3R5W6W;
    when c2 = 0  do {} goto x1R3R5W6W;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R3W5W6W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R3W5W6W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R2R3W5W6W;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R2R3W5W6W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R2R3W5W6W;
    when c1>0 & c2>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x1R2R3W4W5W6W;
    when c1>0 & c2>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x1R2R3W5W6W7W;

loc x1R2R3W5W6W7W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p3-D3<=0 & p5-D5<=0 & p6-D6<=0 & p7-D7<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x2R3R5W6W7W;
    when c2 = 0  do {} goto x1R3R5W6W7W;
    when p7-D7=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R3W5W6W7W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R3W5W6W7W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R2R3W5W6W7W;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R2R3W5W6W7W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R2R3W5W6W7W;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x1R2R3W5W6W7W;
    when c1>0 & c2>0&p4-T4>=0   do {p4'=0, c4'=C4} goto x1R2R3W4W5W6W7W;

loc x1R2R3W4W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p3-D3<=0 & p4-D4<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x2R3R4W;
    when c2 = 0  do {} goto x1R3R4W;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R3W4W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R3W4W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R2R3W4W;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R2R3W4W;
    when c1>0 & c2>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x1R2R3W4W5W;
    when c1>0 & c2>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x1R2R3W4W6W;
    when c1>0 & c2>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x1R2R3W4W7W;

loc x1R2R3W4W7W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p3-D3<=0 & p4-D4<=0 & p7-D7<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x2R3R4W7W;
    when c2 = 0  do {} goto x1R3R4W7W;
    when p7-D7=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R3W4W7W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R3W4W7W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R2R3W4W7W;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R2R3W4W7W;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x1R2R3W4W7W;
    when c1>0 & c2>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x1R2R3W4W5W7W;
    when c1>0 & c2>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x1R2R3W4W6W7W;

loc x1R2R3W4W6W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p3-D3<=0 & p4-D4<=0 & p6-D6<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x2R3R4W6W;
    when c2 = 0  do {} goto x1R3R4W6W;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R3W4W6W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R3W4W6W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R2R3W4W6W;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R2R3W4W6W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R2R3W4W6W;
    when c1>0 & c2>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x1R2R3W4W5W6W;
    when c1>0 & c2>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x1R2R3W4W6W7W;

loc x1R2R3W4W6W7W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p3-D3<=0 & p4-D4<=0 & p6-D6<=0 & p7-D7<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x2R3R4W6W7W;
    when c2 = 0  do {} goto x1R3R4W6W7W;
    when p7-D7=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R3W4W6W7W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R3W4W6W7W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R2R3W4W6W7W;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R2R3W4W6W7W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R2R3W4W6W7W;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x1R2R3W4W6W7W;
    when c1>0 & c2>0&p5-T5>=0   do {p5'=0, c5'=C5} goto x1R2R3W4W5W6W7W;

loc x1R2R3W4W5W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p3-D3<=0 & p4-D4<=0 & p5-D5<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x2R3R4W5W;
    when c2 = 0  do {} goto x1R3R4W5W;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R3W4W5W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R3W4W5W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R2R3W4W5W;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R2R3W4W5W;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R2R3W4W5W;
    when c1>0 & c2>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x1R2R3W4W5W6W;
    when c1>0 & c2>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x1R2R3W4W5W7W;

loc x1R2R3W4W5W7W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p3-D3<=0 & p4-D4<=0 & p5-D5<=0 & p7-D7<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x2R3R4W5W7W;
    when c2 = 0  do {} goto x1R3R4W5W7W;
    when p7-D7=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R3W4W5W7W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R3W4W5W7W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R2R3W4W5W7W;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R2R3W4W5W7W;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R2R3W4W5W7W;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x1R2R3W4W5W7W;
    when c1>0 & c2>0&p6-T6>=0   do {p6'=0, c6'=C6} goto x1R2R3W4W5W6W7W;

loc x1R2R3W4W5W6W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p3-D3<=0 & p4-D4<=0 & p5-D5<=0 & p6-D6<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x2R3R4W5W6W;
    when c2 = 0  do {} goto x1R3R4W5W6W;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R3W4W5W6W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R3W4W5W6W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R2R3W4W5W6W;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R2R3W4W5W6W;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R2R3W4W5W6W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R2R3W4W5W6W;
    when c1>0 & c2>0&p7-T7>=0   do {p7'=0, c7'=C7} goto x1R2R3W4W5W6W7W;

loc x1R2R3W4W5W6W7W : while c1>=0 & p1-D1<=0 & c2>=0 & p2-D2<=0 & p3-D3<=0 & p4-D4<=0 & p5-D5<=0 & p6-D6<=0 & p7-D7<=0 wait { c1'=-1, c2'=-1, c3'=0, c4'=0, c5'=0, c6'=0, c7'=0}
    when c1 = 0  do {} goto x2R3R4W5W6W7W;
    when c2 = 0  do {} goto x1R3R4W5W6W7W;
    when p7-D7=0 do {} goto error;
    when p1-T1>=0  do {p1'=0, c1'=c1+C1}  goto x1R2R3W4W5W6W7W ;
    when p2-T2>=0  do {p2'=0, c2'=c2+C2}  goto x1R2R3W4W5W6W7W ;
    when p3-T3>=0  do {p3'=0, c3'=c3+C3}  goto x1R2R3W4W5W6W7W;
    when p4-T4>=0  do {p4'=0, c4'=c4+C4}  goto x1R2R3W4W5W6W7W;
    when p5-T5>=0  do {p5'=0, c5'=c5+C5}  goto x1R2R3W4W5W6W7W;
    when p6-T6>=0  do {p6'=0, c6'=c6+C6}  goto x1R2R3W4W5W6W7W;
    when p7-T7>=0  do {p7'=0, c7'=c7+C7}  goto x1R2R3W4W5W6W7W;

loc error: while True wait {}

end

init := 
    loc[sched] = idle & 
    p1>=0 & c1=0 &
    p2>=0 & c2=0 &
    p3>=0 & c3=0 &
    p4>=0 & c4=0 &
    p5>=0 & c5=0 &
    p6>=0 & c6=0 &
    p7>=0 & c7=0;
bad := loc[sched]=error;
