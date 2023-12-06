library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity Testbench is
end entity; 

architecture tb_enc4x2 of Testbench is

    signal I_test : std_logic_vector (3 downto 0);
    signal Y_test : std_logic_vector (1 downto 0);

    type I_test_array_type is array (3 downto 0) of std_logic_vector(3 downto 0);
    constant I_test_values: I_test_array_type := (
        "1000", "0100", "0010", "0001"
    );

    component encoder4x2 is
        port(I: in std_logic_vector (3 downto 0);
        Y: out std_logic_vector(1 downto 0));
    end component; 

begin 

    dut_instance: encoder4x2
    port map(I => I_test, Y => Y_test);

    process
    begin
        for i in 0 to 3 loop
            I_test <= I_test_values(i);
            wait for 1 ns;  
        end loop;
    end process;

end architecture;
