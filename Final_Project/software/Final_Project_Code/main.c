
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "keyboard_functions.h"

#define  sprite_xy 		(volatile int*) 0x00081090
#define  sw_to_hw 		(volatile int*) 0x00081080
#define  sprite_number 	(volatile int*) 0x000810A0
#define  hw_to_sw		(volatile int*) 0x00081070



#define enemy_sprite 3
#define player1_sprite 0
#define player2_sprite 1
#define player_bullet 13
#define x_bounds 639
#define y_bounds 479


typedef struct{
	int x_pos;
	int y_pos;
	int health;
	int id;
	int old_x;
	int old_y;
} player;

typedef struct enemy{
	int x_pos;
	int y_pos;
	int health;
	int id;
	int old_x;
	int old_y;
	struct enemy *next;
} enemy;

typedef struct player_projectile{
	int x_pos;
	int y_pos;
	int old_x;
	int old_y;
	struct player_projectile *next;
} player_projectile;



//Init
void init_players(player *first,player *second);
void make_enemy(enemy **em);

//count enemies
int count_enemies(enemy *em);

//Delete enemies
enemy * delete_enemy(enemy *curr);

//Move
void move_player(player *current, int x_pos, int y_pos);
void move_enemy(enemy *current, int x_pos, int y_pos);
void move_enemies(enemy *em);
void move_projectiles(player_projectile *head);
void move_projectile(player_projectile *head);

//Render Check
int render_player_check(player *current);
int render_enemy_check(enemy *current);

//Render
void renderer(int x, int y, int sprite_num, int is_shadow);
void render_shadows_player(player *first,player *second);
void render_shadow_enemy(enemy *enemy);
void render_enemy(enemy *em);
void render_enemies(enemy *em);
void render_players(player *first,player *second);
void render_projectiles(player_projectile *head);
void render_projectile(player_projectile *pr);


//Render
player_projectile* fire_projectile(player *current, player_projectile *head);

//Keycode
int keycode_effect(player *first,player *second,unsigned int *arr, player_projectile **bullet,  int can_fire_n);
void parse_keycode(unsigned int *arr,unsigned int keycode1,unsigned int keycode2);

//Hits
player_projectile* check_projectiles(player_projectile *curr, enemy *em);
int hits_enemy(int x, int y, enemy *em);


int main(void){
	setup_keyboard();
	unsigned int keycode1,keycode2;
	player *first=(player *)malloc(sizeof(player));
	player *second=(player *)malloc(sizeof(player));
	int i=0;
	int num_of_enemies=0;
	enemy *head_enemies=NULL;
	player_projectile *head_bullets=NULL;
	init_players(first,second);
	render_players(first,second);
	unsigned int arr[4]={0,0,0,0};
	while(1)
		{
			move_projectiles(head_bullets);
			render_projectiles(head_bullets);
			if(get_keycode(&keycode1,&keycode2)==0){
				parse_keycode(arr,keycode1,keycode2);
				if(keycode_effect(first,second,arr,&head_bullets,i%5)==1){
				render_players(first,second);
				}
			}
			if(num_of_enemies<3){
				make_enemy(&head_enemies);
			}
			render_enemies(head_enemies);
			move_enemies(head_enemies);
			head_enemies=(enemy *)delete_enemy(head_enemies);
			num_of_enemies=count_enemies(head_enemies);
			head_bullets = check_projectiles(head_bullets, head_enemies);
			i++;
		}
}




int sizes[14][2]={{64,48},	// players
				 {60,64},
				 {1,1},	 	 	 // enemies
				 {99,66},
				 {226,138},
				 {60,100},
				 {123,66},
				 {102,77},
				 {98,65},
				 {84,78},
				 {116,137},
				 {105,63},
				 {89,75},
				 {23,32}};			//bullet

void init_players(player *first,player *second){
	if(first==NULL || second ==NULL)
	{
		printf("players not instantiated");
	}
	else{
		first->x_pos = 300,
		first->y_pos = y_bounds - sizes[player2_sprite][1];
		first->health = 3;
		first->id=player2_sprite;
		first->old_x =first->x_pos;
		second->x_pos= 200;
		second->y_pos= y_bounds - sizes[player2_sprite][1];
		second->health=3;
		second->id = player2_sprite;
	}
}

void move_projectile(player_projectile *head)
{
	if(head->y_pos<8)
		head->y_pos=0;
	else
		head->y_pos-=8;
}

void move_projectiles(player_projectile *head)
{
	while(head!=NULL)
	{
		move_projectile(head);
		head=head->next;
	}
}

