--AddRoundKey.vhd
-- Yavuz AKIN  04/12/20


library IEEE;
use IEEE.std_logic_1164.all;

library LIB_AES;
use LIB_AES.crypt_pack.all;

library LIB_RTL;
use LIB_RTL.all;

entity AddRoundKey is
port(
    data_i : in type_state;
    roundkey_i: in type_state;
    data_o : out type_state);
end entity AddRoundKey;

architecture AddRoundKey_arch of AddRoundKey is
begin
    Gcol: for j in 0 to 3 generate
        Grow: for i in 0 to 3 generate
            data_o(i)(j)<=(data_i(i)(j) xor roundkey_i(i)(j)); -- the round key is adder with a xor operator
        end generate Grow;
    end generate Gcol;
end AddRoundKey_arch;

