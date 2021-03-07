-- SubBytes.vhd
-- Yavuz AKIN  05/12/20

library IEEE;
use IEEE.std_logic_1164.all;

library LIB_AES;
use LIB_AES.crypt_pack.all;

library LIB_RTL;
use LIB_RTL.all;

entity SubBytes is
port(
    data_i : in type_state;
    data_o : out type_state);
end entity SubBytes;

architecture SubBytes_arch of SubBytes is

    component SBOX
    port(
        SBOX_in  : in bit8;
        SBOX_out : out bit8);
    end component;

begin
    -- we use SBOX on every member of the entry matrix
    Grow : for i in 0 to 3 generate
        Gcol: for j in 0 to 3 generate
            DUT : SBOX port map(
            SBOX_in => data_i(i)(j),
            SBOX_out=> data_o(i)(j));
        end generate Gcol;
    end generate Grow;


end SubBytes_arch;

configuration SubBytes_conf of SubBytes is
    for SubBytes_arch
        for Grow
            for Gcol
                for all : SBOX
                    use entity LIB_RTL.SBOX(SBOX_arch);
                end for;
            end for;
        end for;
    end for;
end configuration SubBytes_conf;



