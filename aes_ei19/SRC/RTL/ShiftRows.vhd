-- ShiftRows.vhd
-- Yavuz AKIN

library IEEE;
use IEEE.std_logic_1164.all;

library LIB_AES;
use LIB_AES.crypt_pack.all;

library LIB_RTL;
use LIB_RTL.all;

entity ShiftRows is
port(
    data_i : in type_state;
    data_o : out type_state);
end entity ShiftRows;

architecture ShiftRows_arch of ShiftRows is
begin
    -- we do the shifting for each row
    Grow : for i in 0 to 3 generate
        Gcol: for j in 0 to 3 generate
            data_o(i)(j)<=data_i(i)((i+j) mod 4); -- the shifting is done here 
        end generate Gcol;
    end generate Grow;


end ShiftRows_arch;


