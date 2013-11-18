
#
#     Number of tasks     : 3
#     Number of processor : 1
#     Scheduler           : FPFP
#

    p1, c1, p2, c2, p3, c3 : var;
    T1=8, D1=8, C1=2, T2=20, D2=20, C2=5, T3=50, D3=50, C3=20 : parameter;

automaton sched

loc idle: while True wait {c1'=0, c2'=0, c3'=0}
  when p1-T1>=0   do {p1'=0, c1'=C1}   goto x1r;
  when p2-T2>=0   do {p2'=0, c2'=C2}   goto x2r;
  when p3-T3>=0   do {p3'=0, c3'=C3}   goto x3r;

loc x1r: while c1>=0&p1-D1<=0  wait {c1'=-1, c2'=0, c3'=0}
  when p1-T1>=0                        do {p1'=0, c1'=c1+C1}   goto x1r;
  when p2-T2>=0&c1>0                   do {p2'=0, c2'=C2}      goto x1r2w;
  when p3-T3>=0&c1>0                   do {p3'=0, c3'=C3}      goto x1r3w;
  when c1=0                            do {}                   goto idle;
  when p1-D1=0&c1>0                    do {}                   goto error;


loc x2r: while c2>=0&p2-D2<=0 wait {c1'=0, c2'=-1, c3'=0}
  when p2-T2>=0                      do {p2'=0, c2'=c2+C2}   goto x2r;
  when p1-T1>=0&c2>0                 do {p1'=0, c1'=C1}      goto x1r2w;
  when p3-T3>=0&c2>0                 do {p3'=0, c3'=C3}      goto x2r3w;
  when c2=0                          do {}                   goto idle;
  when p2-D2=0&c2>0                  do {}                   goto error;

loc x3r: while c3>=0&p3-D3<=0 wait {c1'=0, c2'=0, c3'=-1}
  when p3-T3>=0                 do {p3'=0, c3'=c3+C3}   goto x3r;
  when p1-T1>=0&c3>0            do {p1'=0, c1'=C1}      goto x1r3w;
  when p2-T2>=0&c3>0            do {p2'=0, c2'=C2}      goto x2r3w;
  when c3=0                     do {}                   goto idle;
  when p3-D3=0&c3>0             do {}                   goto error;


loc x1r2w: while c1>=0&p1-D1<=0&p2-D2<=0 wait {c1'=-1, c2'=0, c3'=0}
  when p1-T1>=0                 do {p1'=0, c1'=c1+C1}      goto x1r2w;
  when p2-T2>=0                 do {p2'=0, c2'=c2+C2}      goto x1r2w;
  when p3-T3>=0&c1>0&c2>0       do {p3'=0, c3'=C3}         goto x1r2w3w;
  when c1=0                     do {}                      goto x2r;
  when p1-D1=0&c1>0             do {}                      goto error;
  when p2-D2=0                  do {}                      goto error;

loc x1r3w: while c1>=0&p1-D1<=0&p3-D3<=0 wait {c1'=-1, c2'=0, c3'=0}
  when p1-T1>=0                 do {p1'=0, c1'=c1+C1}      goto x1r3w;
  when p3-T3>=0                 do {p3'=0, c3'=c3+C3}      goto x1r3w;
  when p2-T2>=0&c1>0&c3>0       do {p2'=0, c2'=C2}         goto x1r2w3w;
  when c1=0                     do {}                      goto x3r;
  when p1-D1=0&c1>0             do {}                      goto error;
  when p3-D3=0                  do {}                      goto error;

loc x2r3w: while c2>=0&p2-D2<=0&p3-D3<=0 wait {c1'=0, c2'=-1, c3'=0}
  when p2-T2>=0                 do {p2'=0, c2'=c2+C2}      goto x2r3w;
  when p3-T3>=0                 do {p3'=0, c3'=c3+C3}      goto x2r3w;
  when p1-T1>=0&c2>0&c3>0       do {p1'=0, c1'=C1}         goto x1r2w3w;
  when c2=0                     do {}                      goto x3r;
  when p2-D2=0&c2>0             do {}                      goto error;
  when p3-D3=0                  do {}                      goto error;

loc x1r2w3w: while c1>=0&p1-D1<=0&p2-D2<=0&p3-D3<=0   wait {c1'=-1, c2'=0, c3'=0}
  when p1-T1>=0            do {p1'=0, c1'=c1+C1}      goto x1r2w3w;
  when p2-T2>=0            do {p2'=0, c2'=c2+C2}      goto x1r2w3w;
  when p3-T3>=0            do {p3'=0, c3'=c3+C3}      goto x1r2w3w;
  when c1=0                do {}                      goto x2r3w;
  when p1-D1=0&c1>0        do {}                      goto error;
  when p2-D2=0             do {}                      goto error;
  when p3-D3=0             do {}                      goto error;
  

loc error: while True wait {} 


end


init := loc[sched]=idle &
        p1=0 &
        c1=0 &
        p2=0 &
        c2=0 &
        p3=0 &
        c3=0 
        #C1>=8 &
        #C1<=10
        ;
bad := loc[sched]=error;