void render_projectiles(player_projectile *head)
{
	player_projectile *pr=head;
		while(pr!=NULL){
			render_projectile(pr);
			pr=pr->next;
		}
}

void render_projectile(player_projectile *pr){
	if(pr==NULL){
		printf("bullet not found");
		}
	else{
		renderer(pr->old_x,pr->old_y,13,1);//Shadow First
		renderer(pr->x_pos,pr->y_pos,13,0);
		pr->old_x=pr->x_pos;
		pr->old_y=pr->y_pos;
		}
}


void make_enemy(enemy **em){
	enemy *generated=(enemy *)malloc(sizeof(enemy));
	generated->x_pos=rand()%500;
	generated->y_pos=rand()%30;
	generated->old_x=generated->x_pos;
	generated->old_y=generated->y_pos;
	generated->health = 2;
	generated->id=rand()%10+3;
	if(generated->id==4){
		generated->id=5;
	}
	generated->next = *em;
	*em = generated;
}

enemy * delete_enemy(enemy *curr)
{
  if (curr == NULL)
    return NULL;

  if (curr->y_pos + sizes[curr->id][1]>=475 || curr->health==0) {
    enemy *tempNext;
    tempNext = curr->next;
    renderer(curr->x_pos,curr->y_pos,curr->id,1);//Render shadow
    if(curr->health==0)
    {
    	renderer(curr->x_pos+sizes[curr->id][0]/2-32,curr->y_pos+sizes[curr->id][0]/2-32,14,0);
    	renderer(curr->x_pos+sizes[curr->id][0]/2-32,curr->y_pos+sizes[curr->id][0]/2-32,15,0);
    	renderer(curr->x_pos+sizes[curr->id][0]/2-32,curr->y_pos+sizes[curr->id][0]/2-32,16,0);
    	renderer(curr->x_pos+sizes[curr->id][0]/2-32,curr->y_pos+sizes[curr->id][0]/2-32,17,0);
    	renderer(curr->x_pos+sizes[curr->id][0]/2-32,curr->y_pos+sizes[curr->id][0]/2-32,18,0);
    	renderer(curr->x_pos+sizes[curr->id][0]/2-32,curr->y_pos+sizes[curr->id][0]/2-32,19,0);
    	renderer(curr->x_pos+sizes[curr->id][0]/2-32,curr->y_pos+sizes[curr->id][0]/2-32,19,1);
    }
    free(curr);
    return tempNext;
  }
  curr->next = delete_enemy(curr->next);
  return curr;
}

int count_enemies(enemy *em){
	int i=0;
	enemy *start=em;
	while(start!=NULL){
		start=start->next;
		i++;
	}
	return i;
}

void move_enemies(enemy *start){
	if(start==NULL){
		printf("You piece of shit\n");
	}
	else{
	enemy *em=start;
	while(em!=NULL){
		move_enemy(em,em->x_pos,em->y_pos+3);
		em=em->next;
		}
	}
}

void render_enemies(enemy *start){
	enemy *em=start;
	while(em!=NULL){
		render_enemy(em);
		em=em->next;
	}
}

void render_enemy(enemy *em){
	if(em==NULL){
		printf("enemy not initialized");
		}
	else{
		renderer(em->old_x,em->old_y,em->id,1);//Shadow First
		renderer(em->x_pos,em->y_pos,em->id,0);
		em->old_x=em->x_pos;
		em->old_y=em->y_pos;
		}
}


void renderer(int x, int y, int sprite_num, int is_shadow)
{
	if(is_shadow==1)
		*sw_to_hw = 4;
	else
		*sw_to_hw &= 0;
	*sprite_number = sprite_num;
	*sprite_xy = 1024*x + y;
	*sw_to_hw |= 2;
	while(*hw_to_sw%2 != 0)
	{}
	*sw_to_hw &= ~2;
	while(*hw_to_sw != 1)
	{}
	*sw_to_hw |= 1;
	return;
}

void render_shadows(player *first,player *second){
	if(first==NULL || second ==NULL){
			printf("players not instantiated");
	}
	else{
		renderer(first->old_x,first->old_y,first->id,1);
		renderer(second->old_x,second->old_y,second->id,1);
	}
	return;
}
void render_shadow(player *current){
	if(current==NULL){
			printf("players not instantiated");
	}
	else{
		renderer(current->old_x,current->old_y,current->id,1);
		current->old_x=current->x_pos;
		current->old_y=current->y_pos;
	}
	return;
}

