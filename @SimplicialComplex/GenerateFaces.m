function GenerateFaces(this)
    %------------------------------------------------------------
    % Usage:
    %    cpx.GenerateFaces()
    % Description:
    %    Generate the complete matrix of faces.  This is a protected method so
    %    that the user doesn't accidentally regenerate this set.
    % Note:
    %    The algorithm used here is very naive.  It simply generates all
    %    subsets of each facet and unions these sets together.  This is quite
    %    slow, and memory efficiency is probably worse.
    %------------------------------------------------------------

    % Retrieve a matrix representation of the facets.
    mtxFacets = ToMatrix(GetFacets(this));

    % Create the initial list of faces to be the empty list.  If we find a
    % quick way to compute the number of faces without having to find all of
    % the faces, then preallocating here could be a good idea.  For now, we can
    % bound the number of faces; use this bound and keep track of the number of
    % faces as they're generated.
    iNumFacesBound = sum(2.^sum(mtxFacets, 2));
    iNumFaces = 0;
    mtxFaces = zeros(iNumFacesBound, NumVerts(this));

    for ii = (1 : this.GetFacets().Size)
        % Get the matrix of subsets of this facet.
        mtxSubsets = Utils.SubsetsOf(mtxFacets(ii, :));

        % Append the subsets of this facet to the list of faces.
        mtxFaces((iNumFaces + 1 : iNumFaces + size(mtxSubsets, 1)), :) = mtxSubsets;

        % Increment the number of faces.
        iNumFaces = iNumFaces + size(mtxSubsets, 1);
    end

    % Keep only the unique faces.
    this.SetFaces(Collection(unique(mtxFaces((1 : iNumFaces), :), 'rows')));

    % The old method.  It's slow.
    % 
    % % Retrieve a matrix representation of the facets.
    % mtxFacets = this.GetFacets().ToMatrix();
    % 
    % % Create the initial list of faces to be the empty list.  If we find a
    % % quick way to compute the number of faces without having to find all of
    % % the faces, then preallocating here could be a good idea.
    % mtxFaces = zeros(0, this.NumVerts);
    % 
    % for ii = (1 : this.GetFacets().Size)
    %     % Append the subsets of this facet to the list of faces.
    %     mtxFaces = [mtxFaces; Utils.SubsetsOf(mtxFacets(ii, :))];
    % end
    % 
    % % Keep only the unique faces.
    % this.SetFaces(Collection(unique(mtxFaces, 'rows')));
end