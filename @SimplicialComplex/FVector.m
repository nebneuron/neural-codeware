function fvect = FVector(this)
    %------------------------------------------------------------
    % Usage:
    %    fvect = obj.FVector()
    % Description:
    %    Compute and return the f-vector of this simplicial complex
    %    (except the zeroth entry).  Specifically, `fvect(i)` is the
    %    number of faces of dimension `i` in this complex.
    %------------------------------------------------------------

    fvect = histc(sum(this.GetFaces().ToMatrix(), 2), ...
                  1 : this.NumVerts);
end