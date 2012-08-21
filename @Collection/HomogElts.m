function mtxElts = HomogElts(this, iSize)
    %--------------------------------------------------------------------------------
    % Usage:
    %    mtxEltx = HomogElts(this, iSize)
    % Description:
    %    
    %    
    %    
    %--------------------------------------------------------------------------------
    
    cvIdxs = (sum(this.Sets, 2) == iSize);
    mtxElts = zeros(nnz(cvIdxs), iSize);
    
    for i = 1 : find(cvIdxs)
        mtxElts(i, :) = find(this.Sets(i, :));
    end
end