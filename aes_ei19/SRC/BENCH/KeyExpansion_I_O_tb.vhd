--  KeyExpansion_I_O TEST BENCH - Yavuz AKIN
-- 16/12/20


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library LIB_AES;
use LIB_AES.crypt_pack.all;

library LIB_RTL;
use LIB_RTL.all;

entity KeyExpansion_I_O_tb is
end entity KeyExpansion_I_O_tb;

architecture KeyExpansion_I_O_tb_arch of KeyExpansion_I_O_tb is 

    component KeyExpansion_I_O is 
        port(
            key_i : in bit128;
            start_i : in std_logic;
            clock_i : in std_logic;
            reset_i : in std_logic;
            expansion_key_o : out bit128
        );
    end component KeyExpansion_I_O;


    signal key_s : bit128;
    signal start_s : std_logic;
    signal clock_s : std_logic :='0';
    signal reset_s : std_logic;
    signal expansion_key_s : bit128;

    signal test_ok_s : bit128;
    signal pass_fail_s : std_logic;


    begin
        
        DUT: KeyExpansion_I_O port map(
            key_i=>key_s,
            start_i=>start_s,
            clock_i=>clock_s,
            reset_i=>reset_s,
            expansion_key_o=>expansion_key_s
        );

        key_s <=X"2b7e151628aed2a6abf7158809cf4f3c"; -- the first input key

        test_ok_s <=X"d014f9a8c9ee2589e13f0cc8b6630ca6";  -- test is ok if the last key element is correct

        start_s<='1' after 50 ns;

        clock_s<= not(clock_s) after 100 ns;

        reset_s<='1' after 50 ns;

        pass_fail_s <= '1' when expansion_key_s=test_ok_s else '0';


    
    end architecture KeyExpansion_I_O_tb_arch;


    configuration KeyExpansion_I_O_tb_conf of KeyExpansion_I_O_tb is
        for KeyExpansion_I_O_tb_arch
            for DUT : KeyExpansion_I_O
                use entity LIB_RTL.KeyExpansion_I_O(KeyExpansion_I_O_arch);
            end for;
        end for;
    end configuration KeyExpansion_I_O_tb_conf;