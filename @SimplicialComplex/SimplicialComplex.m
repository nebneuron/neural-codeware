classdef SimplicialComplex < handle
    % Description:
    %    <None>
    % Properties:
    %    <None>
    % Methods:
    %    display
    %    FVector
    %    GetFaces
    %    GetFacets
    %    GetGenerators
    %    GetWeights
    %    Graph
    %    HellyCompletion
    %    NumFaces
    %    NumVerts
    %    RemoveFaces
    %    SetWeights
    %    Skeleton
    
    properties (GetAccess = protected, SetAccess = protected)
        Generators;
        GeneratorsAreComplex;
        Faces;
        Facets;
        Weights;
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
            %       whether or not the generating set is the full list of
            %       faces.  Warning: No checking is done to ensure that the
            %       collection of generators is a full complex if this is
            %       `true`. 
            %------------------------------------------------------------
            
            % Ensure that `cllnGenerators` is a collection object.
            if ~isa(cllnGenerators, 'Collection')
                cllnGenerators = Collection(cllnGenerators);
            end
            
            % Ensure that the set of generators is nonempty.
            assert(Size(cllnGenerators) > 0, ...
                'The argument must be a nonempty `Collection`.');
            
            this.Generators = cllnGenerators;
            
            if (nargin == 2)
                assert(isscalar(bIsFullComplex) && islogical(bIsFullComplex), ...
                       'The second argument must be a boolean scalar.');
                
                this.GeneratorsAreComplex = bIsFullComplex;
                
                if (bIsFullComplex)
                    % The generating set is the complete collection of faces.  Here, I'm
                    % copying the generating set just to be careful; but it might be wise to
                    % handle this differently.  Setting the two properties to be the same
                    % object could save some later work and some memory (since `Collection` is
                    % a handle class), but this might require setting a flag to track that this
                    % is the case.
                    this.SetFaces(this.Generators.Copy());
                end
            else
                this.GeneratorsAreComplex = false;
            end
        end
    end
    
    methods (Access = public)
        cvWeights = GetWeights(this)
        
        SetWeights(this, cvWeights)
        
        i = NumFaces(this)
        
        iNum = NumVerts(this)
        
        fvect = FVector(this)
        
        objFacets = GetFacets(this)
        
        cllnFaces = GetFaces(this)
        
        cllnGenerators = GetGenerators(this)
        
        gphOut = Graph(this)
        
        objSkeleton = Skeleton(this, iDimension)
        
        objSkeleton = Skeleton2(this, iDimension)
        
        objCompletion = HellyCompletion(this, iDimension, iMaxFaceDim)
        
        RemoveFaces(this, objFaces)
        
        display(this, iNumToDisplay)
    end
    
    methods (Access = private)
        b = FacesAreGenerated(this)
        
        b = FacetsAreGenerated(this)
        
        SetFacets(this, objFacets)
        
        SetFaces(this, objFacets)
    end
    
    methods (Access = protected)
        GenerateFacets(this)
        
        GenerateFaces(this)
        
        GenerateMinimalNonFaces(this)
    end
end