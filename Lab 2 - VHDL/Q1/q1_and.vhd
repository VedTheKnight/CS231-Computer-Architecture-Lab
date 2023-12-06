library IEEE;
use IEEE.std_logic_1164.all;

-- define an interface

entity AND_Gate is
    port(x1: in std_logic;
    x2: in std_logic;
    y: out std_logic);
end entity;

-- define the behaviour

architecture behaviour of AND_Gate is
begin
    y <= x1 and x2;
end architecture;

-- in order to do this sequentially :
--process(x1,x2) sensitivity list : which is necessary if there isn't atleast one wait statement
--begin
--  if x1 = '1' and x2 = '1' then
--      y <= '1';
--  else
--      y <= '0';
--  end if;
--end process;