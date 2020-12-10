library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity pwm_fsm is
    port(
        rst: in std_logic;
        clk: in std_logic;
        pw_cnt: in integer;
        pri_cnt: in integer;
        pwm: out std_logic
    );
end pwm_fsm;

architecture pwm_gen of pwm_fsm is

    type StateType is (pulse_on, pulse_off);
    signal present_state : StateType := pulse_off;
    signal next_state : StateType := pulse_off;
    
    signal clk_cnt : integer := 0;

begin

    state_comb: process(clk_cnt, pw_cnt, pri_cnt, present_state) 
    begin
        
        case present_state is                
                    
            when pulse_on => 
                pwm <= '1';

                if (clk_cnt >= (pw_cnt - 1)) then
                    next_state <= pulse_off;
                else
                    next_state <= pulse_on;
                end if;
            
            when pulse_off =>
                pwm <= '0';

                if (clk_cnt = (pri_cnt - 1)) then
                    next_state <= pulse_on;
                else
                    next_state <= pulse_off;
                end if;
    
        end case;

    end process state_comb;
    
    state_clkd: process(clk, rst)
    begin

        if rst = '1' then

            clk_cnt <= 0;
            present_state <= pulse_off;

        elsif rising_edge(clk) then

            present_state <= next_state;

            if (clk_cnt < (pri_cnt - 1)) then
                clk_cnt <= clk_cnt + 1;
            else
                clk_cnt <= 0;
            end if;

        else
            present_state <= present_state;
        end if;
    
    end process state_clkd;

end pwm_gen;
