fc    = 10; % Hz
omega = 2*pi*fc;
num   = omega;
denum = [1 omega];


H_LP          = tf(num, denum);
H_LP_discrete = c2d(H_LP, 0.01);

% Low pass -> 45 Hz
% y(n+1) = 0.05916 * y(n) + 0.9408 * u(n)
fc    = 45; % Hz
omega = 2*pi*fc;
num   = [1 0];
denum = [1 omega];

H_HP          = tf(num, denum);
H_HP_discrete = c2d(H_HP, 0.01);

H_LP_discrete.num
H_LP_discrete.den
H_HP_discrete.num
H_HP_discrete.den