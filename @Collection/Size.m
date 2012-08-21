function iSize = Size(this)
    %-----------------------------------------------------------------------
    % Usage:
    %    iSize = Size(this)
    % Description:
    %    Return the number of elements in this set.
    %-----------------------------------------------------------------------
    
    iSize = size(this.Sets, 1);
end