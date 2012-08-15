classdef SimplicialComplex < handle
    % SIMPLICIALCOMPLEX Class representation of a simplicial complex.
    %   Include a list of events and public properties and methods. This is a
    %   handle class (an instance is passed by reference, it supports events,
    %   etc.).
    
    % Need to implement public (get/set?) methods.  These will likely include
    % wrapper functions that ensure that things (e.g., the set of maximal
    % faces) aren't regenerated.  Also, include functions that can retrieve the
    % stored data in a variety of formats (e.g., as matrices or 'sets').
    
    properties (GetAccess = protected, SetAccess = protected)
        % This is the set that is passed into the constructor.  Make it
        % final if possible in MATLAB.  Store it as a sparse matrix
        % whose rows are the elements of the generating set and whose
        % columns are the vertices of the complex.
        Generators;
        
        % The collection of simplices.  This will be empty until it is needed, at
        % which point a generating method will be called.
        Faces;
        
        % The collection of facets (maximal faces).  This will be empty until it is
        % needed, at which point a generating method will be called.  This will be
        % stored as a sparse matrix.
        Facets;
        
        Weights;
    end
    
    properties (Dependent = true, Access = protected)
        FacetsAreGenerated;
        FacesAreGenerated;
    end
    
    methods
        function b = get.FacetsAreGenerated(this)
            b = ~isempty(this.Facets);
        end
        
        function b = get.FacesAreGenerated(this)
            b = ~isempty(this.Faces);
        end
    end
    
    methods (Access = public)
        function this = SimplicialComplex(cllnGenerators, bIsFullComplex)
            %------------------------------------------------------------
            % Usage:
            %    obj = SimplicialComplex(setGenerators)
            % Description:
            %    Constructs a `SimplicialComplex` object.
            % Arguments:
            %    cllnGenerators
            %       A nonempty `Collection` object.
            %    bIsFullComplex
            %       A boolean (`true` or `false`) value indicating
            %------------------------------------------------------------
            
            % Ensure that `cllnGenerators` is a collection object.
            if ~isequal(class(cllnGenerators), 'Collection')
                cllnGenerators = Collection(cllnGenerators);
            end
            
            % Ensure that the set of generators is nonempty.
            assert(cllnGenerators.Size > 0, ...
                'The argument must be a nonempty `Collection`.');
            
            this.Generators = cllnGenerators;
            
            if (nargin == 2)
                if (bIsFullComplex)
                    % The generating set is the complete collection of faces.  Here, I'm
                    % copying the generating set just to be careful; but it might be wise to
                    % handle this differently.  Setting the two properties to be the same
                    % object could save some later work and some memory (since `Collection` is
                    % a handle class), but this might require setting a flag to track that this
                    % is the case.
                    this.SetFaces(this.Generators.Copy());
                end
            end
        end
        
        function cvWeights = GetWeights(this)
            cvWeights = this.Weights;
        end
        
        function SetWeights(this, cvWeights)
            assert(this.FacesAreGenerated);
            assert(iscolumn(cvWeights));
            assert(isnumeric(cvWeights));
            assert(this.Faces.Size == length(cvWeights));
            
            this.Weights = cvWeights;
        end
        
        function i = NumFaces(this)
            cllnFaces = GetFaces(this);
            i = cllnFaces.Size;
        end
        
        function iNum = NumVerts(this)
            iNum = Dimension(this.Generators);
        end
        
        function fvect = FVector(this)
            %------------------------------------------------------------
            % Usage:
            %    fvect = obj.FVector()
            % Description:
            %    Compute and return the f-vector of this simplicial complex
            %    (except the zeroth entry).  Specifically, `fvect(i)` is the
            %    number of faces of dimension `i` in this complex.
            %------------------------------------------------------------
            
            fvect = histc(sum(this.GetFaces().ToMatrix(), 2), ...
                          1 : this.NumVerts);
        end
    end
    
    methods
%         function mtxFaces = get.Faces(this)
%             %------------------------------------------------------------
%             % Usage:
%             %    objFaces = obj.Faces()
%             % Description:
%             %    Return the `Collection` of faces of the calling complex.  Generate the
%             %    faces if they have not already been computed.
%             %------------------------------------------------------------
%             
%             if (~this.FacesAreGenerated)
%                 this.GenerateFaces();
%             end
%             
%             mtxFaces = this.Faces;
%         end
        
