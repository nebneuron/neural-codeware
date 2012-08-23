classdef Collection < handle
    % Description:
    %    A class for storing a collection of subsets.
    % Properties:
    %    Sets
    % Methods:
    %    Append
    %    display
    %    ElementsOfSizes
    %    Graph
    %    MaximalElements
    %    n
    %    NumElts
    %    RemoveElts
    %    RemoveEltsContainedIn
    %    RemoveEltsContaining
    %    SimplicialComplex
    %    Size
    %    subsref
    %    ToMatrix
    %    ToSubsets
        
    % Things not implemented: HellyCompletion, SetWeights, GetWeights
    
    properties (GetAccess = public, SetAccess = protected)
        Sets
    end
    
    methods (Access = public)
        function this = Collection(sets, n)
            %---------------------------------------------------------------
            % Usage:
            %    clln = Collection(mtxSet)
            %    clln = Collection(cellSets, n)
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
            %    n
            %       The size of the superset of the elements of this collection.
            % Note:
            %    No checking is done to ensure that specified elements are distinct;
            %    hence, the resulting object is allowed to contain duplicate
            %    sets.
            %---------------------------------------------------------------
            
            assert(nargin <= 2, ...
                   'At most 2 input arguments are accepted.');
            
            if nargin == 1
                assert(ismatrix(sets));
                assert(isnumeric(sets) || islogical(sets));
                
                % this.Sets = spones(sets(any(mtxSet, 2), :));
                this.Sets = spones(sets);
            else
                assert(isa(sets, 'cell'), ...
                       ['When two arguements are provided, the first must ' ...
                        'be a cell array.']);
                assert(isvector(sets));
                
                this.Sets = sparse(length(sets), n);
                
                for i = 1 : length(sets)
                    this.Sets(i, sets{i}) = 1;
                end
            end
        end
    end
    
    methods (Access = public)
        Append(this, cllnNew)
        
        objCopy = Copy(this)
        
        display(this, iNumToDisplay)
        
        cllnOut = ElementsOfSizes(this, vectSizes)
        
        gphOut = Graph(this)
        
        i = n(this)
        
        objMaximal = MaximalElements(this)
        
        iNum = NumElts(this)
        
        RemoveElts(this, cllnSets)
        
        RemoveEltsContainedIn(this, cllnSets)
        
        RemoveEltsContaining(this, cllnSets)
        
        cllnComplex = SimplicialComplex(this)
        
        iSize = Size(this)
        
        varRet = subsref(this, S)
        
        mtxSets = ToMatrix(this)
        
        cellSubsets = ToSubsets(this)
    end
end