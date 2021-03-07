-- AddRoundKey TEST BENCH

-- Yavuz AKIN 04/12/20


-- ShiftRows TESTBENCH 
-----------------------------------------------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library LIB_AES;
use LIB_AES.crypt_pack.all;

library LIB_RTL;
use LIB_RTL.all;

entity AddRoundKey_tb is
end entity AddRoundKey_tb;

architecture AddRoundKey_tb_arch of AddRoundKey_tb is
    component AddRoundKey
       port(
            data_i : in type_state;
            roundkey_i: in type_state;
            data_o : out type_state);
    end component;

    signal data_i1_s, data_i2_s, data_o_s: type_state;
    signal test_ok_s : type_state;
    signal pass_fail_s : std_logic;

    begin

        DUT : AddRoundKey port map(
        data_i=>data_i1_s,
        roundkey_i=>data_i2_s,
        data_o=>data_o_s);
    
-- entry data

data_i1_s <= ((x"45", x"75", x"6e", x"e8"),
(x"73", x"20", x"66", x"65"),
(x"2d", x"63", x"69", x"20"),
(x"74", x"6f", x"6e", x"3f"));  

--the roundkey :

data_i2_s <=  ((x"2b", x"28", x"ab", x"09"),
    (x"7e", x"ae", x"f7", x"cf"),
    (x"15", x"d2", x"15", x"4f"),
    (x"16", x"a6", x"88", x"3c"));    
    
-- what we expect as output :

test_ok_s <= ( (x"6e",  x"5d",  x"c5",  x"e1"),   
(x"0d",  x"8e",  x"91",  x"aa"),
(x"38", x"b1", x"7c",  x"6f"),
(x"62", x"c9",  x"e6",  x"03"));
        
    pass_fail_s <= '1' when data_o_s=test_ok_s else '0';

end architecture AddRoundKey_tb_arch;

configuration AddRoundKey_tb_conf of AddRoundKey_tb is
    for AddRoundKey_tb_arch
        for DUT : AddRoundKey
            use entity LIB_RTL.AddRoundKey(AddRoundKey_arch);
        end for;
    end for;
end configuration AddRoundKey_tb_conf;


