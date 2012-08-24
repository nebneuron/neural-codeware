function cllnReceived = BSC(cllnSent, p)
    %---------------------------------------------------------------
    % Usage:
    %    cllnReceived = BAC(cllnSent, p, q)
    % Description:
    %    The transmit a `Collection` across the binary symmetric
    %    channel with the given parameter.
    % Arguments:
    %    cllnSent
    %       A `Collection` to send across the channel.
    %    p
    %       The probability of an individual bit flip.
    %---------------------------------------------------------------

    cllnReceived = Channels.BAC(cllnSent, p, p);
end