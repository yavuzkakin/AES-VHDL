-- AESRound TEST BENCH

-- Yavuz AKIN 11/12/20



library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library LIB_AES;
use LIB_AES.crypt_pack.all;

library LIB_RTL;
use LIB_RTL.all;

entity AESRound_tb is
end entity AESRound_tb;

architecture AESRound_tb_arch of AESRound_tb is 

    component AESRound
        port(text_i	: in  bit128;
        currentkey_i: in  bit128;
        data_o: out bit128;
        clock_i: in  std_logic;
        resetb_i: in  std_logic;
        enableMixcolumns_i	: in  boolean;
        enableRoundcomputing_i : in  std_logic);
    end component AESRound;


    signal text_s : bit128;
    signal currentkey_s : bit128;
    signal data_s : bit128;
    signal clock_s : std_logic :='0';
    signal resetb_s : std_logic;
    signal enableMixcolumns_s : boolean;
    signal enableRoundcomputing_s : std_logic; 

    begin

        DUT : AESRound
            port map(
                text_i=> text_s,
                currentkey_i=> currentkey_s,
                data_o=>data_s,
                clock_i=>clock_s,
                resetb_i=>resetb_s,
                enableMixColumns_i=>enableMixColumns_s,
                enableRoundcomputing_i=>enableRoundcomputing_s
            );

        resetb_s<='1','0' after 400 ns;
        clock_s<= not(clock_s) after 100 ns;

        -- We try on 2 rounds and see if they correspond to what we're expecting
        text_s<=(X"45732d747520636f6e66696ee865203f"), X"6e0d38625d8eb1c9c5917ce6e1aa6f03" after 150 ns;
        currentkey_s<=X"2b7e151628aed2a6abf7158809cf4f3c", X"a0fafe1788542cb123a339392a6c7605" after 150 ns;
        enableRoundcomputing_s<='0','1' after 150 ns;
        enableMixcolumns_s<=true;


    end architecture AESRound_tb_arch;

    
configuration AESRound_tb_conf of AESRound_tb is
    for AESRound_tb_arch
        for DUT:AESRound
            use entity LIB_RTL.AESRound(AESRound_arch);
        end for;
    end for;
    end AESRound_tb_conf;