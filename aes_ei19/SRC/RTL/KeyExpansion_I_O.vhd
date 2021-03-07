--  KeyExpansion_I_O - Yavuz AKIN
-- 16/12/20


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

library LIB_AES;
use LIB_AES.crypt_pack.all;

library LIB_RTL;
use LIB_RTL.all;


entity KeyExpansion_I_O is 
    port(
        key_i : in bit128;
        start_i : in std_logic;
        clock_i : in std_logic;
        reset_i : in std_logic;
        expansion_key_o : out bit128
    );
end entity;


architecture KeyExpansion_I_O_arch of KeyExpansion_I_O is 


type rcon_state is array (0 to 10) of bit8;

component FSM_KeyExpansion
    port(
        start_i : in std_logic; -- the start,clock,reset signals are given by KeyExpanderI_O
        clock_i : in std_logic; 
        reset_i : in std_logic;
        counter_i : in bit4;  -- it comes from the Counter

        enable_o : out std_logic; -- goes to the Counter and register
        reset_counter_o : out std_logic -- goes to Counter
    );
end component FSM_KeyExpansion;

component KeyExpansion
       port(
            key_i : in bit128;
            rcon_i : in bit8;
            expansion_key_o : out bit128);
    end component;


component Counter is 
port(reset_i  : in  std_logic;
    enable_i : in  std_logic;
    clock_i  : in  std_logic;
    count_o  : out bit4);
end component;

-- signal fom FSM_KeyExpansion

signal enable_o_s : std_logic; -- the enable_o that goes from FSM_KeyExpansion
signal reset_counter_o_s : std_logic; -- goes out from FSM_KeyExpander

--signals from Counter
signal count_o_s : bit4; -- goes out from counter

--signals for KeyExpander
signal KeyState_s : bit128; -- Key state that goes into KeyExpansion
signal expansion_key_o_s : bit128; -- Key State that goes out of KeyExpander

--Register
signal Key_reg_s : bit128; -- register where the key is stored


signal rcon_array : rcon_state; -- First row of Rcon

signal rcon_s : bit8;



begin

    --We initialize the RCON first row ( the last isn't used but it's there isn't an error during a compilation)
    rcon_array<=(X"01",X"02",X"04",X"08",X"10",X"20",X"40",X"80",X"1b",X"36",X"00");

    -- We do the initialization of the components 

    FSM : FSM_KeyExpansion 
        port map (
            start_i=>start_i,
            clock_i=>clock_i,
            reset_i=>reset_i,
            counter_i=>count_o_s,
            enable_o=>enable_o_s,
            reset_counter_o=>reset_counter_o_s
        );

    CO : Counter
        port map (
            reset_i=>reset_counter_o_s,
            enable_i=>enable_o_s,
            clock_i=>clock_i,
            count_o=> count_o_s
        );

    rcon_s<=rcon_array(to_integer(unsigned(count_o_s)));
    

    KE : KeyExpansion
        port map (
            key_i=>KeyState_s,
            rcon_i=>rcon_s,
            expansion_key_o=>expansion_key_o_s
        );



 -- register with the Key State
P0 : process(expansion_key_o_s, clock_i, reset_i,enable_o_s)
begin
	if reset_i = '0' then  -- reset asynchron
		Key_reg_s<=(others => '0');
	elsif (clock_i'event and clock_i = '1' and enable_o_s='1') then
		Key_reg_s <= expansion_key_o_s;
	end if;
end process P0;

-- MUX :
KeyState_s<=key_i when (count_o_s=X"0") else Key_reg_s;


expansion_key_o<=KeyState_s;


end architecture KeyExpansion_I_O_arch;


configuration KeyExpansion_I_O_conf of KeyExpansion_I_O is
    for KeyExpansion_I_O_arch 
        for FSM : FSM_KeyExpansion
            use entity LIB_RTL.FSM_KeyExpansion(FSM_KeyExpansion_Moore_arch);
            end for;
        for CO : Counter
            use entity LIB_RTL.Counter(Counter_arch);
        end for;
        for KE : KeyExpansion
            use entity LIB_RTL.KeyExpansion(KeyExpansion_arch);
        end for; 
    end for;
end configuration KeyExpansion_I_O_conf;



