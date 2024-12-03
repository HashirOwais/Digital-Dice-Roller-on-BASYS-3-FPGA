
---

# **Digital Dice Roller on BASYS 3 FPGA**

## **Project Overview**
This project implements a **digital dice roller** with two dice using VHDL on the BASYS 3 FPGA. The design features:
- Two independent dice rollers, each generating values from 1 to 6.
- User-controlled rolling functionality via switches.
- Reset functionality to reset the dice to their initial states.
- Modular design utilizing an **internal module** (`Dice_Roller`) for dice rolling logic.
- User I/O components such as 7-segment displays, switches, and LEDs.

---

## **Project Requirements**
The project adheres to the following requirements:
1. **Synchronous Circuit**: Implements clock-driven processes for dice rolling.
2. **Internal Module**: The `Dice_Roller` module encapsulates the dice rolling logic.
3. **User I/O**:
   - A switch for rolling the dice (`roll`).
   - A switch to enable rolling of the second dice (`double_roll`).
   - LED to indicate when the dice are rolling.
   - 7-segment displays to display the values of the dice.
   - Reset switch to reset both dice to their initial states.

---

## **Theory of Operation**

### **Dice Rolling Logic**
The `Dice_Roller` module:
1. Generates dice values (`1` to `6`) using a counter.
2. Uses a clock divider to slow down the rolling for better visibility on the 7-segment display.
3. Handles user input (`roll` and `double_roll` switches) to control the rolling of each dice.

The **top-level module** (`Digital_Dice`) integrates this `Dice_Roller` module twice, providing the interface for 7-segment display control, reset functionality, and LED indication.

### **Design Choices**
- **Clock Divider**: Slows down the dice rolling speed to make the output visually readable.
- **Internal Module**: Encapsulation of dice logic in `Dice_Roller` promotes modularity and reusability.
- **Multiplexing**: Alternates between displaying the two dice on shared 7-segment control lines.
- **7-Segment Display Decoder**: Maps the binary dice values to corresponding 7-segment patterns for intuitive display.
- **LED Indicator**: Provides feedback on whether the dice are rolling.

---

## **User I/O**
1. **Switches**:
   - **`roll`**: Starts the rolling of both dice.
   - **`double_roll`**: Enables the rolling of the second dice in addition to the first.
   - **`reset`**: Resets both dice to their initial states (`1`).

2. **LED**:
   - Lights up when rolling is active (when `roll` is toggled on).

3. **7-Segment Display**:
   - Displays the value of the first dice on the first digit.
   - Displays the value of the second dice on the second digit (when `double_roll` is active).

---

## **Project Structure**
```
.
├── Digital_Dice.vhd       # Top-level module
├── Dice_Roller.vhd        # Internal module for dice rolling
├── Digital_Dice.xdc       # Constraints file for BASYS 3 FPGA
├── README.md              # Project documentation
```

---

## **Constraints File**
### **Basys-3-Master.xdc**
```vhdl
## Clock signal
set_property -dict { PACKAGE_PIN W5   IOSTANDARD LVCMOS33 } [get_ports clk]

## Switches
set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports reset]
set_property -dict { PACKAGE_PIN V16   IOSTANDARD LVCMOS33 } [get_ports roll]
set_property -dict { PACKAGE_PIN W18   IOSTANDARD LVCMOS33 } [get_ports double_roll]

## LEDs
set_property -dict { PACKAGE_PIN E19   IOSTANDARD LVCMOS33 } [get_ports roll_LED]

## 7-Segment Display (Segments)
set_property -dict { PACKAGE_PIN W7   IOSTANDARD LVCMOS33 } [get_ports {seg[0]}]
set_property -dict { PACKAGE_PIN W6   IOSTANDARD LVCMOS33 } [get_ports {seg[1]}]
set_property -dict { PACKAGE_PIN U8   IOSTANDARD LVCMOS33 } [get_ports {seg[2]}]
set_property -dict { PACKAGE_PIN V8   IOSTANDARD LVCMOS33 } [get_ports {seg[3]}]
set_property -dict { PACKAGE_PIN U5   IOSTANDARD LVCMOS33 } [get_ports {seg[4]}]
set_property -dict { PACKAGE_PIN V5   IOSTANDARD LVCMOS33 } [get_ports {seg[5]}]
set_property -dict { PACKAGE_PIN U7   IOSTANDARD LVCMOS33 } [get_ports {seg[6]}]

## 7-Segment Display (Anodes)
set_property -dict { PACKAGE_PIN U2   IOSTANDARD LVCMOS33 } [get_ports {an[0]}]
set_property -dict { PACKAGE_PIN U4   IOSTANDARD LVCMOS33 } [get_ports {an[1]}]
set_property -dict { PACKAGE_PIN V4   IOSTANDARD LVCMOS33 } [get_ports {an[2]}]
set_property -dict { PACKAGE_PIN W4   IOSTANDARD LVCMOS33 } [get_ports {an[3]}]

## Configuration options
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
```

---

## **How to Run**

1. **Set Up Vivado**:
   - Create a new project in Vivado.
   - Add `Digital_Dice.vhd` and `Dice_Roller.vhd` as design sources.
   - Add `Digital_Dice.xdc` as the constraints file.

2. **Synthesize and Implement**:
   - Run synthesis and implementation in Vivado.
   - Generate the bitstream file.

3. **Program the BASYS 3 FPGA**:
   - Use the generated bitstream file to program the BASYS 3 FPGA.

4. **Control the Dice**:
   - Use the `roll` switch to start the rolling.
   - Use the `double_roll` switch to enable or disable the second dice.
   - Use the `reset` switch to reset both dice values to `1`.
   - Observe the dice values on the 7-segment display and rolling indication on the LED.

---

## **Simulation**
For simulation:
- Test the functionality of the `Dice_Roller` module for both dice independently.
- Verify the integration of two `Dice_Roller` modules within `Digital_Dice` and the multiplexing logic.

---
