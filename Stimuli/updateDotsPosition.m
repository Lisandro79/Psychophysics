function [x, y, rho, theta] = updateDotsPosition (Exp, m, rho, theta, indxNoise, indxSignal, ...
    motionType, direction, noiseDirection, rot_spd, coherence, nDotsNoise)

% [x, y] = drawDots (Exp, m, rho, theta, Exp.addParams.motionType, direction, Exp.addParams.noiseTypeAdapt )

% Take the position of n dots on the screen in polar coordinates : rho, theta
% make them move according to 'motionType' and direction
% add coherence level

% Motion Type: rotational: 3 (clockwise, counterclockwise); radial: 4 (expanding, contracting); rotational + radial: 5
% direction:
%         rotational : 1 clockwise, 0 counterclockwise
%         radial: 1 expanding, 0 contracting
%         rotational + radial: 1 expanding + clockwise, 0 contracting + counterclockwise

% rot_spd = rotational speed in pixels per second

% coherence: 1 brownian noise, 2 white noise, 3 equiparable trajectories noise

% Returns: the polar and cartesian coordinates updated


% [x, y, rho, theta] = updateDots(idxSignal)

% [x, y, rho, theta] = updateNoiseDots(idxNoise)

switch motionType
    
    case{1} % Translational motion
        
        % The parameter phi determines the direction of motion
        
        % Working in cartesian coordinates is more confortable here.
        [x, y] = pol2cart(theta, rho);

        dx = rot_spd * cosd(Exp.addParams.phi); % x-velocity
        dy = rot_spd * sind(Exp.addParams.phi); % y-velocity
        x = x + dx; % update positions
        y = y - dy;
        % Return the polar coordinates -just for congruency with the other
        % ways of representing the dots.
        [theta, rho] = cart2pol(x, y);
        

    case{3} % rotational (clockwise, counterclockwise)
        switch direction
            case {1}
                dr = rot_spd * cos(deg2rad(90)); % change in radius per motion frame
                dt = (rot_spd./rho(indxSignal)) * sin(deg2rad(90)) ; % change theta per motion frame
                rho(indxSignal) = rho(indxSignal)+dr; % update rho
                theta(indxSignal) = theta(indxSignal)+dt; % update theta
                x(indxSignal) = rho(indxSignal)'.*cos(theta(indxSignal)'); % convert into cartesian X coordinate
                y(indxSignal) = rho(indxSignal)'.*sin(theta(indxSignal)'); % convert into cartesian X coordinate
            case {0}
                dr = rot_spd * cos(deg2rad(270)); % change in radius per frame
                dt = (rot_spd./rho(indxSignal)) * sin(deg2rad(270)); % change theta per motion frame
                rho(indxSignal) = rho(indxSignal)+dr;
                theta(indxSignal) = theta(indxSignal)+dt;
                x(indxSignal) = rho(indxSignal)'.*cos(theta(indxSignal)');
                y(indxSignal) = rho(indxSignal)'.*sin(theta(indxSignal)');
        end
        % Morrone: schneider's code is the same (without the normalization by the radius of display)
        %  v= 7; %deg/sec
        %  r= 175; % radius of s
        %  dx= v * cos (rot_th);
        %  dt= (v*sin(rot_th))/r;
    case{4} % Radial
        switch direction
            case {1}
                dr = rot_spd * cos(deg2rad(0)); % change in radius per frame
                dt = (rot_spd ./ rho(indxSignal)) * sin(deg2rad(0)); % change theta per motion frame
                rho(indxSignal) = rho(indxSignal) + dr;
                theta(indxSignal) = theta(indxSignal)+dt;
                x(indxSignal) = rho(indxSignal)'.*cos(theta(indxSignal)');
                y(indxSignal) = rho(indxSignal)'.*sin(theta(indxSignal)');
            case {0}
                dr = rot_spd * cos(deg2rad(180)); % change in radius per frame
                dt = (rot_spd ./ rho(indxSignal)) * sin(deg2rad(180)); % change theta per motion frame
                rho(indxSignal) = rho(indxSignal)+dr;
                theta(indxSignal) = theta(indxSignal)+dt;
                x(indxSignal) = rho(indxSignal)'.*cos(theta(indxSignal)');
                y(indxSignal) = rho(indxSignal)'.*sin(theta(indxSignal)');
        end
    case{5} % Rotational + Radial
        switch direction
            case {1}
                dr = rot_spd * cos(deg2rad(Exp.addParams.phi)); % change in radius per frame
                dt = (rot_spd./rho(indxSignal)) * sin(deg2rad(Exp.addParams.phi)); % change theta per motion frame
                rho(indxSignal) = rho(indxSignal)+dr;
                theta(indxSignal) = theta(indxSignal)+dt;
                x(indxSignal) = rho(indxSignal)'.*cos(theta(indxSignal)');
                y(indxSignal) = rho(indxSignal)'.*sin(theta(indxSignal)');
            case {0}
                dr = rot_spd * cos(deg2rad(Exp.addParams.phi)); % change in radius per frame
                dt = (rot_spd./rho(indxSignal)) * sin(deg2rad(Exp.addParams.phi)); % change theta per motion frame
                rho(indxSignal) = rho(indxSignal)-dr;
                theta(indxSignal) = theta(indxSignal)-dt;
                x(indxSignal) = rho(indxSignal)'.*cos(theta(indxSignal)');
                y(indxSignal) = rho(indxSignal)'.*sin(theta(indxSignal)');
        end
end


% COHERENCE
switch coherence

    % BROWNIAN NOISE -random walk-
    case{1}

        rPhi = 360.*rand(1,nDotsNoise);
        dr = rot_spd .* cos((pi/180) * rPhi); % change in radius per frame
        dt = (rot_spd./rho(indxNoise))' .* sin((pi/180) *rPhi); % change theta per motion frame
        
        rho(indxNoise) = rho(indxNoise)' + dr;
        theta(indxNoise) = theta(indxNoise)' +dt;
        
        x(indxNoise) = rho(indxNoise)'.*cos(theta(indxNoise)');
        y(indxNoise) = rho(indxNoise)'.*sin(theta(indxNoise)');


        % WHITE NOISE
    case{2}
        
        % Static trials (rot_spd == 0)
        if rot_spd ~= 0
            rho(indxNoise) = Exp.addParams.rmax * sqrt(rand(length(indxNoise),1));	% random radiuses
            theta(indxNoise) = 2*pi* rand(length(indxNoise),1); % random thetas
            x(indxNoise) = rho(indxNoise)'.*cos(theta(indxNoise)') ; % update positions
            y(indxNoise) = rho(indxNoise)'.*sin(theta(indxNoise)'); % update positions
        end

        % EQUIPARABLE DOTS NOISE -SWITCH TRAJECTORIES-. The same as white noise but we only update 
        % dots position every each dot frame life
    case{3}
        
        dr = noiseDirection(indxNoise,1) * rot_spd;
        dt = ( rot_spd ./ rho(indxNoise) ) .* sin( deg2rad(noiseDirection(indxNoise,2)) ); % change theta per motion frame        
        rho(indxNoise) =  rho(indxNoise) + dr; % change in radius per frame
        theta(indxNoise) = theta(indxNoise) + dt;
        x(indxNoise) = rho(indxNoise)' .* cos(theta(indxNoise)');
        y(indxNoise) = rho(indxNoise)' .* sin(theta(indxNoise)');

    otherwise
        % Do nothing. No noise.

end





