
clc,clear


[y, ~] = simulate_AE_signal('f', 1000, 'L', 1000, 'N', 20,...
                            'b', 1.4, 'V_0', 0.1);
                        
figure,
set(gcf, 'color', 'w')
plot(y)

