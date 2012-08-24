function cllnReceived = BAC(cllnSent, p, q)
    %---------------------------------------------------------------
    % Usage:
    %    cllnReceived = BAC(cllnSent, p, q)
    % Description:
    %    The transmit a `Collection` across the binary asymmetric
    %    channel with the given parameters.
    % Arguments:
    %    cllnSent
    %       A `Collection` to send across the channel.
    %    p
    %       The probability that a zero will flip to a one.
    %    q
    %       The probability that a one will flip to a zero.
    %---------------------------------------------------------------

    mtxSent = ToMatrix(cllnSent);

    cllnReceived = Collection(...
        (rand(size(mtxSent)) < p) .* (~mtxSent) + ...
        (rand(size(mtxSent)) > q) .* mtxSent);
end