classdef Graph
    % Description:
    %    Class representation of a graph (with vertices and edges).
    % Properties:
    %    property
    %       desciption
    % Methods:
    %    method
    %       description
    
    properties (GetAccess = protected, SetAccess = protected)
        AdjacencyMatrix
    end
    
    methods (Access = public)
        function this = Graph(mtxAdjacency)
            %--------------------------------------------------------------------------
            % Usage:
            %    obj = Graph(mtxAdjacency)
            % Description:
            %    Constructs a `Graph` object (representing an undirected graph).
            % Arguments:
            %    mtxAdjacency
            %       A (symmetric) matrix with non-zero entries indicating edges.  All
            %       non-zero entries are stored as `1`.
            %--------------------------------------------------------------------------
            
            if ~isequal(mtxAdjacency, mtxAdjacency.')
                warning('Custom:Class:Graph:constructor', ...
                    'Adjacency matrix is not symmetric.  Using upper-triangular portion.');
            end
            
            % Blindly convert to a symmetric matrix.
            mtxUpper = triu(mtxAdjacency, 1);
            this.AdjacencyMatrix = spones(mtxUpper + mtxUpper.');
        end
        
        function mtxAdj = ToMatrix(this)
            %--------------------------------------------------------------------------
            % Usage:
            %    mtxAdj = obj.ToMatrix()
            % Description:
            %    Return the adjacency matrix of the calling graph.
            %--------------------------------------------------------------------------
            
            mtxAdj = full(this.AdjacencyMatrix);
        end
        
        function objComplex = CliqueComplex(this, iMaxCliqueSize)
            %--------------------------------------------------------------------------
            % Usage:
            %    objComplex = obj.CliqueComplex(iMaxCliqueSize)
            % Description:
            %    Return the clique complex of this graph as a `SimplicialComplex`
            %    object.
            % Arguments:
            %    iMaxCliqueSize
            %       Return only the cliques up to this size.
            %--------------------------------------------------------------------------
            
            if nargin < 2
                iMaxCliqueSize = this.Size();
            end
            
            objComplex = SimplicialComplex(this.GetCliques(1, iMaxCliqueSize, false));
        end
        
        function cllnCliques = GetCliques(this, iMin, iMax, bMaximal)
            %--------------------------------------------------------------------------
            % Usage:
            %    cllnCliques = obj.GetCliques(iMin, iMax, bMaximal)
            % Description:
            %    Return a `Collection` object containing all cliques within the given
            %    size range in the calling graph.
            % Arguments:
            %    iMin
            %       The minimum size of the cliques to be found.  Must be positive.
            %    iMax
            %       The maximum size of the cliques to be found.  Must be nonnegative.
            %       Set to zero to have no upper bound on clique size.
            %    bMaximal
            %       A boolean (true/false) input that is `true` if only maximal cliques
            %       should be counted and `false` if all cliques are to be counted.
            %--------------------------------------------------------------------------
            
            % This method is not ideal and requires that we do twice the work as what
            % should be required.  Fix it if you have a better algorithm.  The problem
            % is that Cliquer is limited to returning a predetermined maximum number of cliques but
            % we don't have a nice upper bound on the number of cliques (2^n is not
            % nice).
            % IDEA: Set the fifth parameter of `Cliquer.FindAll` to the maximum
            % size of an integer on this platform; this should really probabaly be
            % handled in the MEX file for `Cliquer.FindAll`.
            
            if nargin < 4 || isempty(bMaximal)
                bMaximal = false;
            end
            
            if nargin < 3 || isempty(iMax)
                iMax = 0; % no limit on clique size
            end
            
            if nargin < 2 || isempty(iMin)
                iMin = 1;
            end
            
            iNumCliques = CountCliques(this, iMin, iMax, bMaximal);
            
            [~, mtxCliques] = Cliquer.FindAll(ToMatrix(this), iMin, iMax, bMaximal, iNumCliques);
            
            cllnCliques = Collection(mtxCliques);
        end
        
        function iNum = CountCliques(this, iMin, iMax, bMaximal)
            %--------------------------------------------------------------------------
            % Usage:
            %    iNum = obj.CountCliques(iMin, iMax, bMaximal)
            % Description:
            %    Count the number of the cliques within the given size range in the
            %    calling graph.
            % Arguments:
            %    iMin
            %       The minimum size of the cliques to be found.  Must be positive.
            %    iMax
            %       The maximum size of the cliques to be found.  Must be nonnegative.
            %       Set to zero to have no upper bound on clique size.
            %    bMaximal
            %       A boolean (true/false) input that is `true` if only maximal cliques
            %       should be counted and `false` if all cliques are to be counted.
            %--------------------------------------------------------------------------
            
            if nargin < 4 || isempty(bMaximal)
                bMaximal = false;
            end;
            
            if nargin < 3 || isempty(iMax)
                iMax = 0; % no limit on clique size
            end;
            
            if nargin < 2 || isempty(iMin)
                iMin = 1;
            end;
            
            iMaxNumCliques = 0;
            
            iNum = Cliquer.FindAll(ToMatrix(this), iMin, iMax, bMaximal, iMaxNumCliques);
        end
        
        function gphComp = Complement(this)
            %--------------------------------------------------------------------------
            % Usage:
            %    gphComp = obj.Complement()
            % Description:
            %    Return the complement of the calling graph.
            %--------------------------------------------------------------------------
            
            mtxAdj = ToMatrix(this);
            mtxAdj = 1 - mtxAdj;
            mtxAdj(1 : n+1 : n^2) = 0;
            
            gphComp = Graph(mtxAdj);
        end
        
        function [iVerts, iEdges] = Size(this)
            iVerts = size(this.AdjacencyMatrix, 1);
            iEdges = nnz(this.AdjacencyMatrix) / 2;
        end
    end
    
    methods (Static)
        function gphRand = Random(iSize, fSparsity)
            %--------------------------------------------------------------------------
            % Usage:
            %    gphRand = Graph.Random(iSize, fSparsity)
            % Description:
            %    Create a random graph of the given size and sparsity.
            % Arguments:
            %    iSize
            %       The number of vertices in the returned graph.
            %    fSparsity
            %       A number between 0 and 1.
            %--------------------------------------------------------------------------
            
            assert(0 < fSparsity && fSparsity < 1, ...
                'The given sparsity must be between 0 and 1');
            
            mtxAdj = triu(rand(iSize) < fSparsity, 1);
            mtxAdj = mtxAdj + mtxAdj.';
            
            gphRand = Graph(mtxAdj);
        end
        
        function gphRand = DropCliques(iSize, iCliqueSize, iNumCliques)
            mtxAdj = zeros(iSize);
            
            for i = (1 : iNumCliques)
                rvPerm = randperm(iSize);
                rvClique = rvPerm(1 : iCliqueSize);
                
                mtxAdj(rvClique, rvClique) = 1;
            end
            
            % There are non-zero diagonal entries in this matrix,
            % but we don't need to worry abou them because the
            % graph constructor takes care of this issue.
            gphRand = Graph(mtxAdj);
        end
    end
end