classdef Channels
    % Description:
    %    A class containing static methods representing channels.
    % Static Methods:
    %    BAC
    %    BSC
    
    methods (Static)
        cllnReceived = BAC(cllnSent, p, q)
        
        cllnReceived = BSC(cllnSent, p)
    end
end