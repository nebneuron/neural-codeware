function cllnWords = GenerateWords(mtxGenerator)
    % Get the rank of the matrix (which is the number of rows because we're
    % assuming that it is of full rank).  We would check that the given matrix
    % is of full rank using Matlab's 'rank' command, but this won't work because
    % we're working over the binary field.
    k = size(mtxGenerator, 1);

    % Create the code by finding all '2^k' binary linear combinations of the
    % generator matrix's rows.
    if (k < 16)
        mtxBinaryVectors = ( dec2bin([0 : 2^k - 1]) == '1' );
        mtxWords = mod(mtxBinaryVectors * mtxGenerator, 2);
    else
        r = 15;
        mtxWords = zeros(2^k, size(mtxGenerator, 2));

        for ii = (1 : 2^(k-r))
            rvNums = (ii - 1 : ii - 1 + 2^r);
            mtxBinaryVectors = dec2bin(rvNums, k) - 48;
            mtxTemp = mod(mtxBinaryVectors * mtxGenerator, 2);
            mtxWords(rvNums + 1, :) = mtxTemp;
        end
    end

    cllnWords = Collection(mtxWords);
end