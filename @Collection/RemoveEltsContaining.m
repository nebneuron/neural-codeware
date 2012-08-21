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

    assert(this.Dimension == cllnSets.Dimension, ...
           '`Collection` objects must have the same dimension');

    % Retrieve the matrices corresponding to the sets.
    mtxThis = this.ToMatrix();
    mtxToRemove = cllnSets.ToMatrix();

    % This product computes the size of the pairwise intersections of the
    % calling object's elements with the elements to be removed.
    mtxNumEltsInCommon = mtxThis * mtxToRemove.';

    % Build a matrix whose columns are constant-valued; more specifically,
    % column `i` of the matrix contains (in each entry) the weight of the
    % element `i` of `cllnSets`.
    mtxNumEltsPerSet = ones(this.Size, 1) * sum(mtxToRemove, 2).';

    % Now, if |A \cap B| is equal to |B| for an element A of `this` and an
    % element B of `cllnSets`, then B is a subset of A.  In this case, we want
    % to remove A from `this`.
    mtxThis(any(mtxNumEltsInCommon == mtxNumEltsPerSet, 2), :) = [];

    % Set the generators in this object to be the unique elements of `mtxThis`.
    this.Sets = mtxThis;
end