function [y] = test_sample_creator_esin(x, amplA, amplB, amplC, t0, w, filename)

N = size(x, 2);

y = amplA .* exp(-x / t0) .* (amplB .* sin(w .* x) + amplC .* cos(w .* x));


if nargin == 7
    fid = fopen(filename, 'w');

    for i = 1 : N
        fprintf(fid, '%f %f\n', x(i), y(i));
    end

    close(fid);
end
