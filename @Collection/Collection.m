classdef Collection < handle
    % Description:
    %    A class for storing a collection of subsets.
    % Properties:
    %    Sets
    % Methods:
    %    Append
    %    Copy
    %    Dimension
    %    display
    %    Graph
    %    MaximalElements
    %    RemoveEltsContaining
    %    Size
    %    subsref
    %    ToMatrix
    %    ToSubsets
    
    properties (GetAccess = public, SetAccess = protected)
        Sets
    end
    
    methods (Access = public)
        function this = Collection(mtxSet)
            %--------------------------------------------------------------------------------
            % Usage:
            %    obj = Collection(mtxSet)
            % Description:
            %    Constructs a `Collection` object.
            % Arguments:
            %    mtxSet
            %       A nonempty matrix whose columns correspond to vertices and whose
            %       rows correspond to subsets of columns.  If entry (i, j) is nonzero,
            %       then set i contains vertex j; that is, each row is the indicator
            %       vector of some set.
            %       NOTE: No checking is done to ensure that the rows of the input
            %       matrix are unique; hence, the resulting object is allowed to
            %       contain duplicate sets.  However, all-zero rows are removed.
            %--------------------------------------------------------------------------------

            % this.Sets = spones(mtxSet(any(mtxSet, 2), :));
            this.Sets = spones(mtxSet);
        end
    end
    
    methods (Access = public)
        varDummy = Append(this, cllnNew)
        
        objCopy = Copy(this)
        
        iDim = Dimension(this)
        
        display(this, iNumToDisplay)
        
        gphOut = Graph(this)
        
        objMaximal = MaximalElements(this)
        
        varDummy = RemoveEltsContaining(this, cllnSets)
        
        iSize = Size(this)
        
        varRet = subsref(this, S)
        
        mtxSets = ToMatrix(this)
        
        cellSubsets = ToSubsets(this)
    end
end