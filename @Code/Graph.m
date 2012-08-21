function gph = Graph(this)
    % The neuron cofire graph: a vertex for each codeword index,
    % edges joining indices that appear in some codeword together.
    mtxWords = this.Words.ToMatrix();

    gph = Graph(mtxWords' * mtxWords);
end