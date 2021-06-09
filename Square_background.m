k = 1;
for j = 1:numSquares
    for i = 1:numSquares
        squares(:, k) = CenterRectOnPoint(baseRect, Xpos(i), Ypos(j));
        k = k+1;
    end
end
clear i j k;
Screen('FillRect', window, color_gray, squares);
if rectangleBorder, Screen('FrameRect', window, color_white, squares,1), end;
%Screen('DrawDots', window, [0 0], [3], color_fix, center, [1]);
