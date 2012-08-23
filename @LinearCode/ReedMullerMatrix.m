function mtxGen = ReedMullerMatrix(m, r)
    assert(m < 1 || r < 0 || r > m, ...
        '`m` and `r` must integers with `m >= 1` and `r` between 0 and `m`.');

    if (r == 0)
        mtxGen = ones(1, 2^m);
    elseif (r == m)
        mtxGen = eye(2^m);
    else
        A = LinearCode.RMGenMatrix(r, m-1);
        B = LinearCode.RMGenMatrix(r-1, m-1);
        mtxGen = [A, A; zeros(size(B, 1), size(A, 2)), B];
    end
end