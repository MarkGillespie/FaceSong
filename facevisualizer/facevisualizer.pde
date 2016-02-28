import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer song;
AudioInput input;
FFT fft;

Table table;
double[][] eigenfaces;
PImage result;

void setup()
{
  size(512, 512);
  
  minim = new Minim(this);
  song = minim.loadFile("../FourierDecomposition/chopin.wav");
  song.play();
  
  fft = new FFT(song.bufferSize(), song.sampleRate());
  
  // load the eigenfaces into the array
  table = loadTable("larger_eigenfaces.csv");
  
  for (TableRow i : table.rows())
  {
  }
  
  String[] eigenfaces2 = loadStrings("larger_eigenfaces.csv");
  println(eigenfaces2.length);
  int i1 = 0;
  for (String s : eigenfaces2)
  {
    String[] doubles = s.split(",");
    // construct the matrix on the first pass through now that we know the dimensions
    if (i1 == 0)
    {
      eigenfaces = new double[eigenfaces2.length][doubles.length];
      println(doubles.length);
    }
    int i2 = 0;
    for(String s2 : doubles)
    {
      eigenfaces[i1][i2] = 12000 * Math.abs(Double.parseDouble(s2));
      i2++;
    }
    i1++;
  }
}

void draw()
{
  println(frameRate);
  background(0);
  fft.forward(song.mix);
  stroke(255, 0, 0, 128);
  
  
  /*double[] linearcombination = new double[eigenfaces[0].length];//eigenfaces[9];//
  
  double[] randlist = new double[20];
  for (int i = 0; i < randlist.length; i++)
  {
    randlist[i] = Math.random();
  }
  
  for (int j = 0; j < eigenfaces[0].length; j++)
  {
    for (int i = 0; i < 20; i++)
    {
      linearcombination[j] += randlist[i] * eigenfaces[i][j] / 20;
    }
  }
  
  result = createImage(100, 100, RGB);
  result.loadPixels();
  for (int i = 0; i < result.pixels.length; i++)
  {
    result.pixels[i] = (int)(linearcombination[i]*1000);
  }
  
  result.resize(500,0);
  image(result, 0, 0);*/
  
  int binnums = 20;
  
  int counterto20 = 0;
  double[] components = new double[20];
  for(int i = 0; i < fft.specSize()/20; i++)
  {
    // average across every binnums number of bins
    int numave = (((fft.specSize() - i*20) >= 20)?20:(fft.specSize() - i * 20));
    float avespec = 0;
    for (int j = 0; j < numave; j++)
    {
      avespec += fft.getBand(i*20 + j);
    }
    avespec /= numave;
    if (counterto20 < 20) components[counterto20++] = avespec;
    // display for 20 lines
    for(int j = 0; j < numave; j++)
    {
      line(i*20+j, height, i*20+j, height - avespec*40*(i+1));
    }
  }
  //for (double d : components) print(d);
  //println();
  
  double[] linearcombination = new double[eigenfaces[0].length];//eigenfaces[9];//


  for (int j = 0; j < eigenfaces[0].length; j++)
    {
      for (int q = 0; q < 20; q++)
      {
        linearcombination[j] += components[q] * (q + 1) * eigenfaces[3*q][j] / 20;
      }
    }

    result = createImage(100, 100, RGB);
    result.loadPixels();
    for (int q = 0; q < result.pixels.length; q++)
    {
      result.pixels[q] = color((int)(linearcombination[q]));
    }
    
      result.resize(500,0);
      image(result, 0, 0);
  
  
    
    
  stroke(255, 0, 0, 128);
    
  //for(int i = 0; i < song.bufferSize() - 1; i++)
  //{
  //  line(i, 50 + song.left.get(i)*50, i + 1, 50 + song.left.get(i + 1)*50);
  //  line(i, 250 + song.right.get(i)*50, i + 1, 250 + song.right.get(i + 1)*50);
  //}*/
}