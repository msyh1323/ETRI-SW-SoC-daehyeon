/*
 * main.c
 *
 *  Created on: 2019. 8. 17.
 *      Author: user
 */


#include "xparameters.h"
#include "myip456.h"
#include "xil_io.h"
#include "xil_printf.h"

int main(void)
{

		xil_printf("DATA WRITE DONE\r\n");
		for(int i=0; i<1024; i++){
			MYIP456_mWriteReg(0x43c01000,i*4,1);
		}

		for(int i=0; i<25; i++){
			MYIP456_mWriteReg(0x43c02000,i*4,i+1);
		}

		xil_printf("DATA WRITE DONE\r\n");

		for(int i=0; i<1024; i++){
			xil_printf("output, ADDR: %x, value: %d\r\n",0x43c01000+i*4,MYIP456_mReadReg(0x43c01000,i*4));
		}

		for(int i=0; i<25; i++){
			xil_printf("output, ADDR: %x, value: %d\r\n",0x43c02000+i*4,MYIP456_mReadReg(0x43c02000,i*4));
		}
		xil_printf("DATA WRITE DONE\r\n");

		MYIP456_mWriteReg(0x43C00000, 0x0, 0xFFFFFFFF);
		xil_printf("CONVOLUTION START\r\n");

		while(MYIP456_mReadReg(0x43C00000, 0x4) != 0xFFFFFFFF);
		xil_printf("CONVOLUTION DONE\r\n");

		for(int i=0; i<784; i++){
			xil_printf("output, ADDR: %x, value: %d\r\n",0x43C03000+i*4,MYIP456_mReadReg(0x43C03000,i));
		}

		return 0;
}
