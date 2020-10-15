clear;clc;close all;

comprspl('sample/Env.wav',[1,48000],'base_level',2*10^-6);
comprspl('sample/Robot.wav',[1,48000],'base_level',2*10^-6);
comprspl('sample/Boat.wav',[1,48000],'base_level',2*10^-6);