function [xCoM] = compute_xCoM(fixos, crew, pl_pas, pl_fwd_lug,pl_rear_lug, fuel)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%xCoM = sym('xCoM', 'real');

total = 0;
for columna=1:length(fixos)
    total = total + fixos(1, columna)*fixos(2, columna);
end
num = total + crew(1, 1)*crew(2, 1) + pl_pas(1, 1)*pl_pas(2, 1) + pl_fwd_lug(1, 1)*pl_fwd_lug(2, 1)+pl_rear_lug(1, 1)*pl_rear_lug(2, 1) + fuel(1, 1)*fuel(2, 1);
den = sum(fixos(1,:)) + crew(1, 1) + pl_pas(1, 1) + pl_fwd_lug(1, 1)+pl_rear_lug(1, 1)+ fuel(1, 1);

xCoM = num/den;
end

