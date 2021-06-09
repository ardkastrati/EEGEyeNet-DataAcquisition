function y = LCM_SK(x)

% takes a vector of integers and calculates the least common multiple of ALL of the integers, no matter how many
% NB there is a function lcm in matlab that only does two numbers

k=1;
while 1
    si = mod(k*x(1),x);
    if all(~si)
        y=k*x(1);
        break;
    end
    k=k+1;
end