-- ShiftRows TESTBENCH (manque la configuration)
-----------------------------------------------------------------------------------------------------------------------

-- S-BOX_tb.vhd
-- Yavuz AKIN - 27/11/2020

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library LIB_AES;
use LIB_AES.crypt_pack.all;

library LIB_RTL;
use LIB_RTL.all;

entity ShiftRows_tb is
end entity ShiftRows_tb;

architecture ShiftRows_tb_arch of ShiftRows_tb is
    component ShiftRows
       port(
           data_i : in type_state;
          data_o : out type_state);
    end component;

    signal data_i_s, data_o_s: type_state;
    signal test_ok_s : type_state;
    signal pass_fail_s : std_logic;

    begin

        DUT : ShiftRows port map(
        data_i=>data_i_s,
        data_o=>data_o_s);
    
-- stimulii

    data_i_s<=  ((X"9f",X"4c",X"a6",X"f8"),
                (X"d7",X"19",X"81",X"ac"),
                (X"07",X"c8",X"10",X"a8"),
                (X"aa",X"dd",X"8e",X"7b"));

    test_ok_s <=((X"9f",X"4c",X"a6",X"f8"),
                (X"19",X"81",X"ac",X"d7"),
                (X"10",X"a8",X"07",X"c8"),
                (X"7b",X"aa",X"dd",X"8e"));
        
    pass_fail_s <= '1' when data_o_s=test_ok_s else '0';

end architecture ShiftRows_tb_arch;

configuration ShiftRows_tb_conf of ShiftRows_tb is
    for ShiftRows_tb_arch
        for DUT : ShiftRows
            use entity LIB_RTL.ShiftRows(ShiftRows_arch);
        end for;
    end for;
end configuration ShiftRows_tb_conf;


