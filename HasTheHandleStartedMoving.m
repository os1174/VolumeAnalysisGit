function [handleMovement] = HasTheHandleStartedMoving(rest_position, latestAngle)
%function [handleMovement] = HasTheHandleStartedMoving(rest_position, latestAngle)
%  Input: rest_position - angle in degrees of the handle when it is assumed to be at rest.  
%          This does not need to be at one of the stops.  A person could be 
%          holding it anywhere but not moving it up and down.
%          latestAngle - the current handle angle
%   Output: 0 if the handle has not moved enough (handleMovementThreshold = 5 degrees) 
%             to say that it is really moving
%           1 if the current position is at least handleMovementThreshold 
%             away from the assumed rest position
%   Overview:  Before pumping begins, or when it stops the handle position is noted.
%              by looking at the current position relative to this measured resting position,
%              we can decide if there has been enough movement to indicate that
%              someone is deliberately moving it to try to pump water.   

handleMovementThreshold = 5;  % if the handle moves at least 5 degrees from 
                              % rest position, pumping has started.
handleMovement = 0;  % assume that the handle is not moving
deltaAngle = latestAngle - rest_position;
    if(deltaAngle < 0)
        deltaAngle = deltaAngle * -1;
    end
    if(deltaAngle > handleMovementThreshold) %The total movement of the handle from rest has been exceeded
		handleMovement = 1;
    end
end