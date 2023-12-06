library IEEE;
use IEEE.std_logic_1164.all;

entity mux4x1 is
    port(D: in std_logic_vector (3 downto 0);
        S: in std_logic_vector(1 downto 0);
        Y: out std_logic);
end entity; 

architecture behaviour of mux4x1 is
    
    --define some useful temporary variables
    signal S0_not, S1_not : std_logic;
    signal D0_mod, D1_mod, D2_mod, D3_mod,D0_mod_temp, D1_mod_temp, D2_mod_temp, D3_mod_temp : std_logic;
    signal D0_1, D2_3:std_logic;

    --import some useful components
    component AND_Gate is
        port(x1: in std_logic;
        x2: in std_logic;
        y: out std_logic);
    end component;

    component NOT_Gate is
        port(x: in std_logic;
            y: out std_logic);
    end component;

    component OR_Gate is
        port(x1: in std_logic;
        x2: in std_logic;
        y: out std_logic);
    end component;

begin

    --create the not of the selector ports
    n1 : NOT_Gate port map(S(0),S0_not);
    n2 : NOT_Gate port map(S(1),S1_not);

    --create the individual and-gates
    a1 : AND_Gate port map(D(0),S1_not,D0_mod_temp);
    a2 : AND_Gate port map(D0_mod_temp,S0_not,D0_mod);

    a3 : AND_Gate port map(D(1),S1_not,D1_mod_temp);
    a4 : AND_Gate port map(D1_mod_temp,S(0),D1_mod);

    a5 : AND_Gate port map(D(2),S(1),D2_mod_temp);
    a6 : AND_Gate port map(D2_mod_temp,S0_not,D2_mod);

    a7 : AND_Gate port map(D(3),S(1),D3_mod_temp);
    a8 : AND_Gate port map(D3_mod_temp,S(0),D3_mod);

    --make the final or gate
    o1 : OR_Gate port map(D0_mod,D1_mod,D0_1);
    o2 : OR_Gate port map(D2_mod,D3_mod,D2_3);
    o3 : OR_Gate port map(D0_1,D2_3,Y);

end architecture;

