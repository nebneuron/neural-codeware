function gph = CodewordGraph(this, tol)
    mtxWords = this.Words.ToMatrix();

    if nargin < 2
        tol = 1;
    end

    % The vertices should be the codewords of the graph, and we should join
    % words if their Hamming distance is at most `tol`.
    mtxHamming = mtxWords * (~mtxWords)' + (~mtxWords) * mtxWords';
    gph = Graph(mtxHamming <= tol);
end