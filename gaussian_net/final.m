%bear
clc
clear
clear all
close all
load RedBlueColorMap.mat
result_line = zeros(1, 99); 

result_bright = [];
result_dark = [];

tic
% points_per_cube = 8;
load('gaussian.mat');
for points_per_cube = 4:8

t0=cputime ;
%通道







sum_signal = 0;
sum_noise = 0;



points_number_per_cube_max = -1;
points_number_per_cube_min = 999;
count_cube = zeros(40,1);






count = 1;
count_center = 1;
result_center = [0 0 0];
%每一个立方体里有几个点
for i = 2 : size(result_cell_target, 1) - 1
    time = datestr(now, 13);
        fprintf('正在绘制第%d行 现在时间%s\n', i, time);

    for j = 2 : size(result_cell_target, 2) - 1
        for k = 2 : size(result_cell_target, 3) - 1
            if result_cell_target{i, j, k} ~= [0 0 0]
                count_cube(size(result_cell_target{i, j, k}, 1)) = count_cube(size(result_cell_target{i, j, k}, 1)) + 1;
            end
            if size(result_cell_target{i, j, k}, 1) > points_per_cube
%                 count_cube(size(result_cell_target{i, j, k}, 1)) = count_cube(size(result_cell_target{i, j, k}, 1)) + 1;
                if size(result_cell_target{i, j, k}, 1) > points_number_per_cube_max
                    points_number_per_cube_max = size(result_cell_target{i, j, k}, 1);
                end
%                 count_cube(size(result_cell_target{i, j, k}, 1)) = count_cube(size(result_cell_target{i, j, k}, 1)) + 1;
                sum_signal = sum_signal+ size(result_cell_target{i, j, k}, 1);
                temp_point_number = [];
                
                temp_point_number(1) = size(result_cell_target{i - 1, j, k}, 1) > points_per_cube;
                
                temp_point_number(2) = size(result_cell_target{i + 1, j, k}, 1) > points_per_cube;
                if sum(temp_point_number) > -1
                    result_center(count : count + size(result_cell_target{i, j, k}, 1) - 1, :) = [result_cell_target{i, j, k}];
                    count = count + size(result_cell_target{i, j, k}, 1);
                end
%                 if i == 43 & j == 3 
%                     result_line(k) = size(result_cell_target{i, j, k}, 1);
%                 end
               
            elseif result_cell_target{i, j, k} ~= [0 0 0]
%                 count_cube(size(result_cell_target{i, j, k}, 1)) = count_cube(size(result_cell_target{i, j, k}, 1)) + 1;
                sum_noise = sum_noise+ size(result_cell_target{i, j, k}, 1);
                if size(result_cell_target{i, j, k}, 1) < points_number_per_cube_min
                    points_number_per_cube_min = size(result_cell_target{i, j, k}, 1);
                end
            end
            lie = 320;
             if i >=  550 - lie - 5 & i <= 550 - lie + 5  & j == 3
                    result_line(k) =  result_line(k) + size(result_cell_target{i, j, k}, 1);
                end
        end
    end
end


fprintf('长方体最多包含%d个点\n',points_number_per_cube_max);
fprintf('长方体最少包含%d个点\n',points_number_per_cube_min);



result_center = result_center * 1000;
figure
 scatter3(result_center(:, 1), result_center(:, 2), result_center(:, 3),0.1, result_center(:, 2), '.');
% scatter3(result_center(:, 1), result_center(:, 2), result_center(:, 3),0.1, 'r', '.');
hold on
title(num2str(points_per_cube))

xlabel('')
ylabel('')
zlabel('')
xlim([0 inf])
zlim([0 200])
set(gca,'xtick',[],'xticklabel',[])
set(gca,'ytick',[],'yticklabel',[])
set(gca,'ztick',[],'zticklabel',[])
view([0 4])

% set(gca,'ytick',[],'yticklabel',[])


index_bright = find(result_center(:, 1) >= 51.2 & result_center(:, 1) <= 53.2 & result_center(:, 3) >= 93.5 & result_center(:, 3) <= 95.5);
index_dark = find(result_center(:, 1) >= 66.6 & result_center(:, 1) <= 68.6 & result_center(:, 3) >= 93.5 & result_center(:, 3) <= 95.5);
result_bright = [result_bright; [points_per_cube, size(index_bright, 1)]];
result_dark = [result_dark; [points_per_cube, size(index_dark, 1)]];
snr = result_bright(:, 2) ./ result_dark(:, 2);
    snr = [result_bright(:, 1), snr];
delete *.xlsx
end
x = 1 : 40;
result_ratio = [];
for i = 1 : 20

index = find(x>= i);
result_ratio(i,1) = i;

% result_ratio(i,2) = sum(count_cube(index)) / sum(count_cube);
result_ratio(i,2) = sum(count_cube(index)) / sum(count_cube);

end
% plot(result_ratio(:,1), result_ratio(:, 2))
ssum = 0;
for i = 1 : 31
    ssum = ssum + i * count_cube(i);
end
ssum / sum(count_cube)
toc