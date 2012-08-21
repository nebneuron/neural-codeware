function iFaces = CountFaces(this)
    % DO NOT USE!!!  This function is incomplete.
    
    assert(false, 'DO NOT USE!!!  This function is incomplete.');
    
    if FacesAreGenerated(this)
        iFaces = Size(GetFaces(this));
    elseif FacetsAreGenerated(this)
        iFaces = fcn(ToMatrix(GetFacets(this)));
    else
        iFaces = fcn(ToMatrix(GetGenerators(this)));
    end
end

function iCount = fcn(mtxIn)
    % This matrix could be huge.
    mtxPairwise = mtxIn * mtxIn';
    
    % Sum the number of subsets of each individual set.
    iCount = sum(2.^diag(mtxPairwise));
    
    % Subtract off the number of subsets of the pairwise intersections.
    iCount = iCount - sum(sum(2^.triu(mtxPairwise, 1)));
    
    % I'm not sure exactly what to do at this point.
    for i = find(mtxPairwise(1, :))
        
    end
end