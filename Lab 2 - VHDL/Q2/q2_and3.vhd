library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity AND_gate_3 is
    port(x : in std_logic;
         y : in std_logic;
         z : in std_logic;
         o: out std_logic);
end entity; 

architecture behaviour of AND_gate_3 is
begin
    o <= ((x and y) and z);
end architecture;