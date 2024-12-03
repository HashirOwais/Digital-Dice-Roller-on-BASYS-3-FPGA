----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Hashir Owais (200483044)
-- 
-- Create Date: 
-- Design Name: Dice Roller
-- Module Name: Dice_Roller
-- Project Name: Digital Dice Roller
-- Description: Internal module for rolling a single dice.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Dice_Roller is
    Port (
        clk     : in  std_logic;               -- System clock
        reset   : in  std_logic;               -- Reset button
        roll    : in  std_logic;               -- Rolling control signal
        slow_clk: in  std_logic;               -- Slower clock signal
        dice_out: out std_logic_vector(2 downto 0) -- 3-bit dice output (1-6)
    );
end Dice_Roller;

architecture Behavioral of Dice_Roller is
    signal count : unsigned(2 downto 0) := "001"; -- Internal counter for dice
begin

    -- Dice rolling process
    -- This process controls the dice value. The value increments from 1 to 6 and loops back to 1.
    -- It is triggered by the roll signal and controlled by the slow_clk.
    -- If the reset signal is active, the dice value resets to 1.
    process(clk)
    begin
        if (clk = '1' and clk'event) then
            if reset = '1' then
                count <= "001"; -- Reset dice value to 1
            elsif roll = '1' and slow_clk = '1' then
                if count = "110" then -- If count reaches 6, loop back to 1
                    count <= "001";
                else
                    count <= count + 1;
                end if;
            end if;
        end if;
    end process;

    -- Output the dice value
    -- Converts the internal count signal into a std_logic_vector output.
    dice_out <= std_logic_vector(count);

end Behavioral;