classdef Utils
    % Description:
    %    A class containing utility functions as static methods.
    methods (Static)
        function mtxSubsets = SubsetsOf(vecIn)
            assert(isrow(vecIn));
            
            k = nnz(vecIn);
            mtxSubsets = zeros(2^k, length(vecIn));
            mtxSubsets(:, find(vecIn)) = Utils.BinaryVectors(k);
            
            % Remove the all-zero row (i.e., the empty subset).
            mtxSubsets(1, :) = [];
        end
        
        function mtx = BinaryVectors(iLength)
            %------------------------------------------------------------
            % Usage:
            %    mtx = BinaryVectors(iLength)
            % Description:
            %    Returns a matrix whose rows are the binary vectors of
            %    the given length.
            % Arguments:
            %    iLength
            %       The length of the vectors to be computed.
            %------------------------------------------------------------
            assert(isscalar(iLength), 'Input must be a scalar.');
            assert(floor(iLength) == iLength, 'Input must be integer-valued');
            
            if iLength == 1
                mtx = [0; 1];
            else
                mtxSmaller = Utils.BinaryVectors(iLength - 1);
                
                mtx = [zeros(2^(iLength - 1), 1), mtxSmaller; ...
                       ones(2^(iLength - 1), 1), mtxSmaller];
            end
        end
        
        % function mtxBinaryVects = BinaryVectors(iLength, r)
        %     assert(isscalar(iLength), 'Input must be a scalar.');
        %     assert(floor(iLength) == iLength, 'Input must be integer-valued');
        %     
        %     if nargin < 2
        %         r = 15;
        %     end
        %     
        %     k = iLength;
        %     
        %     if (k <= r)
        %         mtxBinaryVects = (dec2bin([0 : 2^k - 1], k) == '1');
        %     else
        %         mtxBinaryVects = zeros(2^k, k);                
        %         rvVals = (0 : 2 ^r - 1);
        %         
        %         for i = 1 : 2^(k-r)
        %             mtxBinaryVects(rvVals + 1, :) = (dec2bin(rvVals, k) == '1');
        %             rvVals = rvVals + 2^r;
        %         end
        %     end
        % end
        
        function mtxSubsets = SubsetsOfSize(vecIn, iSize)
            %------------------------------------------------------------
            % Usage:
            %    mtxSubsets = Utils.SubsetsOfSize(vecIn, iSize)
            % Description:
            %    Returns a matrix whose rows correspond to the subsets of the given
            %    size of the nonzero entries of the input vector.  For example, if the
            %    input vector is `[0 1 1 1]` and the given size is `2`, then the return
            %    value will be `[0 1 1 0; 0 1 0 1; 0 0 1 1]` or some row-permutation
            %    thereof.
            % Arguments:
            %    vecIn
            %       The input vector.
            %    iSize
            %       The size of the subsets to return.  This will be the number of
            %       nonzero entries in each row of the returned matrix.
            %------------------------------------------------------------
            
            if (length(find(vecIn, iSize)) < iSize)
                mtxSubsets = zeros(0, length(vecIn));
            else
                % Create the list of subsets of the vertices in this facet.
                mtxRowIndices = nchoosek(find(vecIn), iSize);
                iSets = size(mtxRowIndices, 1);
                mtxLinearIndices = iSets * (mtxRowIndices - 1) + repmat((1 : iSets).', 1, iSize);

                mtxSubsets = zeros(iSets, length(vecIn));
                mtxSubsets(mtxLinearIndices(:)) = 1;
            end
        end
        
        function celSubsets = MatrixToSubsets(mtxSubsets)
            %------------------------------------------------------------
            % Usage:
            %    mtxSubsets = Utils.MatrixToSubsets(mtxSubsets)
            % Description:
            %    Returns a cell array representation of the logical (0/1) input matrix
            % Arguments:
            %    mtxSubsets
            %       A 0/1 matrix whose rows represent subsets of its columns.
            % Note:
            %    No checking is done to make sure that the subsets returned are unique.
            %------------------------------------------------------------
            
            iNumSubsets = size(mtxSubsets, 1);
            celSubsets = cell(iNumSubsets, 1);
            
            for ii = (1 : iNumSubsets)
                celSubsets{ii} = find(mtxSubsets(ii, :));
            end
        end
        
        function mtxSubsets = SubsetsToMatrix(cellSubsets, iSetSize)
            %------------------------------------------------------------
            % Usage:
            %    mtxSubsets = Utils.SubsetsToMatrix(cellSubsets, iSetSize)
            % Description:
            %    Returns a matrix whose rows are indicator vectors for
            %    the subsets in the given cell array.
            % Arguments:
            %    cellSubsets
            %       A cell array whose entries are row vectors (sets).  The maximum
            %       number among entries determines the number of columns of the
            %       returned matrix.
            %    iSetSize
            %       The size of the
            % Note:
            %    No checking is done to make sure that the subsets are unique.
            %------------------------------------------------------------
            
            iNumSubsets = size(cellSubsets, 1);
            iMax = max([cellSubsets{:}]);
            
            if nargin < 2
                iSetSize = iMax;
            end
            
            assert(iMax <= iSetSize);
            
            mtxSubsets = zeros(iNumSubsets, iSetSize);
            
            for ii = (1 : iNumSubsets)
                mtxSubsets(ii, cellSubsets{ii}) = 1;
            end
        end
        
        function plt = PlotCircle(center, r, iNumPts)
            t = linspace(0, 2*pi, iNumPts);
            x = center(1) + r * cos(t);
            y = center(2) + r * sin(t);
            
            plt = plot(x, y, 'Color', [0, 0, 0]);
        end
    end
end