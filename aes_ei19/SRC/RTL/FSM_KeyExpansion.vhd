-- FSM KeyExpansion - Yavuz AKIN
-- 15/12/20


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

library LIB_AES;
use LIB_AES.crypt_pack.all;


entity FSM_KeyExpansion is
    port (
        start_i : in std_logic; -- the start,clock,reset signals are given by KeyExpanderI_O
        clock_i : in std_logic; 
        reset_i : in std_logic;
        counter_i : in bit4;  -- it comes from the Counter

        enable_o : out std_logic; -- goes to the Counter and register
        reset_counter_o : out std_logic -- goes to Counter
    );
  end FSM_KeyExpansion;

-- Moore architecture
architecture FSM_KeyExpansion_Moore_arch of FSM_KeyExpansion is 

    type state_type is (init,count,stop1);
    signal present_state, next_state : state_type;

    begin 

    sequentiel : process(clock_i, reset_i, counter_i)
    -- Sequentiel helps getting to the next state at each rising edge and comes back to init state in case of reset
        begin
            if reset_i = '0' then
                present_state <= init;
            elsif rising_edge(clock_i) then
                present_state <= next_state;
            end if;
    end process;


    C0 : process(present_state, start_i, counter_i)
    -- C0 codes the transitions and the transition conditions between states
    begin
      case present_state is
        when init=>
          if start_i = '1' then
            next_state <= count;
          else
            next_state <= init;
          end if;
        when count => 
            if counter_i=X"9" then    -- we need to stop at 9 if we want to count 10 times    
                next_state <= stop1;
            else 
                next_state<=count;
            end if;        
        when stop1 =>
            if start_i='0' then
                next_state <=init;
            else 
                next_state<= stop1;
            end if; 
      end case;
    end process C0;


    C1 : process(present_state)
    -- C1 codes the changes that happen in each state
    begin
      case present_state is
        when init=>
            enable_o               <= '0';
            reset_counter_o        <= '0';
        when count =>
            enable_o               <= '1';
            reset_counter_o        <= '1';
        when stop1=>
            enable_o               <= '0';
            reset_counter_o        <= '1';
  
      end case;
    end process C1;


    end FSM_KeyExpansion_Moore_arch;