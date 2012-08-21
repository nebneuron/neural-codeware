function cllnFacets = GetFacets(this)
    %------------------------------------------------------------
    % Usage:
    %    cllnFacets = cpx.GetFacets()
    % Description:
    %    Retrieve the facets (maximal faces) of the calling complex. Compute
    %    the facets if they have not already been computed.
    % Return values:
    %    cllnFacets
    %       A `Collection` containing the facets of the calling object.
    %------------------------------------------------------------

    % If the set of facets has not already been computed, then we
    % need to generate this set.
    if (~FacetsAreGenerated(this))
        GenerateFacets(this);
    end

    % Return the facets.
    cllnFacets = this.Facets;
end