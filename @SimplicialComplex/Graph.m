function gphOut = Graph(this)
    %------------------------------------------------------------
    % Usage:
    %    gphOut = cpx.Graph()
    % Description:
    %    Retrieve the underlying graph of this simplicial complex.
    %------------------------------------------------------------
    
    gphOut = Graph(GetGenerators(this));
end