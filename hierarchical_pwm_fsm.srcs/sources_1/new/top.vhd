library ieee;
library pwm_utils;
use ieee.std_logic_1164.all;
use pwm_utils.all;

entity top is
    port (
        -- main io
        main_clk : in std_logic;
        -- pwm_out  : out std_logic;
        pwm_div  : out std_logic;
        
        -- clk division for reasonable gpio output
        signal clk_div_rst : in std_logic;
        signal div_clk : out std_logic;
        
        -- pwm fsm control and settings
        signal pwm_fsm_rst : in std_logic
        -- signal pw_cnt : in integer := 2;    -- saved for the SPI comms receiver
        -- signal pri_cnt : in integer := 10
    );
end top;

architecture struct of top is

    -- define a constant integer 125 clock division factor
    -- to bring coraz7 default vhdl clock down to 1 MHz
    constant divisor : std_logic_vector(7 downto 0) := "01111101";
    signal divided_clk : std_logic;
    
    -- debounce filtered rst signal lines
    signal debounced_rst_clk : std_logic;
    signal debounced_rst_pwm : std_logic;
    
    -- hardcode the pwm signal for now
    signal hard_pw_cnt : integer := 2;    -- TODO: delete these when SPI comms done
    signal hard_pri_cnt : integer := 10;
    
begin

    -- hardcode the 

    -- Debounce reset signals
    deb_pwm_clk : entity pwm_utils.debounce
    port map(
        data => pwm_fsm_rst,
        clk => main_clk,
        op_data => debounced_rst_clk
    );

    deb_pwm_rst : entity pwm_utils.debounce
    port map(
        data => pwm_fsm_rst,
        clk => main_clk,
        op_data => debounced_rst_pwm
    );

    -- Internal div 125 clk divider
    clk_divide : entity pwm_utils.clk_divider
    port map (
        divisor => divisor,
        rst => clk_div_rst,
        clk_in => main_clk,
        clk_out => divided_clk
    );

    -- PWM generator with main 125 MHz clk
    -- pwm_fsm : entity pwm_utils.pwm_fsm
    -- port map (
    --     rst => pwm_fsm_rst,
    --     clk => main_clk,
    --     pw_cnt => hard_pw_cnt,
    --     pri_cnt => hard_pri_cnt,
    --     pwm => pwm_out
    -- );
    
    -- PWM generator with a divided clk
    pwm_fsm_div : entity pwm_utils.pwm_fsm
    port map (
        rst => pwm_fsm_rst,
        clk => divided_clk,
        pw_cnt => hard_pw_cnt,
        pri_cnt => hard_pri_cnt,
        pwm => pwm_div
    );
    
    -- give user access to 1 MHz divided clk
    div_clk <= divided_clk;

end struct;