void render_players(player *first,player *second){
	if(first==NULL || second ==NULL){
		printf("players not instantiated");
	}
	else{
		if(render_player_check(first)==0){
			render_shadow(first);
			renderer(first->x_pos,first->y_pos,first->id,0);

		}
		if(render_player_check(second)==0){
			render_shadow(second);
			renderer(second->x_pos,second->y_pos,second->id,0);

		}
	}
}
int render_player_check(player *current){
	int i=0;
	if(current->x_pos==current->old_x && current->y_pos==current->old_y){
		i=1;
	}
	return i;
}
//int render_enemy_check(enemy *current){
//	int i=0;
//	if(current->x_pos==current->old_x && current->y_pos==current->old_y){
//		i=1;
//	}
//	return i;
//}
int keycode_effect(player *first,player *second,unsigned int *arr, player_projectile **bullets, int can_fire_n){
	int i=0;
	int j=0;
	for(i=0;i<4;i++){
		if(arr[i]==0x04){
			j=1;
			move_player(first,first->x_pos-10,first->y_pos);
		}
		if(arr[i]==0x07){
			j=1;
			move_player(first,first->x_pos+10,first->y_pos);
		}
		if(arr[i]==0x1a){
			if(can_fire_n == 0)
			{
				j=1;
				*bullets = fire_projectile(first, *bullets);
			}
		}
		if(arr[i]==0x50){
			j=1;
			move_player(second,second->x_pos-10,second->y_pos);
		}
		if(arr[i]==0x4f){
			j=1;
			move_player(second,second->x_pos+10,second->y_pos);
		}
		if(arr[i]==0x52){
			if(can_fire_n == 0)
			{
				j=1;
				*bullets = fire_projectile(second, *bullets);
			}
		}
	}
	return j;
}
void parse_keycode(unsigned int *arr,unsigned int keycode1,unsigned int keycode2){
	arr[0]=keycode1%256;
	arr[1]=keycode1/256;
	arr[2]=keycode2%256;
	arr[3]=keycode2/256;
}


player_projectile* fire_projectile(player *current, player_projectile *head)
{
	player_projectile *new=(player_projectile*)malloc(sizeof(player_projectile));
	new->x_pos=current->x_pos + ((sizes[current->id][0])/2)-11;
	new->y_pos=current->y_pos - sizes[13][1];
	new->old_x = new->x_pos;
	new->old_y = new->y_pos;
	new->next = head;
	return new;
}

player_projectile * check_projectiles(player_projectile *curr, enemy *em)
{
	if (curr == NULL)
	    return NULL;

	  if (curr->y_pos==0 || hits_enemy(curr->x_pos,curr->y_pos,em)==1) {
	    player_projectile *tempNext;
	    tempNext = curr->next;
	    renderer(curr->x_pos,curr->y_pos,13,1);//Render shadow
	    free(curr);
	    return tempNext;
	  }
	  curr->next = check_projectiles(curr->next, em);
	  return curr;
}

int hits_enemy(int x, int y, enemy *em)
{
	while(em!=NULL)
	{
		if(x>(em->x_pos-23)&&x<(em->x_pos+sizes[em->id][0])&&y>(em->y_pos-32)&&y<(em->y_pos+sizes[em->id][1]))
		{
			em->health--;
			return 1;
		}
		else
		{
			em=em->next;
		}
	}
	return 0;
}

void move_player(player *current, int x_pos, int y_pos){
	if(current==NULL)
		{
			printf("players not instantiated");
		}
	else{
		int width = sizes[current->id][0];
		int height = sizes[current->id][1];
		current->x_pos = x_pos;
		current->y_pos = y_pos;
		if((x_pos + width)> x_bounds)
			current->x_pos = x_bounds - width;
		else if(x_pos < 0)
		{
			current->x_pos = 0;
		}
		if((y_pos + height) > y_bounds)
			current->y_pos = y_bounds - height;
		else if(y_pos < 0)
		{
			current->y_pos = 0;
		}
	}
}

void move_enemy(enemy *current, int x_pos, int y_pos){
	if(current==NULL)
		{
			printf("players not instantiated");
		}
	else{
		int width = sizes[current->id][0];
		int height = sizes[current->id][1];
		current->x_pos = x_pos;
		current->y_pos = y_pos;
		if((x_pos + width)> x_bounds)
			current->x_pos = x_bounds - width;
		else if(x_pos < 0)
		{
			current->x_pos = 0;
		}
		if((y_pos + height) > y_bounds)
			current->y_pos = y_bounds - height;
		else if(y_pos < 0)
		{
			current->y_pos = 0;
		}
	}
}




