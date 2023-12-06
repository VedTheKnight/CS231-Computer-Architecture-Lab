library IEEE;
use IEEE.std_logic_1164.all;

entity Testbench is
end entity;

architecture tb_or of Testbench is

    signal a, b : std_logic;
    signal g : std_logic;

    component OR_Gate is
        port(x1: in std_logic;
        x2: in std_logic;
        y: out std_logic);
    end component;

begin

    dut_instance : OR_Gate
    port map(x1 => a, x2 => b, y =>  g);

    process
    begin

        a<='0';
        b<='0';

        wait for 1 ns;

        a<='0';
        b<='1';

        wait for 1 ns;

        a<='1';
        b<='0';

        wait for 1 ns;

        a<='1';
        b<='1';

        wait for 1 ns;

    end process;

end architecture;

