-- AES TEST BENCH

-- Yavuz AKIN 11/12/20



library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library LIB_AES;
use LIB_AES.crypt_pack.all;

library LIB_RTL;
use LIB_RTL.all;

entity AES_tb is
end entity AES_tb;


architecture AES_tb_arch of AES_tb is 

    component AES
        port(
            clock_i	: in  std_logic;
            reset_i	: in  std_logic;
            start_i	: in  std_logic;
            key_i	: in  bit128;
            data_i	: in  bit128;
            data_o	: out bit128;
            aes_on_o : out std_logic
        );
    end component;

    signal clock_s : std_logic :='0';
    signal reset_s : std_logic;
    signal start_s : std_logic;
    signal key_s : bit128;
    signal data_i_s : bit128;
    signal data_o_s : bit128;
    signal aes_on_s : std_logic;

    signal test_ok_s : bit128;
    signal pass_fail_s : std_logic;

    begin

        DUT : AES port map (
            clock_i => clock_s,
            reset_i => reset_s,
            start_i => start_s,
            key_i => key_s,
            data_i => data_i_s,
            data_o=> data_o_s,
            aes_on_o => aes_on_s
        );

        clock_s <= not(clock_s) after 100 ns;
        reset_s <= '0'; -- We start at the beginning
        start_s <= '1';
        key_s<= X"2b7e151628aed2a6abf7158809cf4f3c"; -- the initial key
        data_i_s<=X"45732d747520636f6e66696ee865203f"; -- beggining message
        test_ok_s<=X"cd301f3e1f969b1e6d37d179807b55b4"; -- expected output


        pass_fail_s <= '1' when data_o_s=test_ok_s else '0';
    
    end architecture AES_tb_arch;

configuration AES_tb_conf of AES_tb is
    for AES_tb_arch
        for DUT:AES
            use entity LIB_RTL.AES(AES_arch);
        end for;
    end for;
end AES_tb_conf;

        





    
