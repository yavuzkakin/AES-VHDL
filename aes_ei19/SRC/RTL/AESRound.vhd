-- AESRound.vhd

--Yavuz AKIN 11/12/20 

library IEEE;
use IEEE.std_logic_1164.all;

library LIB_AES;
use LIB_AES.crypt_pack.all;

library LIB_RTL;
use LIB_RTL.all;


entity AESRound is

    port(text_i	: in  bit128;
    currentkey_i: in  bit128;
    data_o: out bit128;
    clock_i: in  std_logic;
    resetb_i: in  std_logic;
    enableMixcolumns_i	: in  boolean; -- the last round doesn't do MixColumns that's why we need this entry
    enableRoundcomputing_i : in  std_logic); 
    end entity AESRound;

architecture AESRound_arch of AESRound is 
   
-- AESRound is composed of AddRoundKey, SubBytes, MixColumns

    component AddRoundKey
        port(data_i : in type_state;
        roundkey_i: in type_state;
        data_o : out type_state);
    end component AddRoundKey;

    component SubBytes
        port(data_i : in type_state;
        data_o : out type_state);
    end component SubBytes;

    component ShiftRows
        port(
         data_i : in type_state;
         data_o : out type_state);
    end component ShiftRows;

    component MixColumns
     port(
         data_e_i : in type_state;
        enable_i: in boolean;
        data_e_o : out type_state);
    end component MixColumns;

    signal inputARK_s : type_state; --input signal ARK
    signal currentKeyState_s : type_state; --roundkey signal in mode state
    signal textState_s : type_state; -- text signal in state mode
    signal outputARK_s : type_state; -- ARK output signal

    signal data_s : type_state; -- flip flop output
    signal output_SB_s : type_state; -- SB output
    signal output_SR_s : type_state; -- SR output
    signal output_MC_s : type_state; -- Mc output
    
    begin

        
    -- convert text bit128(127 downto 0) to type state
    K1 : for col in 0 to 3 generate
	    K2 : for row in 0 to 3 generate
            textState_s(row)(col) <= text_i(127-32*col-8*row downto 120-32*col-8*row);
	    end generate;
    end generate;


     -- convert key bit128(127 downto 0) to type state
     T1 : for col in 0 to 3 generate
     T2 : for row in 0 to 3 generate
         currentKeyState_s(row)(col) <= currentKey_i(127-32*col-8*row downto 120-32*col-8*row);
     end generate;
     end generate;

         -- MUX text_i vs outputMC -> inputARK
    inputARK_s <= output_MC_s when enableRoundcomputing_i = '1' else textState_s;

        
    ARK : AddRoundKey
         port map(
            data_i=>inputARK_s,
          roundkey_i => currentKeyState_s,
            data_o=> outputARK_s);

    SB : Subbytes
        port map(
            data_i=>data_s,
            data_o=>output_SB_s);

    SR: ShiftRows
        port map(
            data_i=>output_SB_s,
            data_o=>output_SR_s
        );

    MC: Mixcolumns
        port map(
            data_e_i=> output_SR_s,
            enable_i=>enableMixColumns_i,
            data_e_o=>output_MC_s
        );

-- register containing the state AES
P0 : process(outputARK_s, clock_i, resetb_i)
begin
	if resetb_i = '0' then  -- reset asynchrone
		R0 : for i in 0 to 3 loop
			R1 : for j in 0 to 3 loop
				data_s(i)(j) <= (others => '0');
			end loop;
		end loop;
	elsif (clock_i'event and clock_i = '1') then
		data_s <= outputARK_s;
	end if;
end process P0;


 -- convert data_s to bit128(127 downto 0) to type state
 D1 : for col in 0 to 3 generate
 D2 : for row in 0 to 3 generate
     data_o(127-32*col-8*row downto 120-32*col-8*row)<= data_s(row)(col);
 end generate;
 end generate;


    end architecture AESRound_arch;


configuration AESRound_conf of AESRound is 
        for AESRound_arch
            for ARK : AddRoundKey
                use entity LIB_RTL.AddRoundKey(AddRoundKey_arch);
            end for;
            for SB : SubBytes
                use entity LIB_RTL.SubBytes(SubBytes_arch);
            end for;
            for SR : ShiftRows
                use entity LIB_RTL.ShiftRows(ShiftRows_arch);
            end for; 
            for MC : MixColumns
                use entity LIB_RTL.MixColumns(MixColumns_arch);
            end for;
        end for;
end configuration AESRound_conf;

        
