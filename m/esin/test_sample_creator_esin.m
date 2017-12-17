function [y] = test_sample_creator_esin(x, ampl, t0, w, xc, filename)

N = size(x, 2);

y = ampl .* exp(-x / t0) .* sin(w .* (x - xc));

if nargin == 6
    fid = fopen(filename, 'w');

    for i = 1 : N
        fprintf(fid, '%f %f\n', x(i), y(i));
    end

    close(fid);
end
