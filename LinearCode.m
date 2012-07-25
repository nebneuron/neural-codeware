classdef LinearCode < Code
    properties (Access = protected)
        GeneratorMatrix
        Words
    end
    
    methods (Access = public)
        function obj = LinearCode(mtxGenerator)
            obj.GeneratorMatrix = mtxGenerator;
        end
    end
    
    methods (Access = protected)
        function GenerateWords(this)
            % Get the rank of the matrix (which is the number of rows because we're
            % assuming that it is of full rank).  We would check that the given matrix
            % is of full rank using Matlab's 'rank' command, but this won't work because
            % we're working over the binary field.
            k = size(this.GeneratorMatrix, 1);

            % Create the code by finding all '2^k' binary linear combinations of the
            % generator matrix's rows.
            if (k < 16)
                mtxBinaryVectors = ( dec2bin([0 : 2^k - 1]) == 49 * ones(2^k, k) );
                mtxWords = mod(mtxBinaryVectors * this.GeneratorMatrix, 2);
            else
                r = 15;
                mtxWords = zeros(2^k, size(this.GeneratorMatrix, 2));
                
                for ii = (1 : 2^(k-r))
                    rvNums = (ii - 1 : ii - 1 + 2^r);
                    mtxBinaryVectors = dec2bin(rvNums, k) - 48;
                    mtxTemp = mod(mtxBinaryVectors * this.GeneratorMatrix, 2);
                    mtxWords(rvNums + 1, :) = mtxTemp;
                end
            end
            
            this.Words = Collection(mtxWords);
        end
    end
    
    methods (Static)
        function obj = Golay()
            % This creates one of the Golay codes.  Which one?  I think that it's the
            % extended one (aren't the two Golay codes of length 23 and 24), but that
            % should be verified.  If so, I think the other can be gotten by puncturing
            % this code on some (any?) column.
            v = [1 1 0 1 1 1 0 0 0 1 0];
            
            % The 'hankel(c, r)' command produces a matrix that is constant on its
            % anti-diagonals, where 'c' and 'r' are the first column and last row,
            % respectively, of this matrix.
            A = hankel(v, v([11, 1:10]));
            mtxGenerator = [eye(12), [0, ones(1, 11); ones(11, 1), A]];
        end
        
        function obj = Hamming(r)
            if (r < 2)
                error('Hamming: "r" must be an integer greater than 1.');
            end

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
            mtxGenerator = [eye(2^r - r - 1), setdiff(mtxParity', eye(r), 'rows')];
            
            obj = LinearCode(mtxGenerator);
        end
        
        function obj = ReedMuller(m, r)
            obj = LinearCode(LinearCode.RMGenMatrix(m, r));
        end
    end
    
    methods (Static, Access = private)
        function mtxGen = RMGenMatrix(m, r)
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
    end
end