function objSkeleton = Skeleton2(this, iDimension)
    % This is a different algorithm for constructing skeletons.  Should we
    % choose this algorithm over the other, the help-doc for the other function
    % can be placed here verbatim (after the `2` is removed from this
    % function's name, of course).  Both algorithms remain for the moment for
    % testing purposes.
    % 
    % This algorithm seems to be faster on the first call, and the other
    % algorithm seems to be faster on subsequent calls (regardless of the
    % dimension used in either call).  More testing should probably be done.

    % This matrix will hold the generators for the skeleton being constructed.
    % NOTE: Counting the number of generators for the skeleton and
    % preallocating here would probably be a big speed improvement.
    mtxNewGens = zeros(0, this.NumVerts);

    objFacets = this.GetFacets();

    % Loop through the facets of this complex.
    for ii = (1 : this.GetFacets().Size)
        % Retrieve the current facet.
        rvCurrFacet = objFacets(ii).ToMatrix();

        % If the dimension of this facet is at most `iDimension`, then just add
        % this facet to the skeleton's generating set; note that this is the case
        % if the number of vertices in this facet is at most `iDimension + 1`.
        % Otherwise...
        if (sum(rvCurrFacet) <= iDimension + 1)
            mtxNewGens = [mtxNewGens; rvCurrFacet];
        else
            % ...we need to build the list of all faces of this facet that are of
            % dimension `iDimension` and append that list to the list of generators.

            mtxNewGens = [mtxNewGens; ...
                Utils.SubsetsOfSize(rvCurrFacet, iDimension + 1)];
        end
    end

    % Use the generators to create the simplicial complex for this skeleton.
    objSkeleton = SimplicialComplex(Collection(unique(mtxNewGens, 'rows')));
end