function [ap] = compute_ap(ranking)
    count = 0;
    ap = 0;
    for i = 1:1:size(ranking, 1)
        if ranking(i, 1) == 1
           count = count + 1;
           ap = ap + (count/i);
        end

    end
    ap = ap/count;
end

