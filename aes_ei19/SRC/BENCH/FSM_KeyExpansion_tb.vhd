-- FSM_KeyExpansion_tb TESTBENCH
-----------------------------------------------------------------------------------------------------------------------

-- FSM_KeyExpansion_tb.vhd
-- Yavuz AKIN - 27/11/2020

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library LIB_AES;
use LIB_AES.crypt_pack.all;

library LIB_RTL;
use LIB_RTL.all;

entity FSM_KeyExpansion_tb is
end entity FSM_KeyExpansion_tb;

architecture FSM_KeyExpansion_tb_arch of FSM_KeyExpansion_tb is 

-- We dispose of 1 FSM_KeyExpansion and 1 Counter
    
    component FSM_KeyExpansion
       port(
        start_i : in std_logic;
        clock_i : in std_logic;
        reset_i : in std_logic;
        counter_i : in bit4;

        enable_o : out std_logic;
        reset_counter_o : out std_logic
    );
    end component;

    component Counter
        port(reset_i  : in  std_logic;
            enable_i : in  std_logic;
            clock_i  : in  std_logic;
            count_o  : out bit4);
    end component;
    
    -- signals for FSM
    signal start_s: std_logic :='0';
    signal reset_s: std_logic;
    signal clock_s : std_logic := '0';
    signal enable_s : std_logic;
    signal reset_counter_s : std_logic;


    -- signal for Counter
    signal count_s : bit4; 

    begin

        FSM : FSM_KeyExpansion port map(
            start_i=>start_s,
            clock_i=>clock_s,
            reset_i=>reset_s,
            counter_i=>count_s,
            enable_o=>enable_s,
            reset_counter_o=>reset_counter_s
        );

        CO: Counter port map(
            reset_i=>reset_counter_s,
            enable_i=>enable_s,
            clock_i=>clock_s,
            count_o=>count_s
        );
    

    --stimulii

    clock_s<= not(clock_s) after 50 ns;
    start_s<='1' after 100 ns, '0' after 550 ns; -- we start working at 100 ns then we deactivate start_s to come back to init state
    reset_s<='1' after 50 ns,'0' after 2000 ns; -- we disable reset and activate to see if we go back to init


end architecture FSM_KeyExpansion_tb_arch;

configuration FSM_KeyExpansion_tb_conf of FSM_KeyExpansion_tb is
    for FSM_KeyExpansion_tb_arch
        for FSM : FSM_KeyExpansion
            use entity LIB_RTL.FSM_KeyExpansion(FSM_KeyExpansion_Moore_arch);
        end for;
        for CO : Counter
            use entity LIB_RTL.Counter(Counter_arch);
        end for;
    end for;
end configuration FSM_KeyExpansion_tb_conf;




