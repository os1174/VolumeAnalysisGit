function [pumpLiters] = CalculateVolume(pumpingMovement,pumpSeconds)
    %we are returning pumpLiters which is being sent as volumeEvent

    quadVertex = 1.1644;    %the y value of the vertex of the parabola used to calculate volume; = (-(b^2)/(4*a))+c    pumpLiters = 0;
    
    pumpingMovement = pumpingMovement*6.28/360;    %convert to radians
    timePerRad = pumpSeconds / pumpingMovement;
    if (timePerRad < quadVertex)    %if the time per radian is below this value, the result will be undefined
        timePerRad = quadVertex;    %if above case, set the time per radian to the minimum defined value
    end
    %calculate volume based on quadratic trend line
    %pumpLiters = ((-b - sqrt((b*b) - (4 * (a) * (c - (timePerRad))))) / (2*a)) * pumpingMovement;
    %sendDebugMessage("Single Equation Volume Pumped = ", pumpLiters);  //Debug
    
    if (timePerRad > 2.25)        %If determined to be in slow pumping cluster
        pumpLiters = (.0227*(timePerRad)+.2571)*pumpingMovement;
    end
    if (timePerRad < 2.25 && timePerRad > 1.75)    %If determined to be in medium pumping cluster
        pumpLiters = (.0128*(timePerRad)+.3208)*pumpingMovement;
    end
    if (timePerRad < 1.75)             %If determined to be in fast pumping cluster
        pumpLiters = (.0106*(timePerRad)+.4138)*pumpingMovement;
    end
    if(pumpLiters < 0)  % saw this during debug of code need to find out why this can happen
        pumpLiters = 0;
    end
   
end