#include <stdio.h>

	static volatile int* sprite_xy = (unsigned int*) 0x00011030;
	static volatile int* sw_to_hw = (unsigned int*) 0x00011020;
	static volatile int* sprite_number = (unsigned int*) 0x00011040;
	static volatile int* hw_to_sw = (unsigned int*) 0x00011010;


int main()
{
	int  i;

	while(1)
	{
		*sprite_number = 0;
		*sprite_xy = 0;
		*sw_to_hw = 2;
		while(*hw_to_sw < 2)
		{
		}
		*sw_to_hw = 0;
		while(*hw_to_sw != 1)
		{}
		*sw_to_hw = 1;



		*sprite_number = 2;
		*sprite_xy = 0;
		*sw_to_hw = 2;
		while(*hw_to_sw < 2)
		{
		}
		*sw_to_hw = 0;
		while(*hw_to_sw != 1)
		{}
		*sw_to_hw = 1;


	}

  return 0;
}
