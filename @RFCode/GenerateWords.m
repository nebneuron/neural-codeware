function cllnWords = GenerateWords(mtxCenters, cvRadii)
    %---------------------------------------------------------------------------
    % Usage:
    %    cllnWords = RFCode.GenerateWords(mtxCenters, cvRadii)
    % Description:
    %    Generate the collection of codewords in the receptive-field code
    %    with the given centers and radii.
    % Arguments:
    %    mtxCenters
    %       A 2-column matrix with each row representing the center of a
    %       circular receptive field.
    %    r
    %       A vector of radii for the receptive fields.
    %---------------------------------------------------------------------------
    
    X = mtxCenters(:, 1);
    Y = mtxCenters(:, 2);
    
    % Build the matrix of cofirings.
    mtxCofire = (sqrt(bsxfun(@minus, X, X').^2 + ...
                      bsxfun(@minus, Y, Y').^2) ...
                 < bsxfun(@plus, cvRadii, cvRadii'));
    
    cllnWords = GetCliques(Graph(mtxCofire));
    
    cllnWords.RemoveEltsContaining(...
        RFCode.EmptyTriangles(cllnWords, mtxCenters, cvRadii));
end