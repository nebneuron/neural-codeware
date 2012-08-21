classdef Code < handle
    % Description:
    %    <None>
    % Properties:
    %    Words
    %    Metric
    % Methods:
    %    CodeComplex
    %    Decode  
    %    DecodeMAP
    %    Distance
    %    Graph   
    %    CodewordGraph
    %    Length  
    %    RandomSample
    %    Rate    
    %    SetDistribution
    %    SetMetric
    %    Shuffle 
    %    Size    
    %    Sparsity
    %    ToMatrix
    % Static Methods
    %    NordstromRobinson
    %    Random   
    %    RandomConstantWeight
    %    ShiftCode
    
    
    properties (GetAccess = public, SetAccess = protected)
        Words
        Metric
    end
    
    properties (GetAccess = public, SetAccess = protected)
        Distribution
    end
    
    methods (Access = public)
        function obj = Code(words, cvDistribution)
            if isa(words, 'Collection')
                obj.Words = words.Copy();
            else
                obj.Words = Collection(words);
            end
            
            if nargin < 2
                cvDistribution = ones(obj.Words.Size(), 1);
            end
            
            obj.Metric = Code.HammingDist;
            obj.SetDistribution(cvDistribution);
        end
    end
    
    methods (Access = public)
        cpx = CodeComplex(this)
        
        cllnDecoded = Decode(this, clln)
        
        cllnDecoded = DecodeMAP(this, clln)
        
        d = Distance(this, x, y)
        
        gph = Graph(this)
        
        gph = CodewordGraph(this, tol)
        
        iLength = Length(this)
        
        cllnRand = RandomSample(this, iSize)
        
        r = Rate(this)
        
        SetDistribution(this, cvDistribution)
        
        SetMetric(this, fcnHandle)
        
        codeNew = Shuffle(this)
        
        iSize = Size(this)
        
        s = Sparsity(this)
        
        mtx = ToMatrix(this)
    end
    
    properties (Constant)
        HammingDist = @(u, v) nnz(xor(u, v));
        
        AsymmetricDist = @(u, v) max(nnz(and(u, 1 - v)), ...
                                     nnz(and(1 - u, v)));
    end
    
    methods (Static)
        obj = NordstromRobinson()
        
        obj = Random(iLength, iNumWords, fSparsity)
        
        obj = RandomConstantWeight(iLength, iNumWords, iWeight)
        
        obj = ShiftCode(n, k)
    end
end