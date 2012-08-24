function SetWeights(this, vecWeights)
    %--------------------------------------------------------------------------------
    % Usage:
    %    clln.SetWeights(vecWeights)
    % Description:
    %    Assign a weight to each element of this collection.
    % Arguments:
    %    cvWeights
    %       A vector containing a numeric weight for each element of this
    %       collection.
    %--------------------------------------------------------------------------------
    
    assert(isvector(cvWeights), 'The provided weights must be in vector form.');
    assert(isnumeric(cvWeights), 'The provided weights must be numeric.');
    assert(NumElts(this) == length(cvWeights), ...
           ['The number of weights must be the same as the number of ' ...
            'elements in the calling collection.']);

    this.Weights = reshape(cvWeights, length(cvWeights), 1);
end