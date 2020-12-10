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
    signal last_clk : std_logic := '0';

begin

    special_cnt_div : process (clk_in, rst)
    begin

        if rising_edge(clk_in) then
 
            if (rst = '1') then
                cnt <= (others => '0');
                last_clk <= '0';
                clk_out <= '0';
            elsif (divisor = cnt) then
                cnt <= (others => '0');
                last_clk <= not last_clk;
                clk_out <= last_clk;
            else
                cnt <= cnt + '1';
                last_clk <= last_clk;
                clk_out <= last_clk;
            end if;
        end if;
     
     end process special_cnt_div;

end Behavioral;