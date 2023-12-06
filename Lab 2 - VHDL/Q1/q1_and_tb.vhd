library IEEE;
use IEEE.std_logic_1164.all;

entity Testbench is
end entity; 
-- this is like a class in cpp

architecture tb_and of Testbench is

    signal a, b : std_logic;
    signal g : std_logic;

    component AND_Gate is
        port(x1: in std_logic;
        x2: in std_logic;
        y: out std_logic);
    end component; -- the order of port mapping and variables matters

begin 

    dut_instance: AND_Gate 
    --creates an object, dut stands for device under test
    port map(x1 => a, x2 => b, y => g);

    --now we setup sequential logic to vary the values of x and y
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

    --1. Create an object of AND
    --2. Vary the inputs of AND and measure the outputs for different values
        -- connect the input of the objects with signals and then vary those signals
        -- obj(x1,x2,g) we keep varying x1 and x2 and keep reading from g