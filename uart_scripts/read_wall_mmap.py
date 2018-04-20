''' 
This program runs on the vacuum, searches for the wall sensor data in the mmap'd
/dev/uart_mcu memory space, and prints out the wall sensor byte.

Requires uart_test to be running concurrently in order to get data.

It is very slow and does not show updates to sensor data in real time.
'''
import os
import mmap

start_str = '0x0,0x0,0x40,0x2'
if __name__ == '__main__':
	fd = os.open('/dev/uart_mcu', os.O_RDONLY)
	mfile = mmap.mmap(fd, 16384, prot=mmap.PROT_READ)
	index = -1
	while True:
		if index == -1:
			curr = map(lambda c: hex(ord(c)), mfile[::])
			curr = ','.join(curr)
			index = 0
		index = curr.find(start_str, index+1)
		print curr[index+len(start_str):index+len(start_str)+5]
		#print index
