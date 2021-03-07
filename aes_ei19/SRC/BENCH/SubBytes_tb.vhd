-- SubBytes TESTBENCH 
-----------------------------------------------------------------------------------------------------------------------

-- SubBytes_tb.vhd
-- Yavuz AKIN - 27/11/2020

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library LIB_AES;
use LIB_AES.crypt_pack.all;

library LIB_RTL;
use LIB_RTL.all;

entity SubBytes_tb is
end entity SubBytes_tb;

architecture SubBytes_tb_arch of SubBytes_tb is
    component SubBytes
       port(
           data_i : in type_state;
          data_o : out type_state);
    end component;

    signal data_i_s, data_o_s: type_state;
    signal test_ok_s : type_state;
    signal pass_fail_s : std_logic;

    begin

        DUT : SubBytes port map(
        data_i=>data_i_s,
        data_o=>data_o_s);
    
-- stimulii

    data_i_s <= ( (x"6e",  x"5d",  x"c5",  x"e1"),   
    (x"0d",  x"8e",  x"91",  x"aa"),
    (x"38", x"b1", x"7c",  x"6f"),
    (x"62", x"c9",  x"e6",  x"03"));

    test_ok_s <= ( (x"9f", x"4c", x"a6", x"f8"),        
    (x"d7", x"19", x"81", x"ac"),
    (x"07", x"c8", x"10", x"a8"),
    (x"aa", x"dd", x"8e", x"7b"));
        
    pass_fail_s <= '1' when data_o_s=test_ok_s else '0';

end architecture SubBytes_tb_arch;

configuration SubBytes_tb_conf of SubBytes_tb is
    for SubBytes_tb_arch
        for DUT : SubBytes
            use entity LIB_RTL.SubBytes(SubBytes_arch);
        end for;
    end for;
end configuration SubBytes_tb_conf;
