// A Crude Attempt at a clone of MuseScore

import processing.sound.*; // import sine wave library
SinOsc sine;

int note_length = 450; // How long to hold notes, in milliseconds
int note_spacing = 10; // How long between notes, in milliseconds

PImage treble;
PImage time_sig;

PFont Edwin; 
String title = "MusePoor";

// Set up note names and their corresponding frequencies
String[] note_names = { "c3", "c#3", "d3", "d#3", "e3", "f3", "f#3", "g3", "g#3", "a3", "a#3", "b3", "c4",  "c#4", "d4", "d#4", "e4", "f4", "f#4", "g4", "g#4", "a4", "a#4", "b4", "c5", "c#5", "d5", "d#5", "e5", "f5", "f#5", "g5", "g#5", "a5" };
float[] notes_freqs = { 130.8, 138.6, 146.8, 155.6, 164.8, 174.6, 185, 196, 207.6, 220, 233, 246.9, 261.6, 277.2, 293.7, 311.1, 329.6, 349.2, 369.99, 392, 415.3, 440, 466.2, 493.9, 523.3, 554.4, 587.3, 622.3, 659.3, 698.5, 740, 784, 830.6, 880 };

// Data storage init
FloatDict notes;
int noteY = 0;
float[] usr_notes = {0};
float[] usr_note_pos = {1000};
String current_freq;

void setup() 
{
  size(800, 400); // Set up canvas
  Edwin = createFont("Edwin-Roman.otf", 40);  // Init font
  treble = loadImage("treble_clef.png"); // Load treble clef png
  time_sig = loadImage("4_4_time.png");

  notes = new FloatDict();
  
  for(int i = 0; i < notes_freqs.length; i++)    // Take all the note names and frequencies and store them
  {
    notes.set(note_names[i], notes_freqs[i]);     // in a dictionary as opposed to a set of arrays
  }
}

void draw() 
{
  background(255);
  noStroke();
  
  // Play button
  fill(240);
  stroke(0);
  circle(width/2, 140, 40);
  stroke(0, 0, 255);
  fill(212, 232, 255);
  triangle(394, 127, 394, 152, 413, 140); 
  
  if(mouseX > (width/2 - 20) && mouseX < (width/2 + 20) && mouseY > 120 && mouseY < 160)    // Set up button functionality
  {
    if(mousePressed) 
    {
      playsong(usr_notes);  // Play the user's song
    }
  }
  
  // Clear button
  stroke(0);
  fill(250);
  rect(100, 122, 60, 35, 10);
  noStroke();
  fill(0);
  textSize(15);
  text("Clear", 130, 144);
  
  if(mouseX > 100 && mouseX < 160 && mouseY > 122 && mouseY < 157) 
  {
    if(mousePressed) 
    {
      usr_notes = new float[1];
      usr_notes[0] = 0.0;
      usr_note_pos = new float[1];
      usr_note_pos[0] = 1000;
    }
  }
  
  // Title
  fill(0);
  textSize(40);
  textFont(Edwin);
  textAlign(CENTER);
  text(title, width/2, 60);
  
  image(treble, -40, 185, 137, 86);
  image(time_sig, 50, 200, 22, 50);
  
  // Staff
  bars(5, 200, 790, 50, 5);
  
  // Get the right note as determined by the user
  if(mouseY >0 && mouseY < 190) 
  {
    noteY = 1000;
  }
  else if(mouseY > 180 && mouseY < 197) 
  {
    noteY = 195;
    current_freq = "g5";
  }
  else if(mouseY > 198 && mouseY < 202) 
  {
    noteY = 200;
    current_freq = "f5";
  }
  else if(mouseY > 204 && mouseY < 208) 
  {
    noteY = 206;
    current_freq = "e5";
  }
  else if(mouseY > 210 && mouseY < 214) 
  {
    noteY = 212;
    current_freq = "d5";
  }
  else if(mouseY > 217 && mouseY < 221) 
  {
    noteY = 219;
    current_freq = "c5";
  }
  else if(mouseY > 223 && mouseY < 227) 
  {
    noteY = 225;
    current_freq = "a#4";
  }
  else if(mouseY > 229 && mouseY < 233) 
  {
    noteY = 231;
    current_freq = "a4";
  }
  else if(mouseY > 235 && mouseY < 239) 
  {
    noteY = 237;
    current_freq = "g4";
  }
  else if(mouseY > 242 && mouseY < 246) 
  {
    noteY = 244;
    current_freq = "f4";
  }
  else if(mouseY > 248 && mouseY < 252) 
  {
    noteY = 250;
    current_freq = "e4";
  }
  else if(mouseY > 254 && mouseY < 260) 
  {
    noteY = 256;
    current_freq = "d4";
  }
  else if(mouseY > 270) 
  {
    noteY = 1000;
  }
  println(current_freq);
 
  quarter_note(mouseX, noteY);
  
  if(mousePressed && mouseY > 190 && mouseY < 260)   // Called when the user wants to add a note to the staff
  {
    float note = (float)notes.get(current_freq);
    usr_notes = add_notes(usr_notes, note);
    usr_note_pos = add_notes(usr_note_pos, noteY);
    delay(200);
  }
  for(int i = 0; i < usr_notes.length; i++) 
  {
    println(usr_notes[i]);
    quarter_note(63 + 30*i, (int)usr_note_pos[i]);
    if(i%4 == 0) 
    {
      line(80 + 30 * i, 200, 80 + 30 * i, 250);
    }
  }
}

// Method to add notes to arrays
float[] add_notes(float[] usr_notes, float elem) 
{
  float[] new_array = new float[usr_notes.length + 1];
  for(int i = 0; i < usr_notes.length; i++) 
  {
    new_array[i] = usr_notes[i];
  }
  new_array[usr_notes.length] = elem;
  return new_array;
}

// Method to draw a quarter note
void quarter_note(int x, int y) 
{
  push();
  translate(x, y);
  ellipse(0, 0, 12.5, 10);
  line(6.25, 0, 6.25, -25);
  pop();
}

// Method to draw staff
void bars(float x, float y, float w, float h, float n) 
{
  stroke(0, 150);
  float dh = h/(n-1);
  for(int i = 0; i < n; i++)
  {
    line(x, y + dh * i, x + w, y + dh * i);
  }
}

// Method to play the user's song
void playsong(float[] array) 
{
  sine = new SinOsc(this);
  for(int i = 0; i < array.length; i++) 
  {
    sine.play();
    sine.freq(array[i]);
    delay(note_length);
    sine.stop();
    delay(note_spacing);
  }
}
