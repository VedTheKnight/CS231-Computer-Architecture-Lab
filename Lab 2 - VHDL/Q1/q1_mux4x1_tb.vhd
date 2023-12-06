library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;  -- Add this library for to_unsigned

entity Testbench is
end entity; 

architecture tb_mux4x1 of Testbench is

    signal D_test : std_logic_vector (3 downto 0);
    signal S_test : std_logic_vector (1 downto 0);
    signal Y_test : std_logic;

    type D_test_array_type is array (63 downto 0) of std_logic_vector(3 downto 0);
    constant D_test_values: D_test_array_type := (
        "0000", "0000", "0000", "0000",
        "0001", "0001", "0001", "0001",
        "0010", "0010", "0010", "0010", 
        "0011", "0011", "0011", "0011",
        "0100", "0100", "0100", "0100",
        "0101", "0101", "0101", "0101", 
        "0110", "0110", "0110", "0110",
        "0111", "0111", "0111", "0111",
        "1000", "1000", "1000", "1000",
        "1001", "1001", "1001", "1001", 
        "1010", "1010", "1010", "1010",
        "1011", "1011", "1011", "1011",
        "1100", "1100", "1100", "1100",
        "1101", "1101", "1101", "1101",
        "1110", "1110", "1110", "1110",
        "1111", "1111", "1111", "1111"
    );

    type S_test_array_type is array (63 downto 0) of std_logic_vector(1 downto 0);
    constant S_test_values: S_test_array_type := (
        "00", "01", "10", "11",
        "00", "01", "10", "11",
        "00", "01", "10", "11",
        "00", "01", "10", "11",
        "00", "01", "10", "11",
        "00", "01", "10", "11",
        "00", "01", "10", "11",
        "00", "01", "10", "11",
        "00", "01", "10", "11",
        "00", "01", "10", "11",
        "00", "01", "10", "11",
        "00", "01", "10", "11",
        "00", "01", "10", "11",
        "00", "01", "10", "11",
        "00", "01", "10", "11",
        "00", "01", "10", "11");

    component mux4x1 is
        port(D: in std_logic_vector (3 downto 0);
            S: in std_logic_vector(1 downto 0);
            Y: out std_logic);
    end component; 

begin 

    dut_instance: mux4x1
    port map(D => D_test, S => S_test, Y => Y_test);

    process
    begin
        for i in 0 to 63 loop
            D_test <= D_test_values(i);
            S_test <= S_test_values(i);
            wait for 1 ns;  
        end loop;
        wait for 1 ns;
    end process;

end architecture;
