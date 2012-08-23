function cllnWords = GenerateWords(mtxCenters, cvRadii)
    X = mtxCenters(:, 1);
    Y = mtxCenters(:, 2);

    % Build the matrix of cofirings.
    mtxCofire = (sqrt(bsxfun(@minus, X, X').^2 + ...
                      bsxfun(@minus, Y, Y').^2) ...
                 < bsxfun(@plus, cvRadii, cvRadii'));

    G = Graph(mtxCofire);
    objComplex = G.CliqueComplex();

    cllnEmptyTriangles = ...
        RFCode.EmptyTriangles(objComplex.GetFaces(), ...
                              mtxCenters, ...
                              cvRadii);

    objComplex.RemoveFaces(cllnEmptyTriangles);

    cllnWords = objComplex.GetFaces();
end