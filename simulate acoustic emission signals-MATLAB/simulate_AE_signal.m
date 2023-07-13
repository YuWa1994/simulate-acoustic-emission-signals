function [y, t] = simulate_AE_signal(varargin)
% reference: Simulation of AE signals and signal analysis systems    
% f: frequency
% L: length
% ti: time of AE occurrence
% tau: characteristic decay time of AE signal
% v: amplitude

    p = inputParser;
    addParameter(p, 'f', 1000)
    addParameter(p, 'L', 1000)
    addParameter(p, 'N', 50) % control the number of AE burst
    addParameter(p, 'k', -1) % determine the interval between ti 
    addParameter(p, 'ti', 'random') % time of AE occurrence
    addParameter(p, 'tau', 'random') % tau/L < 5*num_burst
    addParameter(p, 'v', 'random')
    addParameter(p, 'b', 1.4)
    addParameter(p, 'V_0', 0.1)    
    addParameter(p, 'is_add_noise', 'False') 
    parse(p, varargin{:})

    f = p.Results.f;
    L = p.Results.L;
    N = p.Results.N;
    ti = p.Results.ti;
    k = p.Results.k;   
    tau = p.Results.tau;
    v = p.Results.v;
    b = p.Results.b;
    V_0 = p.Results.V_0;    

    n = f*L;
    t = 0 : 1/f : L-1/f;
    if strcmp(ti, 'random')
        r = randperm(n);
        if k >= 0
            ri = 1: ceil(k): n;
            r = randperm(length(ri));
            r = ri(r);
        end
        ti = sort(r(1:N), 'ascend');
    end    

    if strcmp(tau, 'random')
        max_tau = L/(2*N);   % 5
        tau = unifrnd(1, max_tau, 1, N);
    end
    
    if strcmp(v, 'random')
        v = unifrnd(0,1, 1, N);
    end    
    
    y = zeros(1, f*L);
    for j = 1:N
        [yj, ~] = simulate_one_AE_signal('f', f,...
                                        'L', L,...
                                        'ti', ti(j),...
                                        'tau', tau(j),...
                                        'v', v(j));
        pj = P_V(v(j), V_0, b);
        aj = get_aj(pj);
        y = y + pj * aj * yj;
    end
    
    if strcmp(p.Results.is_add_noise, 'True')
        noise = wgn(1,n,1);
        y = y + 0.1*max(y) * noise;
    end
end

function aj = get_aj(p)
% generate random number for AE bursts
    cj = unifrnd(0,1);
    if cj <= p
        aj = 1;
    else
        aj = 0;
    end
end

function p = P_V(V, V_0, b)
    % generate random burst amplitude

    % b: is a characteristic parameter of the amplitude distribution,
    % whenthe probability of high amplitude bursts increases, b decreases
    % it controls the number of AE burst, higher b generates more bursts
    % V: amplitude of burst
    % V_0: is the smallest burst amplitude
    
    if V >= V_0
        a1 = b/V_0;
        a2 = (V/V_0).^(-b-1);
        p = a1 * a2;
        
    else
        p = 0;
    end

end


