function gph = Graph(this)
    %------------------------------------------------------------
    % Usage:
    %    gphOut = code.Graph()
    % Description:
    %    Retrieve the "cofire" graph of this code's collection of
    %    codewords.
    %------------------------------------------------------------
    
    gph = Graph(this.Words);
end