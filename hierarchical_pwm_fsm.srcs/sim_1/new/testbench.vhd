library ieee;
library pwm_utils;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use pwm_utils.all;

entity testbench is
end testbench;

architecture test_pwm of testbench is

    signal clk : std_logic := '0';
    signal pwm : std_logic;
    constant t_clk : time := 8 ns;
    
    -- clk divider signals
    constant divisor : std_logic_vector(7 downto 0) := "01111101";

    signal clk_div_rst : std_logic;
    signal divided_clk : std_logic;
    
    -- pwm finite state machine signals
    signal pwm_fsm_rst : std_logic;
    signal pw_cnt : integer := 2;
    signal pri_cnt : integer := 10;

begin

    -- UUT: entity pwm_utils.top 
    -- port map(
    --     main_clk => clk,
    --     pwm_out => pwm
    -- );
    
    DUT_clk_div: entity pwm_utils.clk_divider
    port map (
        divisor => divisor,
        rst => clk_div_rst,
        clk_in => clk, 
        clk_out => divided_clk 
    );
    
    DUT_pwm_fsm: entity pwm_utils.pwm_fsm
    port map (
        rst => pwm_fsm_rst,
        clk => divided_clk,
        pw_cnt => pw_cnt,
        pri_cnt => pri_cnt,
        pwm => pwm
    );

    clk <= not clk after (t_clk / 2);
    clk_div_rst <= '1', '0' after 50 ns;
    pwm_fsm_rst <= '1', '0' after 50 ns;

end architecture test_pwm;