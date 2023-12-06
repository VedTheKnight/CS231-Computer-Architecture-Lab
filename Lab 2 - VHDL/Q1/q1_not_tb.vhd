library IEEE;
use IEEE.std_logic_1164.all;

entity Testbench is
end entity;

architecture tb_not of Testbench is

    signal a : std_logic;
    signal g : std_logic;

    component NOT_Gate is
        port(x: in std_logic;
            y: out std_logic);
    end component;

begin

    dut_instance : NOT_Gate
    port map(x => a, y => g);

    process
    begin

        a<='0';

        wait for 1 ns;

        a<='1';

        wait for 1 ns;

    end process;

end architecture;

