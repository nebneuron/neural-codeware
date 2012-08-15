classdef Code < handle
    properties (GetAccess = public, SetAccess = protected)
        Words
        Metric
    end
    
    properties (GetAccess = public, SetAccess = protected)
        Distribution
    end
    
    methods (Access = public)
        function obj = Code(words, cvDistribution)
            if isa(words, 'Collection')
                obj.Words = words.Copy();
            else
                obj.Words = Collection(words);
            end
            
            if nargin < 2
                cvDistribution = ones(obj.Words.Size(), 1);
            end
            
            obj.Metric = Code.HammingDist;
            obj.SetDistribution(cvDistribution);
        end
        
        function cpx = CodeComplex(this)
            cpx = SimplicialComplex(this.Words);
        end
        
        function cllnDecoded = Decode(this, clln)
            % We should maybe use the input parser here for different methods.
            
        end
        
        function cllnDecoded = DecodeMAP(this, clln)
        end
        
        function d = Distance(this, x, y)
            d = this.Metric(x, y);
        end
        
        function gph = Graph(this)
            % The neuron cofire graph: a vertex for each codeword index,
            % edges joining indices that appear in some codeword together.
            mtxWords = this.Words.ToMatrix();
            
            gph = Graph(mtxWords' * mtxWords);
        end
        
        function gph = CodewordGraph(this, tol)
            mtxWords = this.Words.ToMatrix();
            
            if nargin < 2
                tol = 1;
            end
            
            % The vertices should be the codewords of the graph, and we should join
            % words if their Hamming distance is at most `tol`.
            mtxHamming = mtxWords * (~mtxWords)' + (~mtxWords) * mtxWords';
            gph = Graph(mtxHamming <= tol);
        end
        
        function iLength = Length(this)
            iLength = this.Words.Dimension;
        end
        
        function cllnRand = RandomSample(this, iSize)
            [~, I] = max(bsxfun(@le, ...
                                rand(iSize, 1), ...
                                cumsum(this.Distribution)), ...
                         [], 2);
            
            cllnRand = this.Words(I);
        end
        
        function r = Rate(this)
            r = log2(this.Words.Size) / this.Words.Dimension;
        end
        
        function SetDistribution(this, cvDistribution)
            % More checking could be done here.  For instance, the current
            % checking allows for `NaN` and `Inf` values that will cause errors.
            assert(isa(cvDistribution, 'numeric'), ...
                   'The input distribution must have a numeric type.');
            assert(iscolumn(cvDistribution), ...
                   'The input distribution must be a column vector.');
            assert(length(cvDistribution) == this.Words.Size(), ...
                   ['The input distribution must have length equal to the size ' ...
                    'of the code.']);
            assert(min(cvDistribution) >= 0 && max(cvDistribution) >= 0, ...
                   ['The input distribution must contain only nonnegative ' ...
                    'values and at least one positive value.']);
            
            obj.Distribution = cvDistribution / sum(cvDistribution);
        end
        
        function SetMetric(this, fcnHandle)
            this.Metric = fcnHandle;
        end
        
        function codeNew = Shuffle(this)
            mtxOld = this.Words.ToMatrix();
            
            iSize = this.Words.Size;
            iLength = this.Words.Dimension;
            
            mtxNew = zeros(iSize, iLength);
            
            for ii = (1 : this.Words.Size)
                bFoundNewWord = false;
                
                while ~bFoundNewWord
                    rvNewWord = mtxOld(ii, randperm(iLength));
                    
                    if ~isempty(setdiff(rvNewWord, mtxNew(1 : ii - 1, :), 'rows'))
                        mtxNew(ii, :) = rvNewWord;
                        bFoundNewWord = true;
                    end
                end
            end
            
            codeNew = Code(mtxNew);
        end
        
        function iSize = Size(this)
            iSize = this.Words.Size;
        end
        
        function s = Sparsity(this)
            s = nnz(this.Words.ToMatrix()) / (this.Words.Size * this.Words.Dimension);
        end
        
        function mtx = ToMatrix(this)
            mtx = ToMatrix(this.Words);
        end
    end
    
    properties (Constant)
        HammingDist = @(u, v) nnz(xor(u, v));
        
        AsymmetricDist = @(u, v) max(nnz(and(u, 1 - v)), ...
                                     nnz(and(1 - u, v)));
    end
    
    methods (Static)
        function obj = NordstromRobinson()
            % ...
            
            % This construction of the Nordstrom-Robinson code comes from Huffman & Pless.
            % First generate the extended Golay code.  This construction requires the entries
            % of the Golay code to be in a specific order; the variables 'first8' and 'last16'
            % store the first 8 entries and the last 16 entries of the codewords in the
            % appropriate order.  The variable 'numOnes' counts the number of ones in the
            % first 8 entries.
            objGolay = LinearCode.Golay();
            first8   = objGolay.mxCodewords(:, [12, 13, 15, 16, 18, 19, 20, 24]);
            last16   = objGolay.mxCodewords(:, [1 2 3 4 5 6 7 8 9 10 11 14 17 21 22 23]);
            numOnes  = sum(first8, 2);

            % With the above setup, the codewords of the Nordstrom-Robinson code are the
            % last 16 entries of the Golay codewords whose first 8 entries are all zeros
            % or whose first 8 entries contain exactly 2 ones, one of which is the first
            % entry of the codeword.
            mtxCode = last16( (numOnes == 0) | (numOnes == 2 & first8(:, 1) == 1), : );
            obj = Code(mtxCode);
        end
        
        function obj = Random(iLength, iNumWords, fSparsity)
            assert(iNumWords < 2^iLength, ...
                'First and second arguments are not compatible.')
            
            % Generate a random code, and remove repeated codewords.
            mtxCode = unique(rand(iNumWords, iLength) < fSparsity, 'rows');
            
            % If there are not enough unique codewords, generate more codewords
            % until enough codewords have been generated.
            while size(mtxCode, 1) < iNumWords
                temp = (rand(iNumWords, iLength) < fSparsity);
                mtxCode = unique([mtxCode; temp], 'rows');
            end
            
            % The above process could have produced too many codewords; select
            % only the first `iNumWords` that were generated.
            mtxCode = mtxCode(1:iNumWords, :);
            obj = Code(mtxCode);
        end
        
        function obj = RandomConstantWeight(iLength, iNumWords, iWeight)
            % obj = Code.RandomConstantWeight(iLength, iNumWords, iWeight)
            assert(nchoosek(iLength, iWeight) >= iNumWords, ...
                ['The number of possible codewords of length ' num2str(iLength) ...
                 ' and weight ' num2str(iWeight) ' is less than the number of desired' ...
                 ' codewords (' num2str(iNumWords) ').  Please choose new parameters.']);

            [~, perm] = sort(rand(iNumWords, iLength), 2);
            indices = perm(:, 1:iWeight);
            mtxCode = zeros(iNumWords, iLength);
            mtxCode(sub2ind(size(mtxCode), [1:iNumWords]' * ones(1, iWeight), indices)) = 1;
            mtxCode = unique(mtxCode, 'rows');

            ii = 0;
            while size(mtxCode, 1) < iNumWords
                [~, perm] = sort(rand(iNumWords, iLength), 2);
                indices = perm(:, 1:iWeight);
                temp = zeros(iNumWords, iLength);
                temp(sub2ind(size(temp), [1:iNumWords]' * ones(1, iWeight), indices)) = 1;

                temp = unique(temp, 'rows');
                mtxCode = unique([mtxCode; temp], 'rows');
                ii = ii + 1;
            end

            mtxCode = mtxCode(1:iNumWords, :);
            obj = Code(mtxCode);
        end
        
        function obj = ShiftCode(n, k)
            rv = zeros(1, n);
            cv = zeros(1, n);

            rv(n - k + 1 : end) = 1;
            cv(2 : k + 1) = 1;

            obj = Code(toeplitz(cv, rv));
        end
    end
end