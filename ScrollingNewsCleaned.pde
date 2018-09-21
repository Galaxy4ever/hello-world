String[] headlines;
BufferedReader read;
String line;
int time;
int pauseWait = 500;
int pauseTime;
PFont f;
PImage image1;
int index = 0;
int textHeight;
int stringPosStart = 0;
int stringPosEnd = 70;
int trans = 0;
boolean pause = false;
boolean fadeOut = false;
boolean fadeIn = false;
ArrayList<String> textDivide = new ArrayList<String>();
void setup() {
  size(1000,500);
  f = createFont("changeTimes New Roman",16,true);
  //image1 = loadImage("testimage.png");
  time = millis();
  pauseTime = millis();
  read = createReader("EnterNewsHere.txt");
  try{
    line = read.readLine();
  } catch (IOException e) {
    e.printStackTrace();
    line = null;
  }
  if(line == null){
    noLoop();
  }
  else{
    headlines = loadStrings("EnterNewsHere.txt");
  }
  textHeight = 250;
  if(headlines[index].length() <= 700){
    for(int i = 0; i <= headlines[index].length()/70; i++){
      if(70+70*i < headlines[index].length()){
        while(stringPosEnd > 0 && headlines[index].charAt(stringPosEnd) != ' '){
          stringPosEnd--;
        }
        textDivide.add(headlines[index].substring(stringPosStart, stringPosEnd));
        stringPosStart = stringPosEnd+1;
        stringPosEnd+=70;
      }
      else{
        if(stringPosStart >= 0)
          textDivide.add(headlines[index].substring(stringPosStart, headlines[index].length()));
      }
    }
  }
  else{
    textDivide.add("ERROR: ANNOUNCEMENT IS TOO LONG. PLEASE REVISE.");
  }
  stringPosStart = 0;
  stringPosEnd = 70;
  if(textDivide.size()%2 == 1)
      textHeight -= 40 * (textDivide.size()/2);
    else
      textHeight -= -20 + 40 * (textDivide.size()/2);
}

void draw() {
  background(255);
  noFill();
  strokeWeight(3);
  rect(width-42, 2, 40, 40);
  fill(0);
  strokeWeight(1);
  if(!pause){
    rect(width-28, 9, 3, 25);
    rect(width-18, 9, 3, 25);
  }
  else{
    triangle(width-35, 9, width-35, 36, width-10, 23);
  }
  if(mousePressed && mouseX > width-40 && mouseX < width && mouseY > 0 && mouseY < 40){
    if(millis() - pauseTime >= pauseWait){
      pauseTime = millis();
      pause = !pause;
    }
  }
  fill(trans);
  read = createReader("EnterNewsHere.txt");
  try{
    line = read.readLine();
  } catch (IOException e) {
    e.printStackTrace();
    line = null;
  }
  if(line == null){
    noLoop();
  }
  else{
    headlines = loadStrings("EnterNewsHere.txt");
  }
  if(fadeOut && trans < 255){
    trans+=5;
  }
  if(fadeIn && trans > 0){
    trans-=5;
  }
  textFont(f,28);
  
  for(int i = 0; i < textDivide.size(); i++){
    text(textDivide.get(i), width/2-textWidth(textDivide.get(i))/2,textHeight+(40*i));
  }
  if(!pause && millis() - time >= calcTime(0) - 850){
    fadeIn = false;
    fadeOut = true;
  }
  if(!pause && millis() - time >= calcTime(0)){
    fadeOut = false;
    fadeIn = true;
    textHeight = 250;
    //time = 0;
    time = millis();
    if(index < headlines.length-1)
      index++;
    else
      index = 0;
    textDivide.clear();
    if(headlines[index].length() <= 700){
      for(int i = 0; i <= headlines[index].length()/70; i++){
        if(70+70*i < headlines[index].length()){
          while(stringPosEnd > 0 && headlines[index].charAt(stringPosEnd) != ' '){
            stringPosEnd--;
          }
          textDivide.add(headlines[index].substring(stringPosStart, stringPosEnd));
          stringPosStart = stringPosEnd+1;
          stringPosEnd+=70;
        }
        else{
          if(stringPosStart >= 0)
            textDivide.add(headlines[index].substring(stringPosStart, headlines[index].length()));
        }
      }
    }
    else{
      textDivide.add("ERROR: ANNOUNCEMENT IS TOO LONG. PLEASE REVISE.");
    }
    stringPosStart = 0;
    stringPosEnd = 70;
    if(textDivide.size()%2 == 1){
      textHeight -= 40 * (textDivide.size()/2);
    }
    else{
      textHeight -= -20 + 40 * (textDivide.size()/2);
    }
  }
  else if(pause && millis() - time < calcTime(0)){
    time = millis();
  }
}
public int calcTime(int numSpaces){
  for(int i = 0; i < headlines[index].length(); i++){
    if(headlines[index].charAt(i) == ' ')
      numSpaces++;
  }
  return 350*numSpaces + 1000;
}
