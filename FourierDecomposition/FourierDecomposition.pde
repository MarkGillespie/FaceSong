import java.awt.Color;
import ddf.minim.analysis.*;
import ddf.minim.*;

// ~6210 frames

Minim minim;
AudioPlayer song;
FFT fft;

int t = 0;

PrintWriter output;

void setup() {

  size(1000, 1000);

  minim = new Minim(this);
  song = minim.loadFile("chopin.wav", power(2,11));
  song.play();
  fft = new FFT(song.bufferSize(), song.sampleRate());

 noStroke();
 
 colorMode(HSB, maxFreq*numBetween,1,1);
 output = createWriter("Chopin2.txt");
}


float factor = 13;
int maxFreq = 500;
int numBetween = 1;
float arcStretch = .5;
float circSize = 1;
int buffer = 100;


void draw() {
  background(0);
  fft.forward(song.mix);
  
  float[] amplitudes = new float[maxFreq];

  for(int i = 0; i < maxFreq; i++){
    fill(maxFreq*numBetween-(i*numBetween),1,1);
    rect(buffer + (float)(width/(1.2 * maxFreq))*(i*numBetween),height/2, circSize, (float)( -factor*fft.getBand(i+1)));      
    amplitudes[i] = fft.getBand(i);      
  }

  if (song.isPlaying() && (t % 10) == 0)
      println(t);

  if (song.isPlaying()) {
    output.print(amplitudes[0]);
    for (int i = 1; i < maxFreq; i++) {
      output.print("," + amplitudes[i]);
    }
    output.println();
  }

  t++;
}

void keyPressed() {
  if (key == 'Q' || key =='q') {
    maxFreq++;
    colorMode(HSB, maxFreq*numBetween, 1, 1);
  } 
  else if (key == 'w' || key == 'W') {
    maxFreq--;
    colorMode(HSB, maxFreq*numBetween, 1, 1);
  }
  
  if (key == 'A' || key =='a') {
   factor++;
  } 
  else if (key == 'S' || key == 's') {
    factor--;
  }
}

int power(int a, int b) {
  int ret = 1;
  while (b --> 0) {
    ret *= a;
  }
  return ret;
}
