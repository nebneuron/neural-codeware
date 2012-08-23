classdef Decoders
    % I don't necessarily think that these decoders should just be static functions
    % in some class.  There's probably a better way to organize this.  Also,
    % while parameters such as `p` and `q` are being passed at this time, it
    % might be a better idea to have all of the decoders accept the same
    % arguments, specifically a `Code` object, a `Channel` object, and a
    % `Collection` object containing the words to decode.  If we're to do that,
    % though, there actually needs to be a channel object; the channel class
    % currently just contains some static functions for describing channels.
    methods (Static)
        function cllnDecoded = GaussianML(objCode, cllnToDecode, s1, s0)
            mtxCode = objCode.Words.ToMatrix();
            mtxToDecode = cllnToDecode.ToMatrix();

            iNumToDecode = size(mtxToDecode, 1);
            mtxDecoded = zeros(iNumToDecode, n);
            
            % Setup for ML stuff...
            cvWeights  = sum(mtxCode, 2);
            A = (-1/s1 - 1/s0) * mtxCode + 1/s0;
            B = (1/s1 - 1/s0) * mtxCode + 1/s0;
            u = ((1/s1) .^ cvWeights) .* ((1/s0) .^ (objCode.Length - cvWeights));
            
            % Transmit and decode a codeword 'iNumToDecode' times.
            for ii = (1 : iNumToDecode)
                % Decode the 'i'th received vector using ML.
                C = ones(objCode.Size, 1) * mtxToDecode(ii, :);
                v = sum(-0.5 * (B + C .* A).^2, 2);
                [~, idx]  = max(u .* exp(v));
                mtxDecoded(ii, :) = mtxCode(idx, :);
            end
            
            cllnDecoded = Collection(mtxDecoded);
        end
        
        function cllnDecoded = MAP(objCode, cllnToDecode, p, q)
            % Find the MAP values by scaling the ML values by the codeword
            % distribution.
            mtxCode = objCode.Words.ToMatrix();
                        
            %            p(r | c) p(c)
            % p(c | r) = -------------
            %                p(r)     
            [~, idxs]  = max(...
                bsxfun(@times, ...
                       Decoders.MLProbMatrix(objCode, cllnToDecode, p, q), ...
                       objCode.Distribution'), ...
                2);
            
            cllnDecoded = Collection(mtxCode(idxs, :));
        end
        
        function cllnDecoded = MAPApprox(objCode, cllnToDecode, p, q)
            mtxCode = objCode.Words.ToMatrix();
            mtxToDecode = cllnToDecode.ToMatrix();
            
            % This formula was taken from section 4 of "Combinatorial
            % neural codes from a mathematical coding theory
            % perspective".
            s = objCode.Sparsity();
            a = log2((1 - p) * (1 - q) / (p * q));
            b = log2((1 - p) * (1 - s) / (q * s));
            
            [~, idxs] = max(bsxfun(@minus, ...
                                   a * (mtxToDecode * mtxCode'), ...
                                   b * sum(mtxCode, 2)'), ...
                            2);
            
            cllnDecoded = Collection(mtxCode(idxs, :));
        end
        
        function cllnDecoded = ML(objCode, cllnToDecode, p, q)
            [~, idxs] = max(...
                Decoders.MLProbMatrix(objCode, ...
                                      cllnToDecode, ...
                                      p, ...
                                      q), ...
                2);
            
            mtxCode = objCode.ToMatrix();
            cllnDecoded = Collection(mtxCode(idxs, :));
        end
        
        function mtxProbs = MLProbMatrix(objCode, cllnToDecode, p, q)
            mtxCode = objCode.Words.ToMatrix();
            mtxToDecode = cllnToDecode.ToMatrix();
            
            % This formula was taken from section 4 of "Combinatorial
            % neural codes from a mathematical coding theory
            % perspective".
            a = log2((1 - p) * (1 - q) / (p * q));
            b = log2((1 - p) / q);
            mtxProbs = bsxfun(@minus, ...
                              a * (mtxToDecode * mtxCode'), ...
                              b * sum(mtxCode, 2)');
        end
    end
end