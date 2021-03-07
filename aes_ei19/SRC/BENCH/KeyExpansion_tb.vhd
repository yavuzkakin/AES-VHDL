--  KeyExpansion TEST BENCH - Yavuz AKIN
-- 16/12/20


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library LIB_AES;
use LIB_AES.crypt_pack.all;

library LIB_RTL;
use LIB_RTL.all;

entity KeyExpansion_tb is
end entity KeyExpansion_tb;


architecture KeyExpansion_tb_arch of KeyExpansion_tb is
    component KeyExpansion
       port(
            key_i : in bit128;
            rcon_i : in bit8;
            expansion_key_o : out bit128);
    end component;

    signal key_i_s, expansion_key_o_s: bit128;
    signal test_ok_s : bit128;
    signal pass_fail_s : std_logic;

    begin

        DUT : KeyExpansion port map(
        key_i=>key_i_s,
        rcon_i=>X"01", -- we work with this value of Rcon
        expansion_key_o=>expansion_key_o_s);
    
-- stimulii

key_i_s <= X"2b7e151628aed2a6abf7158809cf4f3c"; -- initial key

test_ok_s <=X"a0fafe1788542cb123a339392a6c7605"; -- expected output

   
        
    pass_fail_s <= '1' when expansion_key_o_s=test_ok_s else '0';

end architecture KeyExpansion_tb_arch;

configuration KeyExpansion_tb_conf of KeyExpansion_tb is
    for KeyExpansion_tb_arch
        for DUT : KeyExpansion
            use entity LIB_RTL.KeyExpansion(KeyExpansion_arch);
        end for;
    end for;
end configuration KeyExpansion_tb_conf;
