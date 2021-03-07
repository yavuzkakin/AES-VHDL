-- MixColumns_elementary.vhd  Yavuz AKIN

library IEEE;
use IEEE.std_logic_1164.all;

library LIB_AES;
use LIB_AES.crypt_pack.all;

library LIB_RTL;
use LIB_RTL.all;

entity MixColumns_elementary is
port(
    data_i : in column_state;
    data_o : out column_state);
end entity MixColumns_elementary;

  --OK jusqu'à ici
architecture MixColumns_elementary_arch of MixColumns_elementary is
    

    
    signal data_o_2 : column_state; -- data_i x 02  -- ok
    signal data_o_3 : column_state; -- data_i x 03  -- ok


begin

    Gcol1: for i in 0 to 3 generate
    -- dans le cas ou l'on multiplie par 2 on décale à gauche mais on veut pas avoir 9 bits donc on fait un modulo 100011011 (norme)
    -- lorsque le bit de poinds fort data_i(i)(7) est 0 par besoin de mod donc le xor est 0 sinon on fait un xor pour le mod.
            data_o_2(i) <= (data_i(i)(6 downto 0) & '0') xor ("000" & data_i(i)(7) & data_i(i)(7) & '0' & data_i(i)(7) & data_i(i)(7));
    end generate Gcol1;

    Gcol2: for i in 0 to 3 generate
        data_o_3(i) <= data_o_2(i) xor data_i(i);
    end generate Gcol2;

    data_o(0)<=data_o_2(0) xor data_o_3(1) xor data_i(2) xor data_i(3);
    data_o(1)<=data_i(0) xor data_o_2(1) xor data_o_3(2) xor data_i(3);
    data_o(2)<=data_i(0) xor data_i(1) xor data_o_2(2) xor data_o_3(3);
    data_o(3)<=data_o_3(0) xor data_i(1) xor data_i(2) xor data_o_2(3);


end MixColumns_elementary_arch;
