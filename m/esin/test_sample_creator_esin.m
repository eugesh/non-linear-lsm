function [y] = test_sample_creator_esin(x, y0, ampl, t0, w, xc, filename)

N = size(x, 2);

y = y0 + ampl .* exp(-x / t0) .* sin(pi .* (x - xc) / w);

if nargin == 5
    fid = fopen(filename, 'w');

    for i = 1:N
        fprintf(fid, '%f %f\n', x(i), y(i));
    end

    close(fid);
end