

#		This is IMITATOR's test case from
#			http://www.lsv.ens-cachan.fr/Software/imitator/case-studies.php
#
#	 	to run the test : ../../binary/xtool --imcr -f fp2.mod

	t_2, t_3, t_1, x_1, x_2, x_3, time : var;	# variables

	per2, off2, per3, off3, per1, off1, WCET_1, WCET_2, WCET_3, deadlineBasic: parameter; # parameters

	WCET_1 = 1, WCET_2 = 1, WCET_3 = 2, per1 = 3, per2 = 5, per3 = 10, Off1 = 0, 
	Off2 = 0, Off3 = 0, deadlineBasic = 30 : im_parameter;	# the input parameter valuation (pi0)


automaton stopper

synclabs: done1, require2, done2;

loc f_1_r: while time - deadlineBasic <= 0 wait {}	
	when True sync done1 do {} goto f_2_r;
	when True sync require2 do {}goto f_1_r;
	when True sync done2 do {}goto f_1_r;

loc f_2_r: while time - deadlineBasic <= 0 wait {}	
	when True sync done1 do {} goto f_3_r;
	when True sync require2 do {} goto f_2_r;
	when True sync done2 do {} goto f_2_r;

loc f_3_r: while time - deadlineBasic <= 0 wait {}	
	when True sync done1 do {} goto f_4_r;
	when True sync require2 do {} goto f_3_r;
	when True sync done2 do {} goto f_3_r;

loc f_4_r: while time - deadlineBasic <= 0 wait {}	
	when True sync done1 do {} goto f_5_r;
	when True sync require2 do {} goto f_4_r;
	when True sync done2 do {} goto f_4_r;

loc f_5_r: while time - deadlineBasic <= 0 wait {}	
	when True sync done1 do {} goto f_6_r;
	when True sync require2 do {} goto f_5_r;
	when True sync done2 do {} goto f_5_r;

loc f_6_r: while time -  deadlineBasic <= 0 wait {}	
	when True sync done1 do {} goto f_7_r; 
	when True sync require2 do {} goto f_6_r;
	when True sync done2 do {} goto f_6_r;

loc f_7_r: while time - deadlineBasic <= 0 wait {}	
	when True sync done1 do {} goto f_8_r;
	when True sync require2 do {} goto f_7_r;
	when True sync done2 do {} goto f_7_r;

loc f_8_r: while time - deadlineBasic <= 0 wait {}	
	when True sync done1 do {} goto f_9_r;
	when True sync require2 do {} goto f_8_r;
	when True sync done2 do {} goto f_8_r;

loc f_9_r: while time - deadlineBasic <= 0 wait {}	
	when True sync done1 do {} goto f_10_r;
	when True sync require2 do {} goto f_9_r;
	when True sync done2 do {} goto f_9_r;

loc f_10_r: while time -  deadlineBasic <= 0 wait {}	
	when True sync done1 do {} goto f_10;
	when True sync require2 do {} goto f_10_r;
	when True sync done2 do {} goto f_10_r;

loc f_10: while time - deadlineBasic <= 0 wait {}
	when True sync require2 do {} goto g_r;

loc g_r: while time - deadlineBasic <= 0 wait {}
	when True sync done2 do {} goto lf_r;
	when True sync done1 do {} goto g_r;

loc lf_r: while time - deadlineBasic <= 0 wait {}
	when True sync done1 do {} goto end_flow;

loc end_flow: while time - deadlineBasic <= 0 wait {}

end

automaton scheduler_P_Application

synclabs: require1, done1, require2, done2, require3, done3;

loc active_non_1_non_2_non_3: while True wait{x_1'=0,x_2'=0,x_3'=0}
	when True sync require1  do {} goto active_1_non_2_non_3;
	when True sync require2 do {} goto active_non_1_2_non_3;	
	when True sync require3 do {} goto active_non_1_non_2_3;

loc active_non_1_non_2_3: while True wait{x_1'=0,x_2'=0}
	when x_3 - WCET_3 < 0 sync require1 do {} goto active_1_non_2_3;
	when x_3 - WCET_3 < 0 sync require2 do {} goto active_non_1_2_3;
	when x_3 - WCET_3 = 0 sync done3 do {x_3'=0} goto active_non_1_non_2_non_3;

loc active_non_1_2_non_3: while True wait{x_1'=0,x_3'=0}
	when x_2 - WCET_2 < 0 sync require1 do {} goto active_1_2_non_3;
	when x_2 - WCET_2 < 0 sync require3 do {} goto active_non_1_2_3;
	when x_2 - WCET_2 = 0 sync done2 	do {x_2'=0} goto active_non_1_non_2_non_3;

loc active_non_1_2_3: while True wait{x_1'=0,x_3'=0}
	when x_2 - WCET_2 < 0 sync require1 do {} goto active_1_2_3;
	when x_2 - WCET_2 = 0 sync done2 do {x_2'=0} goto active_non_1_non_2_3;

loc active_1_non_2_non_3: while True wait{x_2'=0,x_3'=0}
	when x_1 - WCET_1 < 0 sync require2 do {} goto active_1_2_non_3;	
	when x_1 - WCET_1 < 0 sync require3 do {} goto active_1_non_2_3;
	when x_1 - WCET_1 = 0 sync done1 do {x_1'=0} goto active_non_1_non_2_non_3;

loc active_1_non_2_3: while True wait{x_2'=0,x_3'=0}
	when x_1 - WCET_1 < 0 sync require2 do {} goto active_1_2_3;	
	when x_1 - WCET_1 = 0 sync done1  do {x_1 '= 0} goto active_non_1_non_2_3;

loc active_1_2_non_3: while True wait{x_2'=0,x_3'=0}
	when x_1 - WCET_1 < 0 sync require3 do {} goto active_1_2_3;
	when x_1 - WCET_1 = 0 sync done1 do {x_1'=0}  goto active_non_1_2_non_3;

loc active_1_2_3: while True wait {x_2'=0,x_3'=0}
	when x_1 - WCET_1 = 0 sync done1 do {x_1'= 0} goto active_non_1_2_3;

end

automaton T_1

synclabs: done1, require1;

loc init_s: while t_1 - Off1 <= 0 wait {}
    when t_1 - Off1 = 0 sync require1 do {t_1'=0} goto waiting;

loc idle: while t_1 - per1 <= 0 wait {}
    when t_1 - per1 = 0 sync require1 do {t_1'=0} goto waiting;

loc waiting: while t_1 - per1 <= 0 wait {}
    when True sync done1 do {} goto idle;

end

automaton T_2

synclabs: done2, require2;


loc init_s: while t_2 - Off2 <= 0 wait {}
    when t_2 - Off2 = 0 sync require2 do {t_2'=0} goto waiting;

loc idle: while t_2 - per2 <= 0 wait {}
    when t_2 - per2 = 0 sync require2 do {t_2'=0} goto waiting;

loc waiting: while t_2 - per2 <= 0 wait {}
    when True sync done2 do {} goto idle;

end

automaton T_3

synclabs: done3, require3;

loc init_s: while t_3 - Off3 <= 0 wait {}
    when t_3 - Off3 = 0 sync require3 do {t_3'=0} goto waiting;

loc idle: while t_3 - per3 <= 0wait {}
    when t_3 - per3 = 0 sync require3 do {t_3'= 0} goto waiting;

loc waiting: while t_3 - per3 <= 0 wait {}
    when True sync done3 do {} goto idle;

end

init := loc[stopper] = f_1_r &
    loc[scheduler_P_Application] = active_non_1_non_2_non_3 &
    loc[T_1] = init_s &
    loc[T_2] = init_s &
    loc[T_3]= init_s &
x_1 = 0 &
x_2 = 0 &
x_3 = 0 &
t_1 = 0 &
t_2 = 0 &
t_3 = 0 &
time = 0
;
