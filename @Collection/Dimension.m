function iDim = Dimension(this)
    %--------------------------------------------------------------------------------
    % Usage:
    %    iDim = obj.Dimension
    % Description:
    %    Retrieve the number of elements on which this collection of subsets
    %    lives.  That is, each element of the given `Collection` object is a
    %    subset of the set {1, ..., `iDim`}.
    %--------------------------------------------------------------------------------

    iDim = size(this.Sets, 2);
end