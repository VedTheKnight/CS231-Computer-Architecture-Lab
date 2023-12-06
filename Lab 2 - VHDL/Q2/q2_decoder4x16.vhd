library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity decoder4x16 is
    port(a, b, c, d, enable: in std_logic;
    dec: out std_logic_vector(15 downto 0));
end entity;

architecture behaviour of decoder4x16 is
    --useful temporary variables
    signal e0,e1,e2,e3 : std_logic;

    --useful component
    component decoder2x4 is
        port(I0, I1: in std_logic;
            enable: in std_logic;
            Y0, Y1, Y2, Y3: out std_logic);
    end component; 

begin
    -- the outputs of the first decoder give the enables for the subsequent array of 4 decoders 
    decoder1: decoder2x4 port map(b,a,enable,e0,e1,e2,e3);

    --decoders 2,3,4,5 compute the LSB to the MSB respectively
    decoder2: decoder2x4 port map(d,c,e0,dec(0),dec(1),dec(2),dec(3));
    decoder3: decoder2x4 port map(d,c,e1,dec(4),dec(5),dec(6),dec(7));
    decoder4: decoder2x4 port map(d,c,e2,dec(8),dec(9),dec(10),dec(11));
    decoder5: decoder2x4 port map(d,c,e3,dec(12),dec(13),dec(14),dec(15));

end architecture;

