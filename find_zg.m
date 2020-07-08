function zg = find_zg(xg)
global XG ZG
zg = interp1(XG,ZG(1,:),xg,'spline');
end