%         function set.Faces(this, objFaces)
%             % Store the `Collection` of faces.
%             this.Faces = objFaces;
%             
%             % Keep track of the fact that the complete collection faces has been
%             % generated.
%             this.FacesAreGenerated = true;
%         end
        
%         function objFacets = get.Facets(this)
%             %------------------------------------------------------------
%             % Usage:
%             %    objFacets = obj.Facets()
%             % Description:
%             %    Return the `Collection` of facets of the calling complex.  Generate
%             %    the facets if they have not already been computed.
%             %------------------------------------------------------------
%             
%             % If the set of facets has not already been computed, then we need to
%             % generate this set.
%             if (~this.FacetsAreGenerated)
%                 disp('get.Facets');
%                 this.GenerateFacets();
%             end
%             
%             % Return the facets.
%             objFacets = this.Facets;
%         end
        
%         function set.Facets(this, objFacets)
%             % Store the `Collection` of faces.
%             this.Facets = objFacets;
%             
%             % Keep track of the fact that the complete collection faces has been
%             % generated.
%             this.FacetsAreGenerated = true;
%         end
    end
    
    methods (Access = private)
        function SetFacets(this, objFacets)
            % Store the `Collection` of faces.
            this.Facets = objFacets;
            
%             % Keep track of the fact that the complete collection faces has been
%             % generated.
%             this.FacetsAreGenerated = true;
        end
        
        function SetFaces(this, objFacets)
            % Store the `Collection` of faces.
            this.Faces = objFacets;
            
