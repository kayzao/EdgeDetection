//EDGE DETECTION: A REALLY BASIC ALGORITHM USING PROCESSING 3
import processing.video.*;

int threshold;
int state;
PImage image;
int[] intensityPixels;
HashMap<String, String> images;
boolean thresholdChanged;
boolean showCamera;
Capture video;

void setup(){
  size(500, 500);
  state = 0;
  showCamera = false;
  //brcShowMessages(true);
  image = loadImage("house2.jpg");
  image.resize(width, height);
  image(image, 0, 0);
  video = new Capture(this, Capture.list()[0]);
  intensityPixels = new int[width * height];
  threshold = 30;
  thresholdChanged = false;
  images = new HashMap<String, String>();
  images.put("h", "house2.jpg");
  images.put("c", "car-square.jpg");
  images.put("b", "butterfly-2-square.jpg");
  background(200);
}
void draw(){
  brc();
  String change = brcChanged();
  
  if(change.equals("load")){ //changes image
    state = 0;
    reload();
  }
  if(change.equals("camera")){
    showCamera = boolean(brcValue("camera"));
    if(showCamera) video.start();
    if(!showCamera){
      video.stop();
      reload();
    }
  }
  threshold = int(brcValue("threshold")); //changes threshold  
  if(change.equals("vertical") || change.equals("horizontal") || change.equals("omni")){ //changes state if a button was clicked on
    if(change.equals("vertical")){
      state = state != 2 ? 2 : 0; //dont really understand "?" operator but whatever
    } else if(change.equals("horizontal")){
      state = state != 1 ? 1 : 0;
    } else {
      state = state != 3 ? 3 : 0;
    }
    if(state == 0) reload();
  }
  if(showCamera){
    background(0);
    image(video, 0, 0);
    if(video.available()) video.read();
    loadPixels();
  }
  if(state == 0) return; //don't draw edges until selected
  if(!showCamera) reload();
  loadPixels();
  for(int i = 0; i < width * height; i ++) intensityPixels[i] = int(red(pixels[i]) + green(pixels[i]) + blue(pixels[i])) / 3;
  if(state == 1) displayVerticalEdges(threshold);
  if(state == 2) displayHorizontalEdges(threshold);
  if(state == 3) displayOmniDirectional(threshold);
}
void reload(){
  image = loadImage(images.get(brcValue("file")));
  image.resize(width, height);
  image(image, 0, 0);
  loadPixels();
}
void displayVerticalEdges(int t){
  //goes through every pixel except the ones on the top or bottom row
  //if the difference between the above pixel and below pixel is greater than the threshold, 
  loadPixels();
  for(int i = 0; i < pixels.length; i++){
    if(i < width || i >= width * (height - 1)) continue; //if its on the top or bottom row return;
    //else, using intensity pixels, find the difference between the above and below pixels. if abs(difference) > t, it is a edge
    if(abs(intensityPixels[i - width] - intensityPixels[i + width]) > t){
      pixels[i] = color(255);
    } else {
      pixels[i] = color(0);
    }
  }
  updatePixels();
}
void displayHorizontalEdges(int t){
  loadPixels();
  for(int i = 0; i < pixels.length-1; i++){
    if(i % width == 0 || (i-1) % width == 0) continue; //if its left or right column return
    //else, using intensity pixels, find the difference between the left and right pixels. if abs(difference) > t, it is a edge
    if(abs(intensityPixels[i - 1] - intensityPixels[i + 1]) > t){
      pixels[i] = color(255);
    } else {
      pixels[i] = color(0);
    }
  }
  updatePixels();
}
void displayOmniDirectional(int t){
  loadPixels();
  for(int i = 0; i < pixels.length; i++) pixels[i] = color(0);
  for(int i = 0; i < pixels.length; i++){
    if(i < width || i >= width * (height - 1)) continue; //if its on the top or bottom row return;
    //else, using intensity pixels, find the difference between the above and below pixels. if abs(difference) > t, it is a edge
    if(abs(intensityPixels[i - width] - intensityPixels[i + width]) > t){
      pixels[i] = color(255);
    } 
  }
  for(int i = 0; i < pixels.length-1; i++){
    if(i % width == 0 || (i-1) % width == 0) continue; //if its left or right column return
    //else, using intensity pixels, find the difference between the left and right pixels. if abs(difference) > t, it is a edge
    if(abs(intensityPixels[i - 1] - intensityPixels[i + 1]) > t){
      pixels[i] = color(255);
    } 
  }
  updatePixels();
}
