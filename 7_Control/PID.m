classdef PID
    properties
        kp % Proportional gain
        ki % Integral gain
        kd % Derivative gain
        prev_err % Previous error (for derivative calculation)
        integral_err % Integral of the error
    end
    
    methods
        % Constructor
        function obj = PID(kp, ki, kd)
            obj.kp = kp;
            obj.ki = ki;
            obj.kd = kd;
            obj.prev_err = 0;
            obj.integral_err = 0;
        end
        
        % Method to compute the control signal
        function control = compute(obj, error, dt)
            % Update integral of error
            obj.integral_err = obj.integral_err + error * dt;
            
            % Calculate derivative of error
            derivative = (error - obj.prev_err) / dt;
            
            % Compute control signal
            control = obj.kp * error + obj.ki * obj.integral_err + obj.kd * derivative;
            
            % Update previous error
            obj.prev_err = error;
        end
    end
end