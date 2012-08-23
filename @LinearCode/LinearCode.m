classdef LinearCode < Code
    % Description:
    %    <None>
    % Properties:
    %    <None>
    % Methods
    %    <methods inherited from `Code`>
    %    GeneratorMatrix
    % Static Methods:
    %    GenerateWords
    %    GolayMatrix
    %    HammingMatrix
    %    ReedMullerMatrix
    
    properties (Access = protected)
        GenMtx
    end
    
    methods (Access = public)
        function obj = LinearCode(mtxGenerator)
            cllnWords = LinearCode.GenerateWords(mtxGenerator);
            obj = obj@Code(cllnWords);
            obj.GeneratorMatrix = mtxGenerator;
        end
    end
    
    methods (Access = public)
        mtxAdj = GeneratorMatrix(this)
    end
    
    methods (Static, Access = public)
        cllnWords = GenerateWords(mtxGenerator)
        
        mtxGen = GolayMatrix()
        
        mtxGen = HammingMatrix(r)
        
        mtxGen = ReedMullerMatrix(m, r)
    end
end