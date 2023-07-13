function [y, t] = simulate_one_AE_signal(varargin)
% reference: Simulation of AE signals and signal analysis systems    
% f: frequency
% L: length
% ti: time of AE occurrence
% tau: characteristic decay time of AE signal
% v: amplitude
    
    p = inputParser;
    addParameter(p, 'f', 10)
    addParameter(p, 'L', 100)
    addParameter(p, 'ti', 0)
    addParameter(p, 'tau', 4)  % tau/L < 5
    addParameter(p, 'v', 2)
    parse(p, varargin{:})

    f = p.Results.f;
    L = p.Results.L;
    ti = p.Results.ti;
    tau = p.Results.tau;
    v = p.Results.v;
    
    ti = ti/f;  % time of AE occurrence

    
    [y, t] = func_g(L, f, ti, tau, v);
    
    %plot(y)
    %plot(t+ti, y)
end

function [y, t] = func_g(L, f, ti, tau, v)

    delta_t = 1/f; 
    t = 0 : delta_t : L-delta_t;
    t = t - ti;
    
    y = zeros(1, length(t));
    
    idx = find(t>0);
    
    y(idx) = v * exp(-t(idx) ./ tau) .* sin(2*pi .* t(idx));
end


