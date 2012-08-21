function varDummy = RemoveEltsContaining(this, cllnSets)
    %--------------------------------------------------------------------------------
    % Usage:
    %    obj.RemoveEltsContaining(cllnSets)
    % Description:
    %    Removes all elements of the calling object that are supersets of any
    %    of the elements of the given collection.
    % Arguments:
    %    cllnSets
    %       A `Collection` object of the same dimension as the calling object.
    % Note:
    %    Technically, this returns an empty array `[]`.  The reason for this is
    %    a complication with overriding the `subsref` method.
    %--------------------------------------------------------------------------------
    varDummy = [];
    
    this.Sets = RemoveFaces(full(ToMatrix(this)), full(ToMatrix(cllnSets)));
end