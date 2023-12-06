library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity decoder2x4 is
    port(I0, I1: in std_logic;
    enable: in std_logic;
    Y0, Y1, Y2, Y3: out std_logic);
end entity; 

architecture behaviour of decoder2x4 is

    --useful temporary variables
    signal I0_not, I1_not : std_logic;

    --useful components
    component AND_gate_3 is
    port(x : in std_logic;
         y : in std_logic;
         z : in std_logic;
         o: out std_logic);
    end component;     

    component NOT_Gate is
        port(x: in std_logic;
            y: out std_logic);
    end component;

begin
    
    --defining the temporary not variables
    n1 : NOT_Gate port map(I0, I0_not);
    n2 : NOT_Gate port map(I1, I1_not);

    --assigning the final outputs 
    o0: AND_Gate_3 port map(I0_not,I1_not,enable,Y0);
    o1: AND_Gate_3 port map(I0,I1_not,enable,Y1);
    o2: AND_Gate_3 port map(I0_not,I1,enable,Y2);
    o3: AND_Gate_3 port map(I0,I1,enable,Y3);

end architecture;