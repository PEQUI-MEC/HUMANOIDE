close all; clear; clc;
x = -5:0.5:5;
z = gaussmf(x,[2 0])*1.2-7; 
y = 3:-0.3:-3;
trajeto = [x; y; z];
plot(x,z)