%             % Keep track of the fact that the complete collection faces has been
%             % generated.
%             this.FacesAreGenerated = true;
        end
    end
    
    methods (Access = public)
        function objFacets = GetFacets(this)
            %------------------------------------------------------------
            % Usage:
            %    objFacets = obj.GetFacets()
            % Description:
            %    Retrieve the facets (maximal faces) of the calling object. Compute the
            %    facets if they have not already been computed.
            % Return values:
            %    objFacets
            %       A `Collection` containing the facets of the calling object.
            %------------------------------------------------------------
            
            % If the set of facets has not already been computed, then we
            % need to generate this set.
            if (~this.FacetsAreGenerated)
                this.GenerateFacets();
            end
            
            % Return the facets.
            objFacets = this.Facets;
        end
        
        function cllnFaces = GetFaces(this)
            %------------------------------------------------------------
            % Usage:
            %    cllnFaces = obj.GetFaces()
            % Description:
            %    Return the `Collection` of faces of the calling complex.  Generate the
            %    faces if they have not already been computed.
            %------------------------------------------------------------
            
            if (~this.FacesAreGenerated)
                this.GenerateFaces();
            end
            
            cllnFaces = this.Faces;
        end
        
        function cllnGenerators = GetGenerators(this)
            %------------------------------------------------------------
            % Usage:
            %    cllnGenerators = obj.GetGenerators()
            % Description:
            %    Retrieve the generating set of the given object.
            % Return values:
            %    cllnGenerators
            %       A `Collection` containing the generators of the calling object.
            %------------------------------------------------------------
            
            % Just return the stored generating set.
            cllnGenerators = this.Generators;
        end
        
        function gphOut = Graph(this)
            %------------------------------------------------------------
            % Usage:
            %    gphOut = obj.Graph()
            % Description:
            %    Retrieve the underlying graph of this simplicial complex.
            % Return values:
            %    gphOut
            %       A `Graph` whose edges correspond to the 1-faces of the calling
            %       complex.  (This is just the 1-skeleton as a `Graph`.)
            %------------------------------------------------------------
            
            mtxFacets = this.GetFacets().ToMatrix();
            gphOut = Graph(mtxFacets' * mtxFacets > 0);
        end
        
        function objSkeleton = Skeleton(this, iDimension)
            %------------------------------------------------------------
            % Usage:
            %    objSkeleton = obj.Skeleton(iDimension)
            % Description:
            %    Returns a `SimplicialComplex` object that contains a k-skeleton of the
            %    calling object.
            % Arguments:
            %    iDimension
            %       The dimension of the skeleton to be returned.  The returned object
            %       will contain all of the faces of the calling object that have
            %       dimension less than or equal to this parameter.
            % Note:
            %    This algorithm is not optimized and could likely be improved if speed
            %    is important.  Preallocation of memory is one potential point of
            %    improvement.  Additionally, other algorithms could be significantly
            %    better.
            %    
            %    This does not yet implement the improved algorithm for computing the
            %    1-skeleton by using matrix multiplication (something like
            %    `this.GetFacets()' * this.GetFacets()` to get an adjacency matrix).
            %------------------------------------------------------------
            
            if (iDimension == 1 && ~this.FacesAreGenerated)
                % I'm sure this could be cleaned up.  We're just testing...
                mtxAdj = this.Graph().AdjacencyMatrix;
                mtxGens = zeros(nnz(mtxAdj) / 2, this.NumVerts);
                
                % This should be explained well in the process of cleaning this up.  Also,
                % if this can be 'vectorized', then it should be; but I couldn't get it to
                % work in the time that I spent on it.
                [I, J] = find(triu(mtxAdj));
                
                for ii = (1 : length(I))
                    mtxGens(ii, [I(ii), J(ii)]) = 1;
                end
                
                % The method above will not pick up vertices that are maximal faces (since
                % these vertices are not adjacent to anybody in the corresponding graph).
                % Add these vertices (in fact, all vertices) to the list of generators
                % here.
                mtxGens = [mtxGens; diag(any(this.Generators.ToMatrix(), 1))];
                
                objSkeleton = SimplicialComplex(Collection(mtxGens));
            else
                cvFaceDimensions = sum(this.GetFaces().ToMatrix(), 2) - 1;
                objFaces = this.GetFaces();
                objSkeleton = SimplicialComplex(objFaces(cvFaceDimensions <= iDimension));
            end
        end
        
        function objSkeleton = Skeleton2(this, iDimension)
            % This is a different algorithm for constructing skeletons.  Should we
            % choose this algorithm over the other, the help-doc for the other function
            % can be placed here verbatim (after the `2` is removed from this
            % function's name, of course).  Both algorithms remain for the moment for
            % testing purposes.
            % 
            % This algorithm seems to be faster on the first call, and the other
            % algorithm seems to be faster on subsequent calls (regardless of the
            % dimension used in either call).  More testing should probably be done.
            
            % This matrix will hold the generators for the skeleton being constructed.
            % NOTE: Counting the number of generators for the skeleton and
            % preallocating here would probably be a big speed improvement.
            mtxNewGens = zeros(0, this.NumVerts);
            
            objFacets = this.GetFacets();
            
            % Loop through the facets of this complex.
            for ii = (1 : this.GetFacets().Size)
                % Retrieve the current facet.
                rvCurrFacet = objFacets(ii).ToMatrix();
                
                % If the dimension of this facet is at most `iDimension`, then just add
                % this facet to the skeleton's generating set; note that this is the case
                % if the number of vertices in this facet is at most `iDimension + 1`.
                % Otherwise...
                if (sum(rvCurrFacet) <= iDimension + 1)
                    mtxNewGens = [mtxNewGens; rvCurrFacet];
                else
                    % ...we need to build the list of all faces of this facet that are of
                    % dimension `iDimension` and append that list to the list of generators.
                    
                    mtxNewGens = [mtxNewGens; ...
                        Utils.SubsetsOfSize(rvCurrFacet, iDimension + 1)];
                end
            end
            
            % Use the generators to create the simplicial complex for this skeleton.
            objSkeleton = SimplicialComplex(Collection(unique(mtxNewGens, 'rows')));
        end
        
        function objCompletion = HellyCompletion(this, iDimension, iMaxFaceDim)
            %------------------------------------------------------------
            % Usage:
            %    objCompletion = obj.HellyCompletion(iDimension, iMaxFaceDim)
            % Description:
            %    Returns a `SimplicialComplex` object that contains a Helly
            %    k-completion of the calling object.
            % Arguments:
            %    iDimension
            %       The dimension of the Helly completion to be returned.
            %    iMaxFaceDim
            %       The maximum dimension of the faces to be included in the completion
            %       to be returned.
            % To-do:
            %    Do input checking/parsing.
            %------------------------------------------------------------
            
            if nargin < 3
                iMaxFaceDim = this.NumVerts - 1;
            end
            
            % Initialize the Helly completion to be the clique complex (which is a
            % super-complex of the Helly completion).
            objCompletion = CliqueComplex(Graph(this), iMaxFaceDim + 1);
            
            % If `iDimension` is `1`, then we are done; otherwise, we must do some
            % pruning.
            if (iDimension ~= 1)
                % Get the `iDimension`-skeleton.
                objSkeleton = this.Skeleton(iDimension);
                
                % Find the faces of the given dimension in the clique complex that are not
                % in the generated skeleton.
                % 
                % For now, retrieve the matrix representations of the two complexes to work
                % with; perhaps change this in the future.  In fact, most of this
                % functionality should probably be wrapped into methods in
                % `SimplicialComplex` (and possibly `Collection`).
                mtxCompletionFaces = objCompletion.GetFaces().ToMatrix();
                mtxSkeletonFaces = objSkeleton.GetFaces().ToMatrix();
                
                % Remove all faces of dimension greater than `iDimension`.
                mtxCompletionFaces = mtxCompletionFaces(sum(mtxCompletionFaces, 2) <= iDimension + 1, :);
                mtxSkeletonFaces = mtxSkeletonFaces(sum(mtxSkeletonFaces, 2) <= iDimension + 1, :);
                
                % Find the faces (of the given dimension) of the clique complex that are
                % empty faces in the skeleton.
                mtxEmptyFaces = setdiff(mtxCompletionFaces, mtxSkeletonFaces, 'rows');
                
                % Remove all faces of the clique complex that contain any of the empty
                % faces found above.
                objCompletion.RemoveFaces(Collection(mtxEmptyFaces));
            end
        end
        
        function RemoveFaces(this, objFaces)
            %------------------------------------------------------------
            % Usage:
            %    obj.RemoveFaces(objFacesToRemove)
            % Description:
            %    Remove the given faces from the calling object.  To ensure that the
            %    calling object remains a simplicial complex, all faces that contain
            %    any of the given faces are also removed from the calling object.
            % Arguments:
            %    objFaces
            %       A `Collection` of the faces to be removed from the calling object.
            %------------------------------------------------------------
            
            % This is a bit tricky: We have several potential things to modify, but we
            % don't want to do more work than is necessary.  For instance, if the list
            % of all faces has been computed, then we want to remove the appropriate
            % faces from that list; however, if the list of all faces has not been
            % computed, then we do not want to do the extra work of (accidentally)
            % computing the list (which may not be needed).
            
            % One thing that we always want to do is remove the appropriate faces from
            % the set of generators.  Do so here.
            this.Generators.RemoveEltsContaining(objFaces);
            
            % The collection of facets may not have been generated.  I believe,
            % however, that computing this is fairly fast.  Hence, a choice or two has
            % to be made: Do we remove faces from the collection of facets?  What if
            % the collection of facets has not been generated?  Do we blindly
            % regenerate the facets instead of removing faces?  Likely, the right ting
            % to do is to set a private member variable that tracks whether or not the
            % collection of facets is up-to-date.  Still, even with that feature, the
            % question remains about whether it is faster to regenerate the collection
            % of facets or to remove faces from the (potentially) existing collection
            % of facets.
            if (this.FacetsAreGenerated)
                this.Facets.RemoveEltsContaining(objFaces);
            end
            
            % The list of faces, however, is quite expensive to compute.  I believe,
            % therefore, that removing faces from an existing collection will be
            % significantly faster (in general) than recomputing the collection of
            % faces.  But we do not want to generate the collection of faces if it has
            % not been generated already (since this process is expensive).
            if (this.FacesAreGenerated)
                this.GetFaces().RemoveEltsContaining(objFaces);
            end
        end
        
        function display(this, iNumToDisplay)
            if nargin < 2
                iNumToDisplay = 20;
            end
            
            disp(' ');
            disp([inputname(1),' = ']);
            disp(' ');
            
            disp(['   `SimiplicialComplex` object on ' num2str(NumVerts(this)) ...
                  ' vertices with generating set...']);
            
            for i = 1 : min(iNumToDisplay, Size(this.Generators))
                disp(['      ' num2str(find(this.Generators.Sets(i, :)))]);
            end
            
            disp(' ');
            
            if iNumToDisplay < Size(this.Generators)
                disp(['   ...displaying ' num2str(iNumToDisplay) ' of ' ...
                      num2str(Size(this)) ' generators.']);
                
                disp(' ');
            end
        end
    end
    
    methods (Access = protected)
        function GenerateFacets(this)
            % Generate the facets (maximal faces).  This is a protected function so
            % that the user doesn't accidentally regenerate the set of maximal faces.
            this.SetFacets(this.Generators.MaximalElements());
        end
        
        function GenerateFaces(this)
            %------------------------------------------------------------
            % Usage:
            %    obj.GenerateFaces()
            % Description:
            %    Generate the complete matrix of faces.  This is a protected method so
            %    that the user doesn't accidentally regenerate this set.
            % Note:
            %    The algorithm used here is very naive.  It simply generates all
            %    subsets of each facet and unions these sets together.  This is quite
            %    slow, and memory efficiency is probably worse.
            %------------------------------------------------------------
            
            % Retrieve a matrix representation of the facets.
            mtxFacets = this.GetFacets().ToMatrix();
            
            % Create the initial list of faces to be the empty list.  If we find a
            % quick way to compute the number of faces without having to find all of
            % the faces, then preallocating here could be a good idea.  For now, we can
            % bound the number of faces; use this bound and keep track of the number of
            % faces as they're generated.
            iNumFacesBound = sum(2.^sum(mtxFacets, 2));
            iNumFaces = 0;
            mtxFaces = zeros(iNumFacesBound, this.NumVerts);
        
            for ii = (1 : this.GetFacets().Size)
                % Get the matrix of subsets of this facet.
                mtxSubsets = Utils.SubsetsOf(mtxFacets(ii, :));
                
                % Append the subsets of this facet to the list of faces.
                mtxFaces((iNumFaces + 1 : iNumFaces + size(mtxSubsets, 1)), :) = mtxSubsets;
                
                % Increment the number of faces.
                iNumFaces = iNumFaces + size(mtxSubsets, 1);
            end
            
            % Keep only the unique faces.
            this.SetFaces(Collection(unique(mtxFaces((1 : iNumFaces), :), 'rows')));
            
            % The old method.  It's slow.
            % 
            % % Retrieve a matrix representation of the facets.
            % mtxFacets = this.GetFacets().ToMatrix();
            % 
            % % Create the initial list of faces to be the empty list.  If we find a
            % % quick way to compute the number of faces without having to find all of
            % % the faces, then preallocating here could be a good idea.
            % mtxFaces = zeros(0, this.NumVerts);
            % 
            % for ii = (1 : this.GetFacets().Size)
            %     % Append the subsets of this facet to the list of faces.
            %     mtxFaces = [mtxFaces; Utils.SubsetsOf(mtxFacets(ii, :))];
            % end
            % 
            % % Keep only the unique faces.
            % this.SetFaces(Collection(unique(mtxFaces, 'rows')));
        end
        
        % FROM THE SAGE REFERENCE FOR SimplicialComplex.minimal_nonfaces().
        % SEE http://www.sagemath.org/doc/reference/sage/homology/simplicial_complex.html
        % ALSO http://uw.sagenb.org/src/homology/simplicial_complex.py
        %
        % Algorithm: first take the complement (within the vertex set) of each
        % facet, obtaining a set (f_1, f_2, ...) of simplices. Now form the set of
        % all simplices of the form (v_1, v_2, ...) where vertex v_i is in face
        % f_i. This set will contain the minimal nonfaces and may contain some
        % non-minimal nonfaces also, so loop through the set to find the minimal
        % ones. (The last two steps are taken care of by the _transpose_simplices
        % routine.)
        function GenerateMinimalNonFaces(this)
            A = ~this.Facets.ToMatrix();
            
            answer = [];
            
            if size(A, 1) == 1
                iNumSimplices = nnz(A);
                iNumVerts = size(A, 2);
                answer = zeros(iNumSimplices, iNumVerts);
                answer(sub2ind([iNumSimplices, iNumVerts], ...
                               1 : iNumSimplices, ...
                               find(A))) ...
                    = 1;
            elseif size(A, 1) > 1
                face = A(1, :);
                rest = A(2 : end, :);
                
                new_simplices = zeros(0, size(A, 2));
                
                for v = find(face)
                    
                end
            end
        end
        
        % THE SAGE CODE FOR THE ABOVE FUNCTION WHERE `simplices` is `A`.
        % 
        % answer = []
        % if len(simplices) == 1:
        %     answer = [Simplex((v,)) for v in simplices[0]]
        % elif len(simplices) > 1:
        %     face = simplices[0]
        %     rest = simplices[1:]
        %     new_simplices = []
        %     for v in face:
        %         for partial in self._transpose_simplices(*rest):
        %             if v not in partial:
        %                 L = [v] + list(partial)
        %                 L.sort()
        %                 simplex = Simplex(L)
        %             else:
        %                 simplex = partial
        %             add_simplex = True
        %             simplices_to_delete = []
        %             for already in answer:
        %                 if add_simplex:
        %                     if already.is_face(simplex):
        %                         add_simplex = False
        %                     if add_simplex and simplex.is_face(already):
        %                         simplices_to_delete.append(already)
        %             if add_simplex:
        %                 answer.append(simplex)
        %             for x in simplices_to_delete:
        %                 answer.remove(x)
        % return answer
    end
end