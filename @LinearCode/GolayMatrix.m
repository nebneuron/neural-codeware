function mtxGen = GolayMatrix()
    % This creates one of the Golay codes.  Which one?  I think that it's the
    % extended one (aren't the two Golay codes of length 23 and 24), but that
    % should be checked.  If so, I think the other can be gotten by puncturing
    % this code on some (any?) column.
    v = [1 1 0 1 1 1 0 0 0 1 0];

    % The 'hankel(c, r)' command produces a matrix that is constant on its
    % anti-diagonals, where 'c' and 'r' are the first column and last row,
    % respectively, of this matrix.
    A = hankel(v, v([11, 1:10]));
    mtxGen = [eye(12), [0, ones(1, 11); ones(11, 1), A]];
end