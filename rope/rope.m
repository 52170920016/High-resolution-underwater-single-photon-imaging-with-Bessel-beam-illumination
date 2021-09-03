
%bear
clc
clear
clear all
close all
delete *.xlsx

tic

load('data_read.mat');
figure
set(gcf,'color','w')
colordef white
scatter3(data_read(:, 1), data_read(:, 2), data_read(:, 3),30, data_read(:, 2), '.');
% % %
% %

view([0 4])
% close all
set(gca, 'ytick',[],'yticklabel',[])
grid off
xlabel('X (mm)');
zlabel('Y (mm)');

cell_resolution_x = 0.2 / 1000; %元胞数组尺寸，单位:mm
cell_resolution_y = 7 / 1000; %元胞数组尺寸，单位:mm
cell_resolution_z = 4.5 / 1000; %元胞数组尺寸，单位:mm


cell_x = fix(max(data_read(:,1)) / cell_resolution_x) + 1;
cell_y = fix((max(data_read(:,2))-min(data_read(:, 2))) / cell_resolution_y) + 1;
cell_z = fix(max(data_read(:,3)) / cell_resolution_z) + 1;


result_cell_target = cell(cell_x, cell_y, cell_z);
for i = 1 : size(result_cell_target, 1)
    for j = 1 : size(result_cell_target, 2)
        for k = 1 : size(result_cell_target, 3)
            result_cell_target{i, j, k} = [0 0 0];
        end
    end
end

x_0 = min(data_read(:, 1));
y_0 = min(data_read(:, 2));
z_0 = min(data_read(:, 3));

for i = 1 : size(data_read, 1)
    temp_cell_x = fix((data_read(i, 1) - x_0) / cell_resolution_x) + 1;
    temp_cell_y = fix((data_read(i, 2) - y_0) / cell_resolution_y) + 1;
    temp_cell_z = fix((data_read(i, 3) - z_0) / cell_resolution_z) + 1;
    if result_cell_target{temp_cell_x, temp_cell_y, temp_cell_z}  == [0 0 0]
        result_cell_target{temp_cell_x, temp_cell_y, temp_cell_z} = data_read(i, :);
        %                 fprintf('空元胞\n');
        
    else
        temp_size_cell = size(result_cell_target{temp_cell_x, temp_cell_y, temp_cell_z}, 1);
        result_cell_target{temp_cell_x, temp_cell_y, temp_cell_z}(temp_size_cell + 1, :) = data_read(i, :);
        %                 fprintf('有数据元胞 %d, %d, %d\n', temp_cell_x, temp_cell_y, temp_cell_z);
    end
end



count = 1;
result_center = [0 0 0];
points_per_cube = 4;
count_cube = zeros(40,1);
time = datestr(now, 13);
for i = 1 : size(result_cell_target, 1) 
    time = datestr(now, 13);
    fprintf('正在绘制第%d行 现在时间%s\n', i, time);
    for j = 1 : size(result_cell_target, 2) 
        for k = 1 : size(result_cell_target, 3) 
            if result_cell_target{i, j, k} ~= [0 0 0]
                count_cube(size(result_cell_target{i, j, k}, 1)) = count_cube(size(result_cell_target{i, j, k}, 1)) + 1;
            end
            if size(result_cell_target{i, j, k}, 1) >= points_per_cube & result_cell_target{i, j, k} ~= [0 0 0]


                    result_center(count : count + size(result_cell_target{i, j, k}, 1) - 1, :) = [result_cell_target{i, j, k}];
                    count = count + size(result_cell_target{i, j, k}, 1);

            end
            
        end
    end
end



    figure
    set(gcf,'color','w')
colordef white
    scatter3(result_center(:, 1), result_center(:, 2), result_center(:, 3),50, result_center(:, 2), '.');
    % scatter3(result_center(:, 1), result_center(:, 2), result_center(:, 3),0.1, 'r', '.');
    hold on

    

% % %
% %
view([0 4])
% close all
set(gca, 'ytick',[],'yticklabel',[])
grid off
xlabel('X (mm)');
zlabel('Y (mm)');





% index = find(result_center(:, 3) >= 0.0       & result_center(:, 3) < 0.004 & result_center(:, 2) > 17.36  & result_center(:, 2) < 17.485 );
% index = find(result_center(:, 3) >= 0.004       & result_center(:, 3) < 0.008 & result_center(:, 2) > 17.36  & result_center(:, 2) < 17.485 );
% index = find(result_center(:, 3) >= 0.008       & result_center(:, 3) < 0.012 & result_center(:, 2) > 17.36  & result_center(:, 2) < 17.485 );

index = find(result_center(:, 3) >= 0.012       & result_center(:, 3) < 0.016 & result_center(:, 2) > 17.36  & result_center(:, 2) < 17.485 );
% index = find(result_center(:, 3) >= 0.016       & result_center(:, 3) < 0.019 & result_center(:, 2) > 17.36  & result_center(:, 2) < 17.485 );
% 
% index = find(result_center(:, 3) >= 0.019       & result_center(:, 3) < 0.023 & result_center(:, 2) > 17.36  & result_center(:, 2) < 17.485 );
% index = find(result_center(:, 3) >= 0.023       & result_center(:, 3) < 0.028 & result_center(:, 2) > 17.36  & result_center(:, 2) < 17.485 );
% index = find(result_center(:, 3) >= 0.028       & result_center(:, 3) < 0.033 & result_center(:, 2) > 17.36  & result_center(:, 2) < 17.485 );
% index = find(result_center(:, 3) >= 0.033       & result_center(:, 3) < 0.037 & result_center(:, 2) > 17.36  & result_center(:, 2) < 17.485 );


result_bars_x = result_center(index, 1);
    result_bars_x = result_bars_x * 1000;

edges_x = 0:0.2:max(result_center(:, 1)) *1000;
count = hist(result_bars_x, edges_x);
count_ori = count;

figure
subplot(211)
plot(edges_x, count);

count_smooth = smooth(count, 5);

subplot(212)
plot(edges_x, count_smooth);


% 
% 
% 







%


toc