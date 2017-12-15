function [dyda, dydb, dydc] = derivatives_axxbxc(x)

N = size(x, 2);

dyda = x .* x;
 
dydb = x;

dydc = ones(1, N);