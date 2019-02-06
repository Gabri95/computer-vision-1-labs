function [best_x] = RANSAC(matches, fa, fb)
    
    % the number of iterations
    N = 50;
    
    % number of matches to consider
    P = 10;
    
    
    len = size(matches, 2);
    best_count = len;
    best_x = [];
    
    for n = 1:1:N
        idx = randperm(len, min(P, len));
        A = zeros(2*P, 6);
        b = zeros(2*P, 1);
        
        for p = 1:1:P
            id = matches(:, idx(p));
            t = fa(1:2, id(1));
            x = t(1);
            y = t(2); 
            t = fb(1:2, id(2));
            xp = t(1);
            yp = t(2);
            A(2*p-1, :) = [x y 0 0 1 0];
            A(2*p, :) = [0 0 x y 0 1];
            b(2*p-1) = xp;
            b(2*p) = yp;
        end
        
        x = pinv(A)*b;
        
        count = 0;
        
        for p = 1:1:P
            id = matches(:, idx(p));
            point = fa(1:2, id(1));
            point_transform = fb(1:2, id(2));
            
            A = [point(1) point(2) 0 0 1 0; 0 0 point(1) point(2) 0 1];
            point_predict = A*x;
            point_distance = norm(point_transform - point_predict);
%             disp("data");
%             disp(point);
%             disp(point_transform);
%             disp(point_predict);
%             disp(point_distance);
            if point_distance >= 10
                count = count + 1;
            end
        end
        
        if count < best_count
            best_count = count;
            best_x = x;
            disp([best_count, "outliers at iter: ", n]);
        end
    end
%     disp("The least number of wrong matches is: ");
%     disp(best_count);
    
end

