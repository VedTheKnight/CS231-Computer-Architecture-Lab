library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;

entity CHORD_Encoder is
    port(clk, rst: in std_logic;
    a: in std_logic_vector(7 downto 0);
    data_valid: out std_logic;
    z: out std_logic_vector(7 downto 0));
end entity;

architecture behaviour of CHORD_Encoder is

    --we initialize 2 arrays to store all the inputs in binary ascii and their note values respectively
    type NoteArrayType is array(0 to 63) of std_logic_vector(7 downto 0);
    type NumericalNoteArrayType is array(0 to 63) of integer;
    signal NoteArray : NoteArrayType := ("00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000");
    signal NumericalNoteArray : NumericalNoteArrayType := (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
    
    signal print_flag : integer := 0; --flag to demarcate whether or not all the notes are read and computed
    signal NAindex,NNAindex : integer := 0; --stores the current index of each array
    

begin
    process(a,clk,rst)
        variable i : integer := 0; --loop variable
        variable OutputArray : NoteArrayType := ("00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000");
        variable OAindex : integer := 0;
    begin
        if rising_edge(clk) then
            --map out the ascii values into integers modulo 12
            if print_flag = 0 then
                if a = "11111111" then --when we have input all the notes
                    while i < 60 loop
                        if(((NumericalNoteArray(i+4)-NumericalNoteArray(i)) mod 12 = 7) and NumericalNoteArray(i+4) /= 0) then -- only case where a valid chord exists
                            
                            if((NumericalNoteArray(i+2)-NumericalNoteArray(i)) mod 12 = 3) then --minor chord
                                if(NumericalNoteArray(i+1)=0) then --not a sharp chord
                                    OutputArray(OAindex) := NoteArray(i); --copies in the plain note
                                    OAindex := OAindex + 1;
                                    OutputArray(OAindex) := "01101101"; --ascii value for m in binary
                                    OAindex := OAindex + 1;
                                else --sharp chord
                                    OutputArray(OAindex) := NoteArray(i); --copies in the plain note
                                    OAindex := OAindex + 1;
                                    OutputArray(OAindex) := NoteArray(i+1); --copies in the hashtag
                                    OAindex := OAindex + 1;
                                    OutputArray(OAindex) := "01101101"; --ascii value for m in binary
                                    OAindex := OAindex + 1;
                                end if;
                                i := i+6; 
                            elsif((NumericalNoteArray(i+2)-NumericalNoteArray(i)) mod 12 = 5) then --suspended chord
                                if(NumericalNoteArray(i+1)=0) then --not a sharp chord
                                    OutputArray(OAindex) := NoteArray(i); --copies in the plain note
                                    OAindex := OAindex + 1;
                                    OutputArray(OAindex) := "01110011"; --ascii value for s in binary
                                    OAindex := OAindex + 1;
                                else --sharp chord
                                    OutputArray(OAindex) := NoteArray(i); --copies in the plain note
                                    OAindex := OAindex + 1;
                                    OutputArray(OAindex) := NoteArray(i+1); --copies in the hashtag
                                    OAindex := OAindex + 1;
                                    OutputArray(OAindex) := "01110011"; --ascii value for s in binary
                                    OAindex := OAindex + 1;
                                end if;
                                i := i+6;
                            elsif((NumericalNoteArray(i+2)-NumericalNoteArray(i)) mod 12 = 4) then --major chord
                                if(i = 58) then -- edge case to deal with index out of bounds case
                                    if(NumericalNoteArray(i+1)=0) then --not a sharp chord
                                        OutputArray(OAindex) := NoteArray(i); --copies in the plain note
                                        OAindex := OAindex + 1;
                                        OutputArray(OAindex) := "01001101"; --ascii value for M in binary
                                        OAindex := OAindex + 1;
                                    else --sharp chord
                                        OutputArray(OAindex) := NoteArray(i); --copies in the plain note
                                        OAindex := OAindex + 1;
                                        OutputArray(OAindex) := NoteArray(i+1); --copies in the hashtag
                                        OAindex := OAindex + 1;
                                        OutputArray(OAindex) := "01001101"; --ascii value for M in binary
                                        OAindex := OAindex + 1;
                                    end if;
                                    i := i+6;
                                elsif((NumericalNoteArray(i+6) - NumericalNoteArray(i+4)) mod 12 = 3) then --dominant 7th chord
                                    if(NumericalNoteArray(i+1)=0) then --not a sharp chord
                                        OutputArray(OAindex) := NoteArray(i); --copies in the plain note
                                        OAindex := OAindex + 1;
                                        OutputArray(OAindex) := "00110111"; --ascii value for 7 in binary
                                        OAindex := OAindex + 1;
                                    else --sharp chord
                                        OutputArray(OAindex) := NoteArray(i); --copies in the plain note
                                        OAindex := OAindex + 1;
                                        OutputArray(OAindex) := NoteArray(i+1); --copies in the hashtag
                                        OAindex := OAindex + 1;
                                        OutputArray(OAindex) := "00110111"; --ascii value for 7 in binary
                                        OAindex := OAindex + 1;
                                    end if;
                                    i := i+8; 
                                else --just a major chord
                                    if(NumericalNoteArray(i+1)=0) then --not a sharp chord
                                        OutputArray(OAindex) := NoteArray(i); --copies in the plain note
                                        OAindex := OAindex + 1;
                                        OutputArray(OAindex) := "01001101"; --ascii value for M in binary
                                        OAindex := OAindex + 1;
                                    else --sharp chord
                                        OutputArray(OAindex) := NoteArray(i); --copies in the plain note
                                        OAindex := OAindex + 1;
                                        OutputArray(OAindex) := NoteArray(i+1); --copies in the hashtag
                                        OAindex := OAindex + 1;
                                        OutputArray(OAindex) := "01001101"; --ascii value for M in binary
                                        OAindex := OAindex + 1;
                                    end if;
                                    i := i+6; 
                                end if;
                            else --middle mismatch
                                if(NumericalNoteArray(i+1)=0) then --not a sharp chord
                                    OutputArray(OAindex) := NoteArray(i); --copies in the plain note
                                    OAindex := OAindex + 1;
                                else --sharp chord
                                    OutputArray(OAindex) := NoteArray(i); --copies in the plain note
                                    OAindex := OAindex + 1;
                                    OutputArray(OAindex) := NoteArray(i+1); --copies in the hashtag
                                    OAindex := OAindex + 1;
                                end if;
                                i := i+2;  
                            end if;
                        else -- not a valid chord pattern
                            if(NumericalNoteArray(i+1)=0) then --not a sharp chord
                                OutputArray(OAindex) := NoteArray(i); --copies in the plain note
                                OAindex := OAindex + 1;
                            else --sharp chord
                                OutputArray(OAindex) := NoteArray(i); --copies in the plain note
                                OAindex := OAindex + 1;
                                OutputArray(OAindex) := NoteArray(i+1); --copies in the hashtag
                                OAindex := OAindex + 1;
                            end if;
                            i := i+2;
                        end if;
                    end loop;
                    data_valid <= '1';
                    print_flag <= 1; --to allow for printing
                    OAindex := 0; --to start from the first element of the OutputArray
                elsif a = "01000011"  then  
                    NumericalNoteArray(NNAindex) <= 0;
                    NNAindex <= NNAindex + 2;
                    NoteArray(NAindex) <= a;
                    NAindex <= NAindex + 2;
                elsif a = "01100100" then 
                    NumericalNoteArray(NNAindex) <= 1;
                    NNAindex <= NNAindex + 2;
                    NoteArray(NAindex) <= a;
                    NAindex <= NAindex + 2;
                elsif a = "01000100" then 
                    NumericalNoteArray(NNAindex) <= 2;
                    NNAindex <= NNAindex + 2;
                    NoteArray(NAindex) <= a;
                    NAindex <= NAindex + 2;
                elsif a = "01100101" then 
                    NumericalNoteArray(NNAindex) <= 3;
                    NNAindex <= NNAindex + 2;
                    NoteArray(NAindex) <= a;
                    NAindex <= NAindex + 2;
                elsif a = "01000101" or a = "01100110" then 
                    NumericalNoteArray(NNAindex) <= 4;
                    NNAindex <= NNAindex + 2;
                    NoteArray(NAindex) <= a;
                    NAindex <= NAindex + 2;
                elsif a = "01000110" then 
                    NumericalNoteArray(NNAindex) <= 5;
                    NNAindex <= NNAindex + 2;
                    NoteArray(NAindex) <= a;
                    NAindex <= NAindex + 2;
                elsif a = "01100111" then 
                    NumericalNoteArray(NNAindex) <= 6;
                    NNAindex <= NNAindex + 2;
                    NoteArray(NAindex) <= a;
                    NAindex <= NAindex + 2;
                elsif a = "01000111" then 
                    NumericalNoteArray(NNAindex) <= 7;
                    NNAindex <= NNAindex + 2;
                    NoteArray(NAindex) <= a;
                    NAindex <= NAindex + 2;
                elsif a = "01100001" then
                    NumericalNoteArray(NNAindex) <= 8;
                    NNAindex <= NNAindex + 2;
                    NoteArray(NAindex) <= a;
                    NAindex <= NAindex + 2;
                elsif a = "01000001" then 
                    NumericalNoteArray(NNAindex) <= 9;
                    NNAindex <= NNAindex + 2;
                    NoteArray(NAindex) <= a;
                    NAindex <= NAindex + 2;
                elsif a = "01100010" then 
                    NumericalNoteArray(NNAindex) <= 10;
                    NNAindex <= NNAindex + 2;
                    NoteArray(NAindex) <= a;
                    NAindex <= NAindex + 2;
                elsif a = "01000010" or a = "01100011" then 
                    NumericalNoteArray(NNAindex) <= 11;
                    NNAindex <= NNAindex + 2;
                    NoteArray(NAindex) <= a;
                    NAindex <= NAindex + 2;
                elsif a = "00011111" then  -- deals with #
                    NumericalNoteArray(NNAindex-2) <= (NumericalNoteArray(NNAindex-2) + 1) mod 12;
                    NumericalNoteArray(NNAindex-1) <= 1; --we add this flag which will be useful to us later
                    NoteArray(NAindex-1) <= a;
                    --note that we don't need to increment either NNAindex or NAindex
                
                end if;
            elsif (print_flag = 1) then
                if OutputArray(OAindex) = "00000000" then
                    z <= "00000000";
                    print_flag <= 2;
                else
                    z <= OutputArray(OAindex);
                    OAindex := OAindex + 1;
                end if;
            end if;

        end if;

    end process;

end architecture;