classdef WeightedCollection < Collection
    % Description:
    %    A class for storing a weighted collection of subsets.
    % Properties:
    %    <None>
    % Methods:
    %    <methods inherited from `Collection`>
    %    Append
    %    display
    %    ElementsOfSizes
    %    ElementsOfWeights
    %    GetWeights
    %    RemoveElts
    %    RemoveEltsContainedIn
    %    RemoveEltsContaining
    %    SetWeights
    %    subsref
        
    % Things not implemented: HellyCompletion
    
    properties (Access = protected)
        Weights
    end
    
    methods (Access = public)
        function this = WeightedCollection(sets, cvWeights, n)
            %---------------------------------------------------------------
            % Usage:
            %    clln = WeightedCollection(mtxSet, cvWeights)
            %    clln = WeightedCollection(cellSets, cvWeights, n)
            % Description:
            %    Constructs an object that contains subsets of some
            %    superset of the form {1, ..., n}.
            % Arguments:
            %    mtxSet
            %       A matrix whose rows are indicator vectors of sets.  If
            %       entry (i, j) is nonzero, then set i contains vertex j.
            %    cellSets
            %       A 1-dimensional cell array with each entry being a vector
            %       containing a subset of some superset.
            %    cvWeights
            %       A column vector of numeric weights.  Its length must
            %       be equal to the number of rows of `mtxSets` or the
            %       length of `cellSets`, whichever has been provided.
            %    n
            %       The size of the superset of the elements of this collection.
            % Note:
            %    No checking is done to ensure that specified elements are
            %    distinct.
            %---------------------------------------------------------------
            
            assert(nargin <= 3, ...
                   'At most 3 input arguments are accepted.');
            
            if nargin == 2
                this = this@Collection(sets);
            else
                this = this@Collection(sets, n);
            end
            
            this.SetWeights(cvWeights);
        end
    end
    
    methods (Access = public)
        Append(this, cllnNew)
        
        objCopy = Copy(this)
        
        display(this, iNumToDisplay)
        
        cvWeights = GetWeights(this)
        
        iNum = NumElts(this)
        
        RemoveElts(this, cllnSets)
        
        RemoveEltsContainedIn(this, cllnSets)
        
        RemoveEltsContaining(this, cllnSets)
        
        SetWeights(this, cvWeights)
        
        cllnComplex = SimplicialComplex(this)
    end
end