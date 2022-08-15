ArrayList<Bullet> bullets = new ArrayList<Bullet>();;
IntList indexBlackList = new IntList();
int iter = 0;

class Bullet
{
  PVector position;
  PVector speed;
   
  int r = 5;
  
  int id;
  
  Bullet(float x,float y,boolean initiator)
  {
    position = new PVector(x,y);
    if(initiator == true)
    {
      speed = new PVector(0,2.5);
    }
    if(initiator == false)
    {
      speed = new PVector(0,-2.5);
    }
    id = iter;
    iter++;
  }
  void update()
  {
    if(position.y - r <= 0)
    {
      indexBlackList.append(id);
    }
    if(position.x - r > enemy.position.x && 
      !(position.x - r > enemy.position.x + 50) && 
      position.y - r > enemy.position.y && 
      !(position.y - r > enemy.position.y + 50))  
    {
      enemy.isDead = true;
      indexBlackList.append(id);
    }
    
    if(position.x - r > player.position.x && 
      !(position.x - r > player.position.x + 50) && 
      position.y - r > player.position.y && 
      !(position.y - r > player.position.y + 50))  
    {
      player.isDead = true;
    }
    position.sub(speed);
    circle(position.x,position.y,r * 2);
  }
  
}

class Enemy
{
  PVector position;
  PImage photo;
  
  int savedTime;
  
  PVector speed = new PVector(3,0);
  
  boolean isDead = false;
  Enemy(int x,int y)
  {
    position = new PVector(x,y);
    savedTime = millis();
    photo = loadImage("fly1.png");

  }
  void update()
  {
    int passedTime = millis() - savedTime;
    if(position.x + 50 > 500 || position.x < 0)
    {
      speed.x = -speed.x;
    }
    position.add(speed);
    image(photo,position.x,position.y);
    if(passedTime >= 1000)
    {
      bullets.add(new Bullet(
          position.x + 25, 
          position.y + 60,
          false));
      savedTime = millis();
    }
  }
}
Enemy enemy;

class Player
{
  PVector position;
  PImage photo;
  
  boolean isDead = false;
  
  int savedTime;
  
  PVector speed = new PVector(3,0);
  void update()
  {
    int passedTime = millis() - savedTime;
    if(position.add(speed).x > 450) position.x = 450;

    if(position.sub(speed).x < 0) position.x = 0;
    
    if (keyPressed) 
    {
      
      if(key == 'a')
      {
        position.sub(speed);
      }
      else if(key == 'd')
      {
        position.add(speed);
      }
      else if(key == ' ')
      {
        if(passedTime >= 1000)  
        {
          bullets.add(new Bullet(
              position.x + 25, 
              position.y - 20,
              true)
            );
          savedTime = millis();
        }
      }
    }
    if(position.add(speed).x > 450) position.x = 450;

    if(position.sub(speed).x < 0) position.x = 0;

    image(photo,position.x,position.y);
  }
  Player(int x,int y)
  {
    position = new PVector(x,y);
    savedTime = millis();
    photo = loadImage("fly.png");
  }
}

Player player;


void setup()
{
  size(500,500);
  player = new Player(250,350);
  enemy  = new Enemy(250,50);

}
void draw()
{
  background(color(0,200,255));
  if(!player.isDead)
  {
    player.update();
  }
  for(int i = 0;i < bullets.size();i++)
  {
    if(!indexBlackList.hasValue(i))  bullets.get(i).update();
  }
  if(!enemy.isDead)
  {
    enemy.update();
  }
}
