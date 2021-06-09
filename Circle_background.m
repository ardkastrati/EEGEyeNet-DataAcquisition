for pp=1:par.numtargets

    Screen('DrawDots', window, pos(pp,:), radius, color, center, [1]);
    Screen('DrawDots', window, pos(pp,:), radius_in, color_gray, center, [1]);
end

Screen('DrawDots', window, [0 0], [3], color_fix, center, [1]);
