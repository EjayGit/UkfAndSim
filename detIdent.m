function [ detList ] = detIdent( detMap, detect )
% Identify the centres of interest from the detMap.


% Detect regions.
regions = regionprops('table', logical(detMap), 'Area', 'Centroid' );

% Filter those regions that are larger than a preset size (set in detect
% struct).
tempDetList = [];

for x = 1 : 1 : size(regions, 1)
    if regions.Area(x) > detect.minMoveArea
        tempDetList = cat(1, tempDetList, [regions.Area(x), regions.Centroid(x, 1), regions.Centroid(x, 2)]);
    end
end

% % TEST AREA
% tempList = [];
% for x = 1 : size(tempDetList(:, 1))
%     tempList = cat(1, tempList, [tempDetList(x,2), tempDetList(x,3)]);
% end
% figure(1);
% pic = insertMarker(detMap, tempList, 'o', 'size', 20);
% imshow(pic);
% 
% % TEST AREA END

% If there are any other regions within a certain distance (of pixels),
% then identify the mutual centre as the centre of detection, otherwise
% nominate the centre of the region as the centre of detection.

% Concatenate a forth column for labelling.
if size(tempDetList,1) > 0
    
    tempDetList = cat(2, tempDetList, zeros(size(tempDetList, 1), 1));
    label = 1;

    for x = 1 : 1 : size(tempDetList, 1)
        % If the first comparison region has not been labelled, label it.
        if tempDetList(x, 4) == 0
             tempDetList(x, 4) = label;
             label = label + 1;
        end
        for y = 1 : 1 : size(tempDetList, 1)

            % Calculate the distance between comparison regions.
            distance = sqrt(((tempDetList(x,2))-(tempDetList(y,2)))^2 + ((tempDetList(x,3))-(tempDetList(y,3)))^2);

            % If the distance is above 0 (checked against the same region), or
            % below a set distance, label the second comparison region the
            % same as the first.
            if (distance > 0) && (distance < detect.maxMoveDist)
                % Label the second region with the same as the first label.
                tempDetList(y, 4) = tempDetList(x, 4);
            end
        end
    end

    % % TEST AREA
    % 
    % tempList = [];
    % for label = 1 : max(tempDetList(:, 4))
    %     for x = 1 : size(tempDetList(:, 4))
    %         if tempDetList(x,4) == label
    %             tempList = cat(1, tempList, [tempDetList(x,2), tempDetList(x,3)]);
    %             break
    %         end
    %     end
    % end
    % figure(1);
    % pic = insertMarker(detMap, tempList, 'o', 'size', 20);
    % imshow(pic);
    % 
    % % TEST AREA END


    xSum = 0;
    ySum = 0;
    countSearch = 0;
    detList = [];

    
    % ERROR ERROR ERROR************************
    % Where label '2' is replaced by label '3', or above, label '2' will be
    % missing from the list
    
    
    % Calculate the mean centroid from each set of regions.
    for label = 1 : 1 : max(tempDetList(:, 4))
        B = tempDetList(:,4) == label;
        [ check ] = find(find(B));
        if (~ isempty(check))
            for search = 1 : 1 : size(tempDetList, 1)
                if tempDetList(search, 4) == label

                    % Sum x values.
                    xSum = xSum + tempDetList(search, 2);

                    % Sum y values.
                    ySum = ySum + tempDetList(search, 3);

                    % Increment label counter
                    countSearch = countSearch + 1;

                end
            end

            % Caluculate mean x and y values.
            xMean = xSum / countSearch;
            yMean = ySum / countSearch;

            % Initialise xSum and ySum.
            xSum = 0;
            ySum = 0;
            countSearch = 0;

            % Store mean x and y values into detList.
            detList = cat(1, detList, [xMean, yMean ]);
        end
    end

    % TEST AREA

%     figure();
%     pic = insertMarker(detMap, detList, 'o', 'size', 20);
%     imshow(pic);

    % TEST AREA END
else
    detList = [ ];

end

