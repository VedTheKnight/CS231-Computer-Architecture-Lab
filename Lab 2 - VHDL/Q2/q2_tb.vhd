library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;  -- Add this library for to_unsigned

entity Testbench is
end entity; 

architecture tb_decoder4x16 of Testbench is

    signal a,b,c,d,enable : std_logic;
    signal dec: std_logic_vector (15 downto 0);

    component decoder4x16 is
        port(a, b, c, d, enable: in std_logic;
            dec: out std_logic_vector(15 downto 0));
    end component;

begin 

    dut_instance: decoder4x16
    port map(a => a, b => b, c => c, d => d, enable => enable, dec => dec);

    process
    begin
        enable <= '1';

        a <= '0'; b <= '0'; c <= '0'; d <= '0';
        wait for 1 ns;
        a <= '0'; b <= '0'; c <= '0'; d <= '1';
        wait for 1 ns;
        a <= '0'; b <= '0'; c <= '1'; d <= '0';
        wait for 1 ns;
        a <= '0'; b <= '0'; c <= '1'; d <= '1';
        wait for 1 ns;
        a <= '0'; b <= '1'; c <= '0'; d <= '0';
        wait for 1 ns;
        a <= '0'; b <= '1'; c <= '0'; d <= '1';
        wait for 1 ns;
        a <= '0'; b <= '1'; c <= '1'; d <= '0';
        wait for 1 ns;
        a <= '0'; b <= '1'; c <= '1'; d <= '1';
        wait for 1 ns;
        a <= '1'; b <= '0'; c <= '0'; d <= '0';
        wait for 1 ns;
        a <= '1'; b <= '0'; c <= '0'; d <= '1';
        wait for 1 ns;
        a <= '1'; b <= '0'; c <= '1'; d <= '0';
        wait for 1 ns;
        a <= '1'; b <= '0'; c <= '1'; d <= '1';
        wait for 1 ns;
        a <= '1'; b <= '1'; c <= '0'; d <= '0';
        wait for 1 ns;
        a <= '1'; b <= '1'; c <= '0'; d <= '1';
        wait for 1 ns;
        a <= '1'; b <= '1'; c <= '1'; d <= '0';
        wait for 1 ns;
        a <= '1'; b <= '1'; c <= '1'; d <= '1';
        wait for 1 ns;

        enable <= '0';

        a <= '0'; b <= '0'; c <= '0'; d <= '0';
        wait for 1 ns;
        a <= '0'; b <= '0'; c <= '0'; d <= '1';
        wait for 1 ns;
        a <= '0'; b <= '0'; c <= '1'; d <= '0';
        wait for 1 ns;
        a <= '0'; b <= '0'; c <= '1'; d <= '1';
        wait for 1 ns;
        a <= '0'; b <= '1'; c <= '0'; d <= '0';
        wait for 1 ns;
        a <= '0'; b <= '1'; c <= '0'; d <= '1';
        wait for 1 ns;
        a <= '0'; b <= '1'; c <= '1'; d <= '0';
        wait for 1 ns;
        a <= '0'; b <= '1'; c <= '1'; d <= '1';
        wait for 1 ns;
        a <= '1'; b <= '0'; c <= '0'; d <= '0';
        wait for 1 ns;
        a <= '1'; b <= '0'; c <= '0'; d <= '1';
        wait for 1 ns;
        a <= '1'; b <= '0'; c <= '1'; d <= '0';
        wait for 1 ns;
        a <= '1'; b <= '0'; c <= '1'; d <= '1';
        wait for 1 ns;
        a <= '1'; b <= '1'; c <= '0'; d <= '0';
        wait for 1 ns;
        a <= '1'; b <= '1'; c <= '0'; d <= '1';
        wait for 1 ns;
        a <= '1'; b <= '1'; c <= '1'; d <= '0';
        wait for 1 ns;
        a <= '1'; b <= '1'; c <= '1'; d <= '1';
        wait for 1 ns;
        
    end process;

end architecture;
