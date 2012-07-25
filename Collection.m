classdef Collection < handle
    % Description:
    %    A class for storing a collection of subsets.
    % Properties:
    %    property
    %       desciption
    % Methods:
    %    method
    %       description
    
    properties (GetAccess = public, SetAccess = protected)
        Sets
    end
    
    properties (Dependent = true, SetAccess = private)
        Size;
        Dimension;
    end
    
    methods
        function iSize = get.Size(this)
            iSize = size(this.Sets, 1);
        end
        
        function iDim = get.Dimension(this)
            %--------------------------------------------------------------------------------
            % Usage:
            %    iDim = obj.Dimension
            % Description:
            %    Retrieve the number of elements on which this collection of subsets
            %    lives.  That is, each element of the given `Collection` object is a
            %    subset of the set {1, ..., `iDim`}.
            %--------------------------------------------------------------------------------
            
            iDim = size(this.Sets, 2);
        end
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
        
        function objMaximal = MaximalElements(this)
            %--------------------------------------------------------------------------------
            % Usage:
            %    objMaximal = obj.MaximalElements()
            % Description:
            %    Return a `Collection` of the maximal elements (under subset inclusion)
            %    of a `Collection` object.
            %--------------------------------------------------------------------------------
            
            % This needs to be made sippier and more memory efficient for, for
            % instance, the case that we are finding the maximal elements of a full
            % SimplicialComplex.  Use this comment for ideas.
            % 
            % The elements of maximum size are always maximal.  We can identify those
            % elements at low cost and then continue a search on the remaining
            % elements.
            % 
            % Using those maximal elements found above, we can use the algorithm below
            % (or some modification thereof) to reduce the search, specifically
            % eliminating those elements that are subsets of maximum elements.
            % 
            % We can then iterate the above process on the reduced collection.  Will
            % this be at all efficient?  That's unclear.  The overall time-complexity
            % is likely the same, but the amount of computation is likely reduced
            % (provided that the maximum sets are supersets of other many other sets).
            % Unfortunately, that doesn't actually mean that this method will be faster
            % since it involves a loop, which is slow in Matlab.
            
            % Initialize the matrix of sets remaining to be searched to be the entire
            % list of sets.  Initilize the matrix of maximal elements to be empty.
            mtxRemaining = this.ToMatrix();
            mtxMaximal = zeros(0, this.Dimension);
            
            while (~isempty(mtxRemaining))
                % Find the maximum sets among those remaining.
                cvEltOrders = sum(mtxRemaining, 2);
                cvMaximum = (cvEltOrders == max(cvEltOrders));
                
                % Use the element orders just found to extract the maximum elements into
                % the list of maximum sets (among those remaining) and append them to the
                % list of maximal sets.  Also, remove the newly-found maximal sets from the
                % list of remaining sets to search.
                mtxMaximumRemaining = mtxRemaining(cvMaximum, :);
                mtxMaximal = [mtxMaximal; mtxMaximumRemaining];
                mtxRemaining(cvMaximum, :) = [];
                
                % Since these collections are stored as matrice of zeros and ones, the size
                % of the pairwise intersections of their sets can be computed by the
                % following multiplication.
                mtxNumEltsInCommon = mtxRemaining * mtxMaximumRemaining.';

                % If there is more than one entry in a row of the matrix we just found
                % whose value is the size of the set corresponding to that row, then the
                % corresponding set must not be maximal; remove these sets from
                % `mtxRemaining`.  This is the pruning step that will (I hope) save time.
                % And, yes, in my tests, computing an outer-product was actually
                % significantly faster than using `repmat` in creating `mtxEltOrders`.
                mtxEltOrders = sum(mtxRemaining, 2) * ones(1, size(mtxNumEltsInCommon, 2));
                mtxRemaining(sum(mtxNumEltsInCommon == mtxEltOrders, 2) > 1, :) = [];
            end
            
            % Return the maximal sets as a `Collection` object.
            objMaximal = Collection(mtxMaximal);
            
            
            
            
            % Keep the old code for reference (in case the above algorithm is slower).
            % 
            % % Since this collection is stored as a matrix of zeros and ones, the size
            % % of the pairwise intersections of its sets can be computed by the
            % % following multiplication.
            % mtxNumEltsInCommon = this.Sets * this.Sets.';
            % 
            % % If there is exactly one entry in a row  of the matrix we just found whose
            % % value is the size of the set corresponding to that row, then the
            % % corresponding set must be maximal; otherwise, the corresponding set is
            % % not maximal.  Yes, in my tests, computing an outer-product was actually
            % % faster than using `repmat`.
            % tmp = diag(mtxNumEltsInCommon) * ones(1, this.Size);
            % cvMaximalIndices = (sum(mtxNumEltsInCommon == tmp, 2) == 1);
            % 
            % % Extract the maximal sets from this collection.  This `subsref` notation
            % % has to be used since we do not want to call the built-in indexing method.
            % tmp = this.ToMatrix();
            % objMaximal = Collection(tmp(cvMaximalIndices, :));
            % % objMaximal = this.subsref(substruct('()', {cvMaximalIndices}));
            
            
            
            % Even older code (more memory efficient but slower).
            % 
            % disp(size(this.Sets));
            % 
            % % We will keep track of the indices of the generating elements that are
            % % facets.
            % cvMaximalEltIndices = false(this.Size, 1);
            % 
            % % Since the sets are stored as a matrix of zeros and ones, the size of the
            % % intersection sets the set elements can be computed by the following
            % % multiplication.
            % mtxEltsInCommon = this.Sets * this.Sets.';
            % 
            % % Loop through the elements of the generating set.
            % for ii = (1 : this.Size)
            %     % The size of the current set.
            %     iSetSize = mtxEltsInCommon(ii, ii);
            % 
            %     % If there is exactly one entry in row `ii` whose value is the size of the
            %     % current set, then this set must be maximal; otherwise, it is not.
            %     if (length(find(mtxEltsInCommon(ii, :) == iSetSize)) == 1)
            %         cvMaximalEltIndices(ii) = true;
            %     end
            % end
            % 
            % % Extract the facets from the generating set.
            % tmp = this.ToMatrix();
            % objMaximal = Collection(tmp(cvMaximalEltIndices, :));
        end
        
        function mtxSets = ToMatrix(this)
            %--------------------------------------------------------------------------------
            % Usage:
            %    mtxSets = obj.ToMatrix()
            % Description:
            %    Return a (sparse) binary matrix representation of a set.  Entry (i, j)
            %    of the returned matrix will be 1 if set i contains element j and will
            %    be 0 otherwise.
            %--------------------------------------------------------------------------------
            
            mtxSets = this.Sets;
        end
        
        function varDummy = Append(this, objNew)
            %--------------------------------------------------------------------------------
            % Usage:
            %    obj.Append(objNew)
            % Description:
            %    Appends the argument to the calling object.
            % Arguments:
            %    objNew
            %       A `Collection` object of the same dimension as the calling object.
            % Note:
            %    Technically, this returns an empty array `[]`.  The reason for this is
            %    a complication with overriding the `subsref` method.
            %--------------------------------------------------------------------------------
            varDummy = [];
            
            if (this.Dimension ~= objNew.Dimension)
                error('The dimension of the `Collection` objects must agree.');
            end
            
            this.Sets = [this.Sets; objNew.Sets];
        end
        
        function varDummy = RemoveEltsContaining(this, objSets)
            %--------------------------------------------------------------------------------
            % Usage:
            %    obj.RemoveEltsContaining(objSets)
            % Description:
            %    Removes all elements of the calling object that are supersets of any
            %    of the elements of the given collection.
            % Arguments:
            %    objSets
            %       A `Collection` object of the same dimension as the calling object.
            % Note:
            %    Technically, this returns an empty array `[]`.  The reason for this is
            %    a complication with overriding the `subsref` method.
            %--------------------------------------------------------------------------------
            varDummy = [];
            
            assert(this.Dimension == objSets.Dimension, ...
                '`Collection` objects must have the same dimension');
            
            % Retrieve the matrices corresponding to the sets.
            mtxThis = this.ToMatrix();
            mtxToRemove = objSets.ToMatrix();
            
            % This product computes the size of the pairwise intersections of the
            % calling object's elements with the elements to be removed.
            mtxNumEltsInCommon = mtxThis * mtxToRemove.';
            
            % Build a matrix whose columns are constant-valued; more specifically,
            % column `i` of the matrix contains (in each entry) the weight of the
            % element `i` of `objSets`.
            mtxNumEltsPerSet = ones(this.Size, 1) * sum(mtxToRemove, 2).';
            
            % Now, if |A \cap B| is equal to |B| for an element A of `this` and an
            % element B of `objSets`, then B is a subset of A.  In this case, we want
            % to remove A from `this`.
            mtxThis(any(mtxNumEltsInCommon == mtxNumEltsPerSet, 2), :) = [];
            
            % Set the generators in this object to be the unique elements of `mtxThis`.
            this.Sets = mtxThis;
        end
        
        function objCopy = Copy(this)
            objCopy = Collection(this.Sets);
        end
        
        function varRet = subsref(this, S)
            switch S(1).type
                case '.'
%                     if nargout > 0
                        varRet = builtin('subsref', this, S);
%                     else
%                         builtin('subsref', this, S);
%                     end
                case '()'
                    if (length(S(1)) < 2)
                        if (length(S(1).subs) ~= 1)
                            error('Exactly one index must be provided.');
                        end
                        
                        if (length(S(1).subs{1}) == 1)
                            varRet = this.Sets(S(1).subs{1}, :);
                        else
                            varRet = Collection(this.Sets(S(1).subs{1}, :));
                        end
                        
                        return;
                    else
                        varRet = builtin('subsref', this, S);
                    end
                case '{}'
                    varRet = builtin('subsref', this, S);
            end
        end
    end
end