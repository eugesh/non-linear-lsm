function [y] = test_sample_creator_axxbxc(x, a, b, c, filename)

N = size(x, 2);

y = c + b .* x + a .* x .* x;

if nargin == 5
    fid = fopen(filename, 'w');

    for i = 1:N
        fprintf(fid, '%f %f\n', x(i), y(i));
    end

    close(fid);
end