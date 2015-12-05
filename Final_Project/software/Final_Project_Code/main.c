#include <stdio.h>
#include <stdlib.h>

#define  sprite_xy 		(volatile int*) 0x00081030
#define  sw_to_hw 		(volatile int*) 0x00081020
#define  sprite_number 	(volatile int*) 0x00081040
#define  hw_to_sw		(volatile int*) 0x00081010

#define enemy_sprite 2
#define player_sprite1 1
#define x_bounds 640
#define y_bounds 480

typedef struct{
	int x_pos;
	int y_pos;
	int health;
	int id;
} player;

typedef struct{
	int x_pos;
	int y_pos;
	int health;
	int id;
	struct enemy *next;
} enemy;




void renderer(int x, int y, int sprite_num)
{
	*sprite_number = sprite_num;
	*sprite_xy = 1024*x + y;
	*sw_to_hw = 2;
	while(*hw_to_sw%2 != 0)
	{}
	*sw_to_hw = 0;
	while(*hw_to_sw != 1)
	{}
	*sw_to_hw = 1;
	return;
}

void render_background()
{
	renderer(0, 0, 0);
	return;
}

void render_sprites(player *first,player *second){
	render_background();
	if(first==NULL || second ==NULL){
		printf("players not instantiated");
	}
	else{
		renderer(first->x_pos,first->y_pos,first->id);
		renderer(second->x_pos,second->y_pos,second->id);
	}

}
void init_players(player *first,player *second){
	if(first==NULL || second ==NULL)
	{
		printf("players not instantiated");
	}
	else{
		first->x_pos = 300,
		first->y_pos = 400;
		first->health = 3;
		first->id=player_sprite1;
		second->x_pos= 200;
		second->y_pos= 200;
		second->health=3;
		second->id = player_sprite1;
	}
}

int main()
{
	int i;
	player *first=(player *)malloc(sizeof(player));
	player *second=(player *)malloc(sizeof(player));
	init_players(first,second);

	while(1)
	{
		render_sprites(first,second);

		if((first->x_pos+64+32) < x_bounds){
			first->x_pos+=32;
		}
		if(second->y_pos-32 > 0 ){
			second->y_pos-=32;
		}


	}
	free(first);
	free(second);
  return 0;
}
