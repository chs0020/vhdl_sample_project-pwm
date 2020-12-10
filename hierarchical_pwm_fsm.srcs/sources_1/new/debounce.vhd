library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc;

entity debounce is
    generic (
        n_buf : integer := 5
    );

    port (
        data : in std_logic;
        clk: in std_logic;
        op_data : out std_logic
    );
end debounce;

architecture Behavioral of debounce is

    -- create reg to act as a debounce buffer
    signal debounce_reg : std_logic_vector(n_buf-1 downto 0);
    signal count : integer := 0;
    
    constant cnt_rst : std_logic := '1';
    constant all_ones : std_logic_vector(debounce_reg'range) := (others => '1');

begin

    -- create 5 flip flops to store btn states of 5 clk cycles
    update_debounce_reg: process(clk)
    begin

        -- circle the reg with mod logic
        if rising_edge(clk) then
                debounce_reg(count) <= data;
                count <= (count + 1) mod n_buf;
        end if;

    end process update_debounce_reg;
    
    -- compare debounce reg with full register
    op_data <= '1' when (debounce_reg = all_ones) else '0';

end Behavioral;
