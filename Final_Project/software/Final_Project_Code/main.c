
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "keyboard_functions.h"


int main(void){
	setup_keyboard();
	unsigned int keycode1;
	unsigned int keycode2;
	int i=0;
	while(1)
		{
			if(get_keycode(&keycode1,&keycode2)==0){
				printf("%04x %04x\n",keycode1,keycode2);
				for(i=0;i<10000;i++);
			}

		}
}

