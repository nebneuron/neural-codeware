function mtxGen = HammingMatrix(r)
    assert(r >= 2, 'Hamming: "r" must be an integer greater than 1.');

    % First, we want to create the parity check matrix for the Hamming code.
    % This solution is a bit of a kludge.  The 'dec2bin' function creates an
    % ASCII representation of the binary form of the input decimal number.  To
    % convert this vector of strings (which are stored as vectors) to a matrix
    % of binary numbers, we subtract the ASCII value corresponding to zero,
    % which is 48.
    mtxParity = ( dec2bin([1 : 2^r - 1]) - 48 )';

    % If $H = [A | I_{n-k}]$ is a parity check matrix, then $G = [I_k | -A^T]$
    % is a generator matrix for the same code.  Remove the size `r` identity
    % matrix from the parity check matrix, and create the generator matrix
    % using the above relation.  (Note that no negative sign is needed because
    % we are dealing with binary matrices.)
    mtxGen = [eye(2^r - r - 1), setdiff(mtxParity', eye(r), 'rows')];
end