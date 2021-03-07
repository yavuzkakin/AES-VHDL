--  KeyExpansion - Yavuz AKIN
-- 15/12/20


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

library LIB_AES;
use LIB_AES.crypt_pack.all;

library LIB_RTL;
use LIB_RTL.all;

entity KeyExpansion is
    port (
        key_i : in bit128;
        rcon_i : in bit8;
        expansion_key_o : out bit128
    );
  end KeyExpansion;

architecture KeyExpansion_arch of KeyExpansion is 

    type key_state is array(0 to 3) of column_state;


    component SBOX
        port(
            SBOX_in : in bit8;
            SBOX_out : out bit8);
    end component SBOX;


    signal key_state_i : key_state; -- It's the signal we're going to use to manipulate the key

    signal key_state_o : key_state; -- It's the output signal but in key state

    signal rcon_column : column_state; -- It's to create the Rcon(i) column

    signal rot_column : column_state; -- It's the rotated Column

    signal sbox_column : column_state; --The rot_column to which we do a SubByte

    begin


        -- we create the Rcon(i) column

        rcon_column(0)<= rcon_i;

        C1 : for col1 in 1 to 3 generate 
            rcon_column(col1)<=X"00";
        end generate;



        -- convert key bit128(127 downto 0) to key state

        K1 : for col in 0 to 3 generate
	    K2 : for row in 0 to 3 generate
            key_state_i(col)(row) <= key_i(127-32*col-8*row downto 120-32*col-8*row);
	    end generate;
        end generate;



    -- First step : rotation of the last column

        K3: for row in 0 to 3 generate
            rot_column(row)<=key_state_i(3)((row+1) mod 4);
        end generate;


    -- Second Step : We use SubBytes on rot_column

        Gcol: for j in 0 to 3 generate
            DUT : SBOX port map(
                SBOX_in => rot_column(j),
                SBOX_out=> sbox_column(j));
        end generate Gcol;

    -- Third Step : we use XOR 

    key_state_o(0)<=key_state_i(0) xor sbox_column xor rcon_column;


    -- Fourth Step : we complete the other columns :

    K4: for col in 1 to 3 generate
        key_state_o(col)<=key_state_i(col) xor key_state_o(col-1);
    end generate;


    --Fifth Step : Convert the Key to 128bit

    K5 : for col in 0 to 3 generate
	    K6 : for row in 0 to 3 generate
            expansion_key_o(127-32*col-8*row downto 120-32*col-8*row) <= key_state_o(col)(row);
	    end generate;
        end generate;   


end architecture KeyExpansion_arch;


configuration KeyExpansion_conf of KeyExpansion is
    for KeyExpansion_arch
        for Gcol 
            for all : SBOX 
                use entity LIB_RTL.SBOX(SBOX_arch);
            end for;
        end for;
    end for;
end configuration KeyExpansion_conf;