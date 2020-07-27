library ieee;
library pwm_utils;
use ieee.std_logic_1164.all;
use pwm_utils.all;

entity top is
    port (
        main_clk : in std_logic;
        pwm_out  : out std_logic
    );
end top;

architecture struct of top is

    -- define a constant integer 125 clock division factor
    -- to bring coraz7 default vhdl clock down to 1 MHz
    constant divisor : std_logic_vector(7 downto 0) := "01111101";
    
    -- clk divider signals
    signal clk_div_rst : std_logic := '0';
    signal divided_clk : std_logic;
    
    -- pwm fsm logic signals
    signal pwm_fsm_rst : std_logic := '0';
    signal pw_cnt : integer := 2;
    signal pri_cnt : integer := 10;
    
begin

    clk_divide : entity pwm_utils.clk_divider
    port map (
        divisor, clk_div_rst, main_clk, divided_clk 
    );

    pwm_fsm : entity pwm_utils.pwm_fsm
    port map (
        pwm_fsm_rst, divided_clk, pw_cnt, pri_cnt, pwm_out
    );

end struct;
