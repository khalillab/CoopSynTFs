function KL = KLgen(Data,Ideal)

    % Normalize Distributions
    P = Ideal/sum(Ideal);
    Q = Data/sum(Data);

    % Remove indices where P=0 to avoid -Inf
    ind = find(P==0);
    P(ind) = [];
    Q(ind) = [];

    % Remove indices where P=0 to avoid -Inf
    ind = find(Q==0);
    P(ind) = [];
    Q(ind) = [];
    
    % Calculate KL
    KL = sum(P.*log2(P./Q));

end