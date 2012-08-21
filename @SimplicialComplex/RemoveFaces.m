function RemoveFaces(this, cllnFaces)
    %------------------------------------------------------------
    % Usage:
    %    cpx.RemoveFaces(cllnFaces)
    % Description:
    %    Remove the given faces from the calling object.  To ensure that the
    %    calling object remains a simplicial complex, all faces that contain
    %    any of the given faces are also removed from the calling object.
    % Arguments:
    %    cllnFaces
    %       A `Collection` of the faces to be removed from the calling object.
    %------------------------------------------------------------

    % This is a bit tricky: We have several potential things to modify, but we
    % don't want to do more work than is necessary.  For instance, if the list
    % of all faces has been computed, then we want to remove the appropriate
    % faces from that list; however, if the list of all faces has not been
    % computed, then we do not want to do the extra work of (accidentally)
    % computing the list (which may not be needed).

    % One thing that we always want to do is remove the appropriate faces from
    % the set of generators.  Do so here.
    this.Generators.RemoveEltsContaining(cllnFaces);

    % The collection of facets may not have been generated.  I believe, however,
    % that computing this is fairly fast (it's not).  Hence, a choice or two has
    % to be made: Do we remove faces from the collection of facets?  What if the
    % collection of facets has not been generated?  Do we blindly regenerate the
    % facets instead of removing faces?  Likely, the right ting to do is to set
    % a private member variable that tracks whether or not the collection of
    % facets is up-to-date.  Still, even with that feature, the question remains
    % about whether it is faster to regenerate the collection of facets or to
    % remove faces from the (potentially) existing collection of facets.
    if (FacetsAreGenerated(this))
        this.Facets.RemoveEltsContaining(cllnFaces);
    end

    % The list of faces, however, is quite expensive to compute.  I believe,
    % therefore, that removing faces from an existing collection will be
    % significantly faster (in general) than recomputing the collection of
    % faces.  But we do not want to generate the collection of faces if it has
    % not been generated already (since this process is expensive).
    if (FacesAreGenerated(this))
        this.Faces.RemoveEltsContaining(cllnFaces);
    end
end