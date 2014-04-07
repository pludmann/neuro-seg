function affichage(signal, varargin)
    p = inputParser;
    
    p.FunctionName = 'affichage';
    p.addRequired('signal',@(x) ischar(x) && not(isequal(strfind(x,'.mat'),{[]})));
    p.addParamValue('smoothDiff',false, @(x) islogical(x));
    p.addParamValue('smoothMethod','moving',@(x) ischar(x));
    p.addParamValue('smoothSpan',5,@(x) isnumeric(x));
    
    parse(p,signal,varargin{:});
    v = p.Results.smoothDiff;
    span = p.Results.smoothSpan;
    method = p.Results.smoothMethod;
    
    load(signal);
    n = length(L)-2;
    p = length(M(:,3));
    
    figure;
    if (n <= 4)
        for k = 1:n
            subplot(2,2,k)
            plot(M(:,1),M(:,k+2));
            title(L(k+2));
        end
    else
        if (not(isequal(strfind(L(n+2),'batterie'), {[]})))
            n = n-2;
            for k = 1:n
                subplot(3,3,k)
                plot(M(:,1),M(:,k+2));
                title(L(k+2));
            end
        else
            for k = 1:n
                subplot(3,3,k)
                plot(M(:,1),M(:,k+2));
                title(L(k+2));
            end
        end
    end
    
    if (v)
        figure;
        N = zeros(p,n);
        u = zeros(p-1,n);
        N(:,1) = M(:,1);
        N(:,2) = M(:,2);
        u(:,1) = M(2:p,1);
        u(:,2) = M(2:p,2);
        for k = 1:n
            N(:,k+2) = smooth(M(:,k+2),20,'moving');
            for j = 1:(p-1)
                u(j,k+2) = (N(j+1,k+2) - N(j,k+2))/(N(j+1,1) - N(j,1));
            end
        end
        
        if (n <= 4)
            for k = 1:n
                subplot(2,2,k)
                plot(u(:,1),u(:,k+2));
                title(['Dérivée de la lissée de ',L(k+2)]);
            end
        else
            if (not(isequal(strfind(L(n+2),'batterie'), {[]})))
                n = n-2;
                for k = 1:n
                    subplot(3,3,k)
                    plot(u(:,1),u(:,k+2));
                    title(['Dérivée de la lissée de ',L(k+2)]);
                end
            else
                for k = 1:n
                    subplot(3,3,k)
                    plot(u(:,1),u(:,k+2));
                    title(['Dérivée de la lissée de ',L(k+2)]);
                end
            end
        end 
    end  
end