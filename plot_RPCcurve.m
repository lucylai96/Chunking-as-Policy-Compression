function plot_RPCcurve(reward, complexity, entrySet, legendContent)
%{
    reward: nSubj x nCondition
    complexity: nSubj x nCondition
    entrySet: which two conditions to compare
    legendContent: what are the labels/names for the two conditions

    Usage:
        plot_RPCcurve(reward, complexity, entrySet, legendContent)

%}
bmap =[141 182 205   
       255 140 105
       238 201 0  
       155 205 155];  
bmap = bmap/255;

if isequal(entrySet, [1 2]) || isequal(entrySet, [5 6]); color = bmap(1:2,:); end
if isequal(entrySet, [3 4]) || isequal(entrySet, [7 8]); color = bmap(3:4,:); end

figure; hold on;
entry = entrySet(1);
scatter(complexity(:,entry), reward(:,entry), 120, 'filled', 'MarkerFaceColor', color(1,:));
polycoef = polyfit(complexity(:,entry), reward(:,entry), 2);
X = linspace(1.2, 1.8, 80);
Y = polycoef(1).*X.*X + polycoef(2).*X + polycoef(3);
p1 = plot(X, Y, 'Color', color(1,:), 'LineWidth', 4);

entry = entrySet(2);
scatter(complexity(:,entry), reward(:,entry), 120, 'filled', 'MarkerFaceColor', color(2,:));
polycoef = polyfit(complexity(:,entry), reward(:,entry), 2);
X = linspace(1.35, 1.8, 80);
Y = polycoef(1).*X.*X + polycoef(2).*X + polycoef(3);
p2 = plot(X, Y, 'Color', color(2,:), 'LineWidth', 4);

legend([p1 p2], legendContent, 'Location', 'southeast');
legend('boxoff');
xlim([0.6 1.4]); ylim([0 1]);
xlabel('Policy complexity'); ylabel('Average reward');
