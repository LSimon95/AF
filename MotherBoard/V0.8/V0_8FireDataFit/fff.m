clc;
clear;
load silver.dat;
load yellow.dat;
sm = mean(silver, 2);
ym = mean(yellow, 2);
tem = [17
25
50
100
150
200
250
300
350
400
450
];
cftool