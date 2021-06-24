function x = errorbarPosition(b, sem)

[ngroups, nbars] = size(sem);
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end