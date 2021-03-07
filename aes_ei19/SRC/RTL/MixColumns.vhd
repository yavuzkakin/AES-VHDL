-- MixColumns.vhd
-- Yavuz AKIN  06/12/20

library IEEE;
use IEEE.std_logic_1164.all;

library LIB_AES;
use LIB_AES.crypt_pack.all;

library LIB_RTL;
use LIB_RTL.all;

entity MixColumns is
port(
    data_e_i : in type_state;
    enable_i: in boolean;
    data_e_o : out type_state);
end entity MixColumns;

architecture MixColumns_arch of MixColumns is

    type array_column_state is array(0 to 3) of column_state;

    component MixColumns_elementary
    port(
        data_i  : in column_state;
        data_o : out column_state);
    end component;

    signal data_col_i: array_column_state; -- the signals that we're going to process
    signal data_col_o: array_column_state;



begin
    -- we work on each column
    Gcol: for i in 0 to 3 generate
        -- we convert the column to a column state that we can process
        Gcol2: for j in 0 to 3 generate
            data_col_i(i)(j)<=data_e_i(j)(i); 
        end generate Gcol2;

        -- we process the column inside MixColumns_elementary
        DUT : MixColumns_elementary port map(
            data_i=>data_col_i(i),
            data_o=>data_col_o(i));

        -- we convert the data back to its original form
        Gcol3: for k in 0 to 3 generate 
            data_e_o(k)(i)<=data_col_o(i)(k) when enable_i=true else data_col_i(i)(k);
        end generate Gcol3;
    end generate Gcol;

end MixColumns_arch;


configuration MixColumns_conf of MixColumns is
    for MixColumns_arch
        for Gcol
            for all : MixColumns_elementary
                use entity LIB_RTL.MixColumns_elementary(MixColumns_elementary_arch);
            end for;
        end for;
    end for;
end configuration MixColumns_conf;




