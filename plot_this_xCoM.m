function plot_this_xCoM(time, xCoM,temps)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
fplot(time, xCoM, 'LineWidth',5)
hold on
secs = linspace(0, 100, temps);
human_motions = 0.05*ones(size(secs));

xCoM_now = subs(xCoM, time, secs);
errorbar(secs,xCoM_now,human_motions,'CapSize',18)
end

