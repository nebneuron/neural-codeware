function cpxCompletion = HellyCompletion(this, iDimension, iMaxFaceDim)
    %------------------------------------------------------------
    % Usage:
    %    cpxCompletion = obj.HellyCompletion(iDimension, iMaxFaceDim)
    % Description:
    %    Returns a `SimplicialComplex` object that contains a Helly
    %    k-completion of the calling object.
    % Arguments:
    %    iDimension
    %       The dimension of the Helly completion to be returned.  For
    %       instance, if this is `1`, then the Helly completion is the clique
    %       complex of the 1-skeleton of the calling complex.
    %    iMaxFaceDim
    %       The maximum dimension of the faces to be included in the completion
    %       to be returned.
    % To-do:
    %    Do input checking/parsing.
    %------------------------------------------------------------

    if nargin < 3
        iMaxFaceDim = NumVerts(this) - 1;
    end

    % Initialize the Helly completion to be the clique complex (which is a
    % super-complex of the Helly completion).
    cpxCompletion = CliqueComplex(Graph(this), iMaxFaceDim + 1);

    % If `iDimension` is `1`, then we are done; otherwise, we must do some
    % pruning.
    if (iDimension ~= 1)
        % Get the `iDimension`-skeleton.
        cpxSkeleton = this.Skeleton(iDimension);

        % Find the faces of the given dimension in the clique complex that are not
        % in the generated skeleton.
        % 
        % For now, retrieve the matrix representations of the two complexes to work
        % with; perhaps change this in the future.  In fact, most of this
        % functionality should probably be wrapped into methods in
        % `SimplicialComplex` (and possibly `Collection`).
        mtxCompletionFaces = cpxCompletion.GetFaces().ToMatrix();
        mtxSkeletonFaces = cpxSkeleton.GetFaces().ToMatrix();

        % Remove all faces of dimension greater than `iDimension`.
        mtxCompletionFaces = mtxCompletionFaces(sum(mtxCompletionFaces, 2) <= iDimension + 1, :);
        mtxSkeletonFaces = mtxSkeletonFaces(sum(mtxSkeletonFaces, 2) <= iDimension + 1, :);

        % Find the faces (of the given dimension) of the clique complex that are
        % empty faces in the skeleton.
        mtxEmptyFaces = setdiff(mtxCompletionFaces, mtxSkeletonFaces, 'rows');

        % Remove all faces of the clique complex that contain any of the empty
        % faces found above.
        cpxCompletion.RemoveFaces(Collection(mtxEmptyFaces));
    end
end