import processing.video.*;

Capture video;
PImage img;

PImage base;
boolean set = false;

int mode = 0;

void setup()
{
  fullScreen();
  background(255);

  img = new PImage();
  img = get(0, 0, width, height);

  video = new Capture(this, img.width, img.height);
  printArray(Capture.list());

  video.start();

  base = new PImage(video.width, video.height);

  noCursor();
  textAlign(CENTER);
}

void draw()
{    
  if (video.available())
  {
    video.read();
  }

  image(img, 0, 0);
  
  if(mode == 0 && !set)
  {
    fill(0);
    text("Click once to set the base image. Every subsequent click will record deviations from this base image.", width/2, height/2);
  }
}

void mousePressed()
{
  loadPixels();

  switch(mode)
  {
  case 0:
    if (!set)
    {
      base = video.get(0, 0, video.width, video.height);
      set = true;
    } else
    {
      for (int x = 0; x < video.width; x++)
      {
        for (int y = 0; y < video.height; y++)
        {  
          int loc = x + y*img.width;
          float cv = red(video.pixels[loc]) + green(video.pixels[loc]) + blue(video.pixels[loc]);
          float bv = red(base.pixels[loc]) + green(base.pixels[loc]) + blue(base.pixels[loc]);

          if (abs(cv - bv) > 100)
          {
            //if(img.pixels[loc] != color(255))
            {
              img.pixels[loc] = color(0);
            }
          }
        }
      }
    }
    break;

  case 1:
    for (int x = 0; x < video.width; x++)
    {
      for (int y = 0; y < video.height; y++)
      {  
        int loc = x + y*img.width;

        if (brightness(video.pixels[loc]) < 10)
        {
          img.pixels[loc] = color(0);
        }
      }
    }
    break;
  }

  img.updatePixels();

  println("Saved");
}

void keyPressed()
{ 
  if (key == ' ')
  {
    if (mode == 0)
    {
      for (int i = 0; i < img.width * img.height; i++)
      {
        img.pixels[i] = color(255);
      }

      base = video.get(0, 0, width, height);

      img.updatePixels();
      base.updatePixels();
    }
  }
}