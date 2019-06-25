classdef CQuaternion
    properties
        s=0;        %scalar
        v=[0 0 0];  %vector
    end
    
    methods
        function q=CQuaternion(q1,q2)
            
            %no argument -> unit quaternion
            if nargin==0
                q.s=1;
                q.v=[0 0 0];
            elseif nargin==1
                q1=q1(:);
                q.s=q1(1);
                q.v=q1(2:4)';                
            end           
            
        end
        
        function display(q)
           ['{',num2str(q.s),',', mat2str(q.v),'}']
        end
            
        function v4=toVec4(q)
           v4=[q.s q.v]; 
        end
        
        function q_=conj(q)
           q_=CQuaternion([q.s -q.v]);
        end
        
        function qu=unit(q)
           qu=q/norm(q); 
        end
    end
end