-- MixColumns_elementary TESTBENCH (manque la configuration)
-----------------------------------------------------------------------------------------------------------------------

-- Mix_Columns_elementary_tb.vhd
-- Yavuz AKIN - 06/12/2020

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library LIB_AES;
use LIB_AES.crypt_pack.all;

library LIB_RTL;
use LIB_RTL.all;

entity MixColumns_elementary_tb is
end entity MixColumns_elementary_tb;

architecture MixColumns_elementary_tb_arch of MixColumns_elementary_tb is
    component MixColumns_elementary
       port(
           data_i : in column_state;
          data_o : out column_state);
    end component;

    signal data_i_s, data_o_s: column_state;
    signal test_ok_s : column_state;
    signal pass_fail_s : std_logic;

    begin

        DUT : MixColumns_elementary port map(
        data_i=>data_i_s,
        data_o=>data_o_s);
    
-- stimulii

data_i_s <= ((x"9f"), (x"19"), (x"10"), (x"7b"));

test_ok_s <= ((x"65"), (x"e6"), (x"2b"), (x"45"));

   
        
    pass_fail_s <= '1' when data_o_s=test_ok_s else '0';

end architecture MixColumns_elementary_tb_arch;

configuration MixColumns_elementary_tb_conf of MixColumns_elementary_tb is
    for MixColumns_elementary_tb_arch
        for DUT : MixColumns_elementary
            use entity LIB_RTL.MixColumns_elementary(MixColumns_elementary_arch);
        end for;
    end for;
end configuration MixColumns_elementary_tb_conf;


