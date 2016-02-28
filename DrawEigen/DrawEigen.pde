import java.awt.Color;
import ddf.minim.analysis.*;
import ddf.minim.*;

// ~6210 frames

Minim minim;
AudioPlayer song;
FFT fft;

int t = 0;

Table eigenfaces;
PImage[] face_images;
PImage average_face;

int fft_base_freq = 86; // size of the smallest octave to use (in Hz) so we calculate averages based on a miminum octave width of 86 Hz
int  fft_band_per_oct = 1; // how many bands to split each octave into? in this case split each octave into 1 band
int num_zones;

void setup() {
  size(800, 800);
  eigenfaces = loadTable("larger_eigenfaces.csv");
  average_face = loadImage("average_face.png");
  face_images = new PImage[90];

  average_face.loadPixels();

  for (int p = 0; p < face_images.length; p++) {
    face_images[p] = createImage(100, 100, RGB);
    face_images[p].loadPixels();
    for (int i = 0; i < 100; i++) {
      for (int j = 0; j < 100;j++) {
        face_images[p].pixels[i + 100 * j] = color(max(average_face.pixels[i + 100 * j], 0) + eigenfaces.getRow(p).getFloat(i + 100 * j) * 10550);
      }
    }
    face_images[p].updatePixels();
  }

  minim = new Minim(this);
  song = minim.loadFile("chopin.wav", 2048);
  song.play();
  fft = new FFT(song.bufferSize(), song.sampleRate());
  fft.logAverages(fft_base_freq, fft_band_per_oct);
  fft.window(FFT.HAMMING);

  num_zones = fft.avgSize();
}

int maxFreq = 500;

void draw() {
  background(100);
  fft.forward(song.mix);

  int wdth = 20;

  for (int i = 0; i < num_zones; i++) {
    float average = fft.getAvg(i);
    tint(255, average * 20000);
    println(average *   20000);
    image(face_images[i], 0, 0, 500, 500);   
    fill(255, 0, 0);
    rect((i + 1) * wdth, height - 100, wdth, -average);
  }

  tint(255, 100);
  // image(average_face, 0, 0, 500, 500);
  
  // for(int i = 0; i < maxFreq; i+=50){
  //   tint(255, fft.getBand(i) * 20000);
  //   // println(fft.getBand(i) * 20000);
  //   image(face_images[(int)(i / 10)], 0, 0, 500, 500);   
  // }
}

// float max(float a, float b) {
//   if (a < b)
//     return b;
//   return a;
// }