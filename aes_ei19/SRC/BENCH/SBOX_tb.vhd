-- S-Box TESTBENCH (manque la configuration)
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

entity SBOX_tb is
end entity SBOX_tb;

architecture SBOX_tb_arch of SBOX_tb is
component SBOX
    port(
        SBox_in : in bit8;
        SBox_out : out bit8);
end component;

signal SBox_is : bit8 := X"00";
signal SBox_os : bit8;

begin 
	DUT : SBOX
	port map(
		SBox_in => SBox_is,
		SBox_out => SBox_os);

	SBox_is <= X"30", X"F2" after 25 ns; -- we put these inputs and compare their outputs to the expected values

end architecture SBOX_tb_arch;

configuration SBOX_tb_conf of SBOX_tb is
    for SBOX_tb_arch
        for DUT:SBOX
            use entity LIB_RTL.SBOX(SBOX_arch);
        end for;
    end for;
end SBOX_tb_conf;