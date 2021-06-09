if Eyelink( 'NewFloatSampleAvailable') > 0
    % get the sample in the form of an event structure
    eye_used=0;
    evt = Eyelink( 'NewestFloatSample');
    % get current gaze position from sample
    x = evt.gx(eye_used+1)-center(1); % +1 as we're accessing MATLAB array
    y = -(evt.gy(eye_used+1)-center(2));
    p = evt.pa(eye_used+1);
    % do we have valid data and is the pupil visible?
    if evt.pa(eye_used+1)>0
    else
        x=nan; y=nan;
    end
end