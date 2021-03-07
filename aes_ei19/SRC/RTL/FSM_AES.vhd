library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

library LIB_AES;
use LIB_AES.crypt_pack.all;

entity FSM_AES is
  port (resetb_i : in std_logic;
        clock_i  : in std_logic;
        start_i  : in std_logic;

        reset_key_expander_o : out std_logic;
        start_key_expander_o : out std_logic;

        counter_aes_i        : in  bit4;
        reset_counter_aes_o  : out std_logic;
        enable_counter_aes_o : out std_logic;

        enableMixcolumns_o     : out boolean;
        enableRoundcomputing_o : out std_logic;
        enableOutput_o         : out std_logic;
        done_o                 : out std_logic);
end FSM_AES;

architecture FSM_AES_arch of FSM_AES is
  type state_type is (hold, init, round0, roundn, lastround, done);
  signal present_state, next_state : state_type;
  signal counter_s                 : integer range 0 to 10;
begin

  sequentiel : process(clock_i, resetb_i, counter_s)
  begin
    if resetb_i = '0' then
      present_state <= hold;
    elsif rising_edge(clock_i) then
      present_state <= next_state;
    end if;
  end process;

  C0 : process(present_state, start_i, counter_aes_i)
  begin
    case present_state is
      when hold=>
        if start_i = '1' then
          next_state <= init;
        else
          next_state <= hold;
        end if;
      when init =>        
        next_state <= round0;        
      when round0 =>
        next_state <= roundn;
      when roundn =>
        if counter_aes_i = x"9" then
          next_state <= lastround;
        else
          next_state <= roundn;
        end if;
      when lastround =>
        next_state <= done;
      when done =>
        if start_i = '1' then
          next_state <= done;
        else
          next_state <= hold;
        end if;
      when others =>
        next_state <= hold;
    end case;
  end process C0;

  C1 : process(present_state)
  begin
    case present_state is
      when hold=>
        reset_key_expander_o   <= '0';
        start_key_expander_o   <= '0';
        reset_counter_aes_o    <= '0';
        enable_counter_aes_o   <= '0';
        enableMixColumns_o     <= true;
        enableRoundcomputing_o <= '0';
        enableOutput_o         <= '0';
        done_o                 <= '0';
      when init =>
        reset_key_expander_o   <= '1';
        start_key_expander_o   <= '1';
        reset_counter_aes_o    <= '1';
        enable_counter_aes_o   <= '0';
        enableMixColumns_o     <= true;
        enableRoundcomputing_o <= '0';
        enableOutput_o         <= '0';
        done_o                 <= '1';
      when round0 =>
        reset_key_expander_o   <= '1';
        start_key_expander_o   <= '0';
        reset_counter_aes_o    <= '1';
        enable_counter_aes_o   <= '1';
        enableMixColumns_o     <= true;
        enableRoundcomputing_o <= '0';
        enableOutput_o         <= '0';
        done_o                 <= '1';
      when roundn =>
        reset_key_expander_o   <= '1';
        start_key_expander_o   <= '0';
        reset_counter_aes_o    <= '1';
        enable_counter_aes_o   <= '1';
        enableMixColumns_o     <= true;
        enableRoundcomputing_o <= '1';
        enableOutput_o         <= '0';
        done_o                 <= '1';
      when lastround =>
        reset_key_expander_o   <= '1';
        start_key_expander_o   <= '0';
        reset_counter_aes_o    <= '1';
        enable_counter_aes_o   <= '1';
        enableMixColumns_o     <= false;
        enableRoundcomputing_o <= '1';
        enableOutput_o         <= '0';
        done_o                 <= '1';
      when done =>
        reset_key_expander_o   <= '1';
        start_key_expander_o   <= '0';
        reset_counter_aes_o    <= '1';
        enable_counter_aes_o   <= '0';
        enableMixColumns_o     <= false;
        enableRoundcomputing_o <= '0';
        enableOutput_o         <= '1';
        done_o                 <= '0';
      when others=>
        reset_key_expander_o   <= '0';
        start_key_expander_o   <= '0';
        reset_counter_aes_o    <= '0';
        enable_counter_aes_o   <= '0';
        enableMixColumns_o     <= true;
        enableRoundcomputing_o <= '0';
        enableOutput_o         <= '0';
        done_o                 <= '0';

    end case;
  end process C1;

end FSM_AES_arch;

