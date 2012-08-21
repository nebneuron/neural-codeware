function cllnFaces = GetFaces(this)
    %------------------------------------------------------------
    % Usage:
    %    cllnFaces = obj.GetFaces()
    % Description:
    %    Return the `Collection` of faces of the calling complex.
    %    Generate the faces if they have not already been computed.
    %------------------------------------------------------------

    if (~FacesAreGenerated(this))
        GenerateFaces(this);
    end

    cllnFaces = this.Faces;
end