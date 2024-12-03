----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Hashir Owais (200483044)
-- 
-- Create Date: 
-- Design Name: Digital Dice
-- Module Name: Digital_Dice
-- Project Name: Digital Dice Roller
-- Description: Top-level module for a two-dice roller system.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Digital_Dice is
    Port (
        clk         : in  std_logic;               -- System clock
        reset       : in  std_logic;               -- Reset button
        roll        : in  std_logic;               -- Switch to roll dice
        double_roll : in  std_logic;               -- Switch to activate second dice
        seg         : out std_logic_vector(6 downto 0); -- 7-segment display segments
        an          : out std_logic_vector(3 downto 0); -- 7-segment display anodes
        roll_LED    : out std_logic                -- LED indicating dice is rolling
    );
end Digital_Dice;

architecture Behavioral of Digital_Dice is

    -- Declare the component for Dice_Roller
    component Dice_Roller
        Port (
            clk     : in  std_logic;
            reset   : in  std_logic;
            roll    : in  std_logic;
            slow_clk: in  std_logic;
            dice_out: out std_logic_vector(2 downto 0)
        );
    end component;

    -- Internal signals
    signal slow_clock            : unsigned(23 downto 0) := "000000000000000000000000"; -- Shared slow clock
    signal dice1_value           : std_logic_vector(2 downto 0); -- First dice output
    signal dice2_value           : std_logic_vector(2 downto 0); -- Second dice output
    signal display_value         : std_logic_vector(2 downto 0); -- Value sent to the 7-segment display
    signal multiplexer_swap_clock: unsigned(15 downto 0) := "0000000000000000"; -- Clock for multiplexing
    signal digit_select          : unsigned(1 downto 0) := "00"; -- Digit selection counter
    -- Declare intermediate signal for combined roll
signal combined_roll : std_logic;

begin
-- Process to calculate combined_roll
process(roll, double_roll)
begin
    combined_roll <= roll and double_roll;
end process;

    -- Shared Clock Divider
    -- This process creates a slower clock signal by incrementing a counter on every rising edge of the system clock.
    -- The slower clock is used to control the timing of the dice value updates, ensuring that the dice roll at a human-perceptible rate.
    process(clk)
    begin
        if (clk = '1' and clk'event) then
            if reset = '1' then
                slow_clock <= "000000000000000000000000"; -- Reset to explicit 0
            else
                slow_clock <= slow_clock + 1;
            end if;
        end if;
    end process;

    -- Instantiate Dice_Roller for Dice 1
    -- This component generates the dice value for the first dice, controlled by the `roll` signal.
    -- It uses the slow_clock(23) as the slower clock for rolling updates.
    Dice1: Dice_Roller
        port map (
            clk      => clk,
            reset    => reset,
            roll     => roll,
            slow_clk => slow_clock(23), -- Slow clock for Dice 1
            dice_out => dice1_value
        );

    -- Instantiate Dice_Roller for Dice 2
    -- This component generates the dice value for the second dice, controlled by both the `roll` and `double_roll` signals.
    -- It uses the slow_clock(22) as the slightly faster clock for rolling updates.
    Dice2: Dice_Roller
        port map (
            clk      => clk,
            reset    => reset,
            roll     => combined_roll, -- Rolling controlled by double_roll
            slow_clk => slow_clock(22),      -- Slightly faster clock for Dice 2
            dice_out => dice2_value
        );

    -- Multiplexing Process
    -- This process alternates between the two dice values for display on the shared 7-segment control lines.
    -- The digit_select signal determines which digit is active, controlled by the slower multiplexer_swap_clock.
    process(clk)
    begin
        if (clk = '1' and clk'event) then
            if reset = '1' then
                multiplexer_swap_clock <= "0000000000000000"; -- Reset to explicit 0
                digit_select <= "00"; -- Reset to first digit
                an <= "1111"; -- Turn off all digits
            else
                if multiplexer_swap_clock = "1111111111111111" then -- Max value for 16-bit counter
                    multiplexer_swap_clock <= "0000000000000000"; -- Reset to explicit 0
                    digit_select <= digit_select + 1;
                else
                    multiplexer_swap_clock <= multiplexer_swap_clock + 1;
                end if;

                case digit_select is
                    when "00" =>
                        an <= "1110"; -- Activate first digit
                        display_value <= dice1_value;
                    when "01" =>
                        if double_roll = '1' then
                            an <= "1101"; -- Activate second digit
                            display_value <= dice2_value;
                        else
                            an <= "1111"; -- Turn off if double_roll not active
                            display_value <= "000";
                        end if;
                    when others =>
                        an <= "1111"; -- Turn off all displays
                        display_value <= "000";
                end case;
            end if;
        end if;
    end process;

    -- 7-Segment Display Decoder
    -- Converts the 3-bit binary value of display_value into the corresponding 7-segment pattern.
    process(display_value)
    begin
        case display_value is
            when "001" => seg <= "1111001"; -- 1
            when "010" => seg <= "0100100"; -- 2
            when "011" => seg <= "0110000"; -- 3
            when "100" => seg <= "0011001"; -- 4
            when "101" => seg <= "0010010"; -- 5
            when "110" => seg <= "0000010"; -- 6
            when "000" => seg <= "1111111"; -- Blank display
            when others => seg <= "1111111"; -- Default blank display
        end case;
    end process;

    -- Roll LED
    -- Lights up the roll_LED whenever the roll signal is active.
    roll_LED <= roll;

end Behavioral;
