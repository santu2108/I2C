# I2C
I2C is a communication protocol generally used for short-distance communication within devices. Through this project, we tried to implement the I2C protocol on the Basys3 board by using Vivado.

Our model of it consists of a top module, and within that, there are master and slave modules that communicate with each other using two wires, namely SDA and SCL lines. The SCL line is for the clock signal, so that both of them are synchronised, and the SDA line is used for the main data communication.

Basic operations of our model:

Start condition In this, the sda line is pulled low before the scl line, indicating the communication initiation.
Address (7 bits) Every slave is given a unique address, so this is sent over the sda line to see if the address matches any of the slaves’ addresses.
Read/Write (1 bit) This indicates the mode of operation of the master, whether it reads from the slave or writes data to the slave.
Acknowledgement (1 bit) If the address sent on the sda line matches any of the slaves, then the respective slave pulls down the sda line low for one bit to indicate the address has matched.
Data (4 bits or 8 bits) Based on the read/write bit, the master or the slave writes the data in this state.
Acknowledgement (1 bit) The module which receives the data sends this as an indication that the data has been successfully received.
Stop condition The scl line switches to high before the sda line switches to high.
References

I2C playlist by All About VLSI: https://youtube.com/playlist?list=PLqPfWwayuBvMUMUfSPQU6Ao-04mp7hAcN&si=0dQbqFSGmHnDZL6W This is a good playlist not only for the Verilog part but also to learn about the basic functioning of I2C. We used this as a basic reference upon which we have built our project.

State Machines using VHDL: FPGA Implementation of Serial Communication and Display Protocols by Orhan Gazi (Author), A.Çağrı Arlı (Author). This book can be referred to further explore and learn about I2C in depth.
