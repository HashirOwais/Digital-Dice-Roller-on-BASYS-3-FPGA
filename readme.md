
# **Digital Dice Roller on BASYS 3 FPGA**

## **Project Overview**
This project implements a digital dice roller using VHDL on the BASYS 3 FPGA. The design features:
- A single dice roller with values ranging from 1 to 6.
- User-controlled rolling functionality via switches.
- Reset functionality to reset the dice to its initial state.
- Modular design utilizing an **internal module** (`Dice_Roller`) for dice rolling logic.
- User I/O components such as 7-segment displays, switches, and LEDs.

---

## **Project Requirements**
The project adheres to the following requirements:
1. **Synchronous Circuit**: Implements clock-driven processes for dice rolling.
2. **Internal Module**: The `Dice_Roller` module encapsulates the dice rolling logic.
3. **User I/O**:
   - Switch for rolling the dice.
   - LED to indicate when the dice is rolling.
   - 7-segment display to display the dice value.
   - Reset switch to reset the state of the dice.

---

## **Theory of Operation**

### **Dice Rolling Logic**
The `Dice_Roller` module:
1. Generates dice values (`1` to `6`) using a counter.
2. Uses a clock divider to slow down the rolling for better visibility on the 7-segment display.
3. Handles user input (`roll` switch) to start and stop the rolling.

The **top-level module** (`Digital_Dice`) integrates this `Dice_Roller` module, providing the interface for 7-segment display control, reset functionality, and LED indication.

### **Design Choices**
- **Clock Divider**: Slows down the dice rolling speed to make the output visually readable.
- **Internal Module**: Encapsulation of dice logic in `Dice_Roller` promotes modularity and reusability.
- **7-Segment Display Decoder**: Maps the binary dice values to corresponding 7-segment patterns for intuitive display.
- **LED Indicator**: Provides feedback on whether the dice is rolling.

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
### **Basys-3-Master.xdc **
```vhdl
## Clock signal
set_property -dict { PACKAGE_PIN W5   IOSTANDARD LVCMOS33 } [get_ports clk]

## Switches
set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports reset]
set_property -dict { PACKAGE_PIN V16   IOSTANDARD LVCMOS33 } [get_ports roll]

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
   - Use the `roll` switch to start and stop the dice rolling.
   - Use the `reset` switch to reset the dice value to 1.
   - Observe the dice value on the 7-segment display and rolling indication on the LED.

---

## **Simulation**
For simulation:
- Test the functionality of the `Dice_Roller` module in isolation.
- Verify the integration of `Dice_Roller` within `Digital_Dice`.
