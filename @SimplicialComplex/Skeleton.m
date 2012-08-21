function objSkeleton = Skeleton(this, iDimension)
    %------------------------------------------------------------
    % Usage:
    %    objSkeleton = obj.Skeleton(iDimension)
    % Description:
    %    Returns a `SimplicialComplex` object that contains a k-skeleton of the
    %    calling object.
    % Arguments:
    %    iDimension
    %       The dimension of the skeleton to be returned.  The returned object
    %       will contain all of the faces of the calling object that have
    %       dimension less than or equal to this parameter.
    % Note:
    %    This algorithm is not optimized and could likely be improved if speed
    %    is important.  Preallocation of memory is one potential point of
    %    improvement.  Additionally, other algorithms could be significantly
    %    better.
    %    
    %    This does not yet implement the improved algorithm for computing the
    %    1-skeleton by using matrix multiplication (something like
    %    `this.GetFacets()' * this.GetFacets()` to get an adjacency matrix).
    %------------------------------------------------------------

    if (iDimension == 1 && ~this.FacesAreGenerated)
        % I'm sure this could be cleaned up.  We're just testing...
        mtxAdj = this.Graph().AdjacencyMatrix;
        mtxGens = zeros(nnz(mtxAdj) / 2, this.NumVerts);

        % This should be explained well in the process of cleaning this up.  Also,
        % if this can be 'vectorized', then it should be; but I couldn't get it to
        % work in the time that I spent on it.
        [I, J] = find(triu(mtxAdj));

        for ii = (1 : length(I))
            mtxGens(ii, [I(ii), J(ii)]) = 1;
        end

        % The method above will not pick up vertices that are maximal faces (since
        % these vertices are not adjacent to anybody in the corresponding graph).
        % Add these vertices (in fact, all vertices) to the list of generators
        % here.
        mtxGens = [mtxGens; diag(any(this.Generators.ToMatrix(), 1))];

        objSkeleton = SimplicialComplex(Collection(mtxGens));
    else
        cvFaceDimensions = sum(this.GetFaces().ToMatrix(), 2) - 1;
        objFaces = this.GetFaces();
        objSkeleton = SimplicialComplex(objFaces(cvFaceDimensions <= iDimension));
    end
end