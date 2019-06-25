classdef quaternion
    properties
        val=[0 0 0 0]
    end
    
    methods
        %constructor
        function q = quaternion(q1,q2,q3,q4)
            q.val = [q1 q2 q3 q4];
        end
        
        %% Operator overloading
        
        %addition
        function r = plus(q1,q2)
           r.val = q1.val +q2.val; 
        end
        
        %subtraction
        function r= minus(q1,q2)
           r.val = q1.val - q2.val; 
        end
        
        %multiplication
        function r= times(q,k)
           r.val = q.val*k;
        end
        
        
    end
    
end


