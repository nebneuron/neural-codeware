function cpxCliques = CliqueComplex(this, iMaxCliqueSize)
    %--------------------------------------------------------------------------
    % Usage:
    %    cpxCliques = gph.CliqueComplex(iMaxCliqueSize)
    % Description:
    %    Return the clique complex of this graph as a `SimplicialComplex`
    %    object.
    % Arguments:
    %    iMaxCliqueSize
    %       Return only the cliques up to this size.
    %--------------------------------------------------------------------------

    if nargin < 2
        iMaxCliqueSize = Size(this);
    end

    cpxCliques = SimplicialComplex(this.GetCliques(1, iMaxCliqueSize, false));
end