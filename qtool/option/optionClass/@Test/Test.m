classdef Test 
    %TEST 换属性名字的方法，原名是b，现改名为a，但是怕人还用b
    % help properties中的例子
    
    properties
        a;
    end
    
    properties(Dependent, Hidden = false)
        b
    end
    

    
    methods
        function obj = Test(a)
            obj.a = a;
        end
        
        function obj = set.b(obj, val)
            obj.a = val;
        end
        
        function val = get.b(obj)
            val = obj.a;
        end
    end
    
    
    methods(Static = true)
        function demo
            % 试验enumeration
            t = Test.small
            t.a
            
            
            
            % 试验游戏手柄，ok
            joy1 = vrjoystick(1);
            joy2 = vrjoystick(2);
            caps(joy1)
            [axes, buttons, povs] = read(joy2)
            
            
            
            
        end
        
        
    end
    
    
    enumeration
        small   (1);
        medium  (10);
        big     (100);
    end
end

