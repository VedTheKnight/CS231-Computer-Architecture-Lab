library ieee, std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;


entity ASCII_Read_test is
end entity;

architecture reader of ASCII_Read_test is
	component CHORD_Encoder
	    port(clk, rst: in std_logic;
	    a: in std_logic_vector(7 downto 0);
	    data_valid: out std_logic;
	    z: out std_logic_vector(7 downto 0));
	end component;
	signal input_sig, output_sig: std_logic_vector (7 downto 0);
	signal clk, rst, data_valid : std_logic;
begin
	dut_instance: CHORD_Encoder
		port map (a => input_sig, clk => clk, z => output_sig, data_valid => data_valid, rst => rst);
	
	process
		file input_file: text open read_mode is "test.txt";
		file output_file: text open write_mode is "out.txt";
		variable input_line, output_line: line;
		variable input_var, output_var : std_logic_vector (7 downto 0);
		variable counter : integer := 0;
	begin
		clk <= '0';
		while true loop
			if not endfile(input_file) then 
				readline (input_file, input_line);
				read (input_line, input_var);
				input_sig <= input_var;
			else
				input_sig <= "11111111";
			end if;
			
			wait for 1 ns; 
			clk <= '1'; --this is the instant the outputs are computed
			wait for 1 ns; 
			clk <= '0'; 
			wait for 1 ns;
			if(input_sig = "11111111") then
				if(output_sig /= "00000000" and output_sig /= "UUUUUUUU") then
					output_var := output_sig;
					write (output_line, output_var);
					writeline (output_file, output_line);
				end if;
			end if;
			wait for 1 ns;
		end loop;
	end process;

end architecture;
