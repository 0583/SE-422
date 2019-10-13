
# Memory Phase

What does `Memory` mean in the microcomputer context?

It is formally named Random-access memory (RAM). The "Random Access" prefix means it could be quickly read and written instantly. But the more specific name might be the "Main Memory", while the memory could be confusing and misleading when being compared with the Disk Storage and Smaller Cache Memory.

## Types of RAM

### SRAM

SRAM, the abbreviation of Static Random Access Memory seems like lots of pivots that has two steady states: 0 and 1. As long as the external power didn't go down, the single pivot would keep its state continuously.

SRAM is constructed with an CMOS Static Inverter, making it stable enough dealing with the outter noise. However its structure is much more sophisticated than the Dynamic ones, causing its high price and limited size.[1]

[See CMOS_Inverter](https://zh.wikipedia.org/wiki/File:CMOS_Inverter.svg)

### DRAM

DRAM, the abbreviation of Dynamic Random Access Memory. The difference between SRAM and DRAM is DRAM's pivots are not so steady. They can't store their states well since they're literally just capacitances. The 0 or 1 was distincted by how much electric charge it carries. So the real-world capacitance's "wear and tear" effect could differentiate the bits' value.

So if we want to keep DRAM's value, we have to flush it with external electrical pulse periodically to ensure its electric charge didn't wore off.

### Comparisons

* Both SRAM and DRAM would lost all data when the external power is cut off. So they're all "volatile".

* Both SRAM and DRAM can be instantly read and written to with basically equal speed. (However the SRAM will be slightly faster.)

* SRAM uses the CMOS Static Inverter as its low-level implementation, while the DRAM uses simpler electrical capacitances.

* SRAM's complicated structure makes it more expensive, and makes it impossible to build SRAM with large-capacity. However DRAM has a way more simple (but not-so-reliable) structure, making it affordable and scalable.

### Usages

Since SRAM's unaffordable price and unscalable capacity, now it's merely used to build the Cache layers. Taking that apart, DRAM is the main technique we use to build the main memory that has bigger size.

## Statistics

### Size

Maybe the size is the top-sight that everyone's willing to pay for. Since people expect the memory to be a free block of space containing the program runtime information, the size is absolutely the first thing to be consider, both for the end user and the developers.

There's a plain method to grab a piece of the main memory: with a pointer. A developer should be able to tell that the size of the main memory is mapped in the physical memory space, which is merely used in the CPU internal calculation, while applications running in the user mode could only use the virtual memory address. The virtual memory space doesn't really mapped to the physical memory size, but could be dynamically adjusted. So even if you don't have enough memory in your PC, you might never occurs to the error called "No Enough Memory". You may just feel it running extremely slowly, which is a sign of frequently page-in and page-out.

What's more, how the memory is initialized is also very interesting.[3] We will take the legacy Intel + BIOS combination of booting method as an example. When the computer boots up, the BIOS (Basic Input-Ouput System) would starts the CPU and makes it running under the REAL MODE, which was initially used in the Intel 8086 series.[4] Under that traditional mode, the memory address was hard-wired and could the address space was limited between  `0x00000~0xFFFFF`, exactly `1 MiB`. That's where the boot block lies in. After the boot codes are all executed, the main memory would be initialized and the CPU would also turns to the Protected Mode.

There's also an interesting fact about Windows 98, that Windows cannot boot when the PC were equipped with more than 1 GiB main memory. That's just because Windows 9x is a 16-bit and 32-bit mixing OS, and an conversion would be operated when the OS boots up. And here's the problem: When we're going to initialize the 32-bit Memory manager, we have to allocate some memory first to save some necessary information that the memory manager relies on. And in the older Windows implementation, that's a fixed value which couldn't store enough data that records memory manager metadata for 1 GiB such. So the system would refuse to boot because it cannot initialize the Memory manager.[5]

Fortunately it was fixed in the later Windows NT series.

### Frequency

### Generation

## Cool Technology

### Dual-Channel

## Prices

## Comments

## References

`[1]`  `https://zh.wikipedia.org/wiki/随机存取存储器`, Memory, Wikipedia

`[2]` `https://blog.gtwang.org/tips/effect-of-ram-size-and-frequency/`, G. T. Wang's Personal Blog.

`[3]` `https://zhuanlan.zhihu.com/p/26387396`, Lao Lang, 内存初始化浅析

`[4]` `http://chuquan.me/2016/12/14/computer-boot-process/`, Computer Boot Process

`[5]` The Old New Thing, Windows 开发启示录, Raymond Chen
