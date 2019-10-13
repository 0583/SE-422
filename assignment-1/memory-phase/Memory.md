
# Memory Phase

What does `Memory` mean in the microcomputer context?

It is formally named Random-access memory (RAM). The "Random Access" prefix means it could be quickly read and written instantly.

## Types of RAM

### SRAM

SRAM, the abbreviation of Static Random Access Memory seems like lots of pivots that has two steady states: 0 and 1. As long as the external power didn't go down, the single pivot would keep its state continuously.

SRAM is constructed with an CMOS Static Inverser, making it stable enough dealing with the outter noise. However its structure is much more sophisticated than the Dynamic ones, causing its high price and limited size.

![CMOS](https://zh.wikipedia.org/wiki/File:CMOS_Inverter.svg)

### DRAM

DRAM, the abbreviation of Dynamic Random Access Memory. The difference between SRAM and DRAM is DRAM's pivots are not so steady. They can't store their states well since they're literally just capacitances. The 0 or 1 was distincted by how much electric charge it carries. So the real-world capacitance's "wear and tear" effect could differentiate the bits' value.

So if we want to keep DRAM's value, we have to flush it with external electrical pulse periodically to ensure its electric charge didn't wore off.

### Comparisons

* Both SRAM and DRAM would lost all data when the external power is cut off. So they're all "volatile".

* Both SRAM and DRAM can be instantly read and written to with basically equal speed. (However the SRAM will be slightly faster.)

* SRAM uses the CMOS Static Inverser as its low-level implementation, while the DRAM uses merely electrical capacitances.

* SRAM's complicated structure makes it more expensive, and makes it impossible to build SRAM with large-capacity. However DRAM has a way more simple (but not-so-reliable) structure, making it affordable and scalable.

