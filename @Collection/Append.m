function varDummy = Append(this, cllnNew)
    %--------------------------------------------------------------------------------
    % Usage:
    %    obj.Append(cllnNew)
    % Description:
    %    Appends the argument to the calling object.
    % Arguments:
    %    cllnNew
    %       A `Collection` object of the same dimension as the calling object.
    % Note:
    %    Technically, this returns an empty array `[]`.  The reason for this is
    %    a complication with overriding the `subsref` method.
    %--------------------------------------------------------------------------------
    varDummy = [];

    if (this.Dimension ~= cllnNew.Dimension)
        error('The dimension of the `Collection` objects must agree.');
    end

    this.Sets = [this.Sets; cllnNew.Sets];
end