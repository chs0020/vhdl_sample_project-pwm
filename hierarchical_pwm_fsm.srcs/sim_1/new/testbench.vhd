library ieee;
library pwm_utils;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use pwm_utils.all;

entity testbench is
end testbench;

architecture test_pwm of testbench is

    -- testbench clk generation to match 125 MHz clk
    signal clk : std_logic := '0';
    constant t_clk : time := 8 ns;

    -- target output signals of interest
    -- signal uut_pwm_out : std_logic;
    signal uut_pwm_div : std_logic;
    
    -- top divided clk control and div_clk output catch
    signal uut_clk_div_rst : std_logic;
    signal uut_div_clk : std_logic;

    -- pwm finite state machine
    signal uut_pwm_fsm_rst : std_logic;
    signal uut_pw_cnt : integer := 2;
    signal uut_pri_cnt : integer := 10;

begin

    -- UUT integration test
    UUT: entity pwm_utils.top 
    port map(
        main_clk => clk,
        -- pwm_out => uut_pwm_out,
        pwm_div => uut_pwm_div,
        clk_div_rst => uut_clk_div_rst,
        div_clk => uut_div_clk,
        pwm_fsm_rst => uut_pwm_fsm_rst
        -- pw_cnt => uut_pw_cnt,
        -- pri_cnt => uut_pri_cnt
    );
    
    -- DUT unitttest
    -- DUT_clk_div: entity pwm_utils.clk_divider
    -- port map (
    --     divisor => divisor,
    --     rst => clk_div_rst,
    --     clk_in => clk, 
    --     clk_out => divided_clk 
    -- );
    -- 
    -- DUT_pwm_fsm: entity pwm_utils.pwm_fsm
    -- port map (
    --     rst => pwm_fsm_rst,
    --     clk => divided_clk,
    --     pw_cnt => pw_cnt,
    --     pri_cnt => pri_cnt,
    --     pwm => pwm
    -- );

    -- generate test clk and reset toggles
    clk <= not clk after (t_clk / 2);
    uut_clk_div_rst <= '1', '0' after 50 ns;
    uut_pwm_fsm_rst <= '1', '0' after 50 ns;

end architecture test_pwm;