-- MixColumns TESTBENCH 
-----------------------------------------------------------------------------------------------------------------------

-- Mix_Columns_tb.vhd
-- Yavuz AKIN - 06/12/2020

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library LIB_AES;
use LIB_AES.crypt_pack.all;

library LIB_RTL;
use LIB_RTL.all;

entity MixColumns_tb is
end entity MixColumns_tb;


architecture MixColumns_tb_arch of MixColumns_tb is
    component MixColumns
       port(
            data_e_i : in type_state;
            enable_i: in boolean;
            data_e_o : out type_state);
    end component;

    signal data_i_s, data_o_s: type_state;
    signal test_ok_s : type_state;
    signal pass_fail_s : std_logic;

    begin

        DUT : MixColumns port map(
        data_e_i=>data_i_s,
        enable_i=>true,
        data_e_o=>data_o_s);
    
-- stimulii

data_i_s <= ((x"9f", x"4c", x"a6", x"f8"),
            (x"19", x"81", x"ac", x"d7"),
            (x"10", x"a8", x"07", x"c8"),
            (x"7b", x"aa", x"dd", x"8e"));

test_ok_s <=    ((x"65",x"02", x"62", x"cf"),
                (x"e6", x"1c", x"31", x"80"),
                (x"2b", x"63", x"78", x"2d"),
                (x"45", x"b2", x"fb", x"0b"));

   
        
    pass_fail_s <= '1' when data_o_s=test_ok_s else '0';

end architecture MixColumns_tb_arch;

configuration MixColumns_tb_conf of MixColumns_tb is
    for MixColumns_tb_arch
        for DUT : MixColumns
            use entity LIB_RTL.MixColumns(MixColumns_arch);
        end for;
    end for;
end configuration MixColumns_tb_conf;



