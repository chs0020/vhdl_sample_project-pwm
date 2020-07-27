library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity clk_divider is
    port(
        divisor : in std_logic_vector(7 downto 0);
        rst     : in std_logic;
        clk_in  : in std_logic;
        clk_out : out std_logic
    );
end clk_divider;

architecture Behavioral of clk_divider is

    signal cnt : std_logic_vector(7 downto 0);
    signal tmp : std_logic := '0';

begin

    special_cnt_div : process (clk_in, rst) begin
    
        if (rst = '1') then
            cnt <= (others => '0');
            tmp <= '0';
            clk_out <= tmp;
        elsif rising_edge(clk_in) then
            if (cnt = divisor) then
                cnt <= (others => '0');
                tmp <= not tmp;
                clk_out <= tmp;
            else
                cnt <= cnt + '1';
            end if;
        end if;
     
     end process special_cnt_div;

end Behavioral;