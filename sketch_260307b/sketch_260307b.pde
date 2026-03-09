// ---- Main Sketch ----
// Particle class -> Particle.pde
// Constants    -> Constants.pde

ArrayList<Particle> particles;
ArrayList<Particle> pendingParticles;
int collisionCount     = 0;
int collisionCountRed  = 0;
int collisionCountBlue = 0;
ArrayList<Integer> history;         // total collisions
ArrayList<Integer> historyRed;      // red collisions
ArrayList<Integer> historyBlue;     // blue collisions
ArrayList<Integer> historyPopTotal; // total population
ArrayList<Integer> historyPopRed;   // red population
ArrayList<Integer> historyPopBlue;  // blue population
int simX;
int yMax;     // collision plot y-ceiling
int yMaxPop;  // population plot y-ceiling
float simElapsedSec = 0;
int lastFrameMillis = 0;
boolean simulationRunning = false;
boolean simulationPaused = false;
String statusMessage = "Edit the fields and press Run to start.";

UiNumberField groupACountField;
UiNumberField groupAMinAgeField;
UiNumberField groupAMaxAgeField;
UiNumberField groupAOffspringField;
UiNumberField groupBCountField;
UiNumberField groupBMinAgeField;
UiNumberField groupBMaxAgeField;
UiNumberField groupBOffspringField;
UiNumberField[] inputFields;
UiNumberField activeField;

UiButton runButton;
UiButton pauseButton;
UiButton stopButton;

void settings() {
  fullScreen();
}

void setup() {
  simX = (int)(width * GRAPH_RATIO);
  initializeUi();
  resetSimulation();
  syncInputFieldsWithSettings();
  lastFrameMillis = millis();
}

void draw() {
  int now = millis();
  int frameMillis = max(0, now - lastFrameMillis);
  lastFrameMillis = now;

  if(simulationRunning && !simulationPaused){
    simElapsedSec += (frameMillis / 1000.0) * TIME_SCALE;
    updateSimulation();
  }

  background(BACKGROUND_COLOR);
  drawGraph();
  drawSimulationArea();
  drawControlPanel();
}

void initializeUi(){
  groupACountField = new UiNumberField("Population", str(groupACount), false);
  groupAMinAgeField = new UiNumberField("Min age", str(groupAMinAge), true);
  groupAMaxAgeField = new UiNumberField("Max age", str(groupAMaxAge), true);
  groupAOffspringField = new UiNumberField("Offspring", str(groupAOffspring), false);

  groupBCountField = new UiNumberField("Population", str(groupBCount), false);
  groupBMinAgeField = new UiNumberField("Min age", str(groupBMinAge), true);
  groupBMaxAgeField = new UiNumberField("Max age", str(groupBMaxAge), true);
  groupBOffspringField = new UiNumberField("Offspring", str(groupBOffspring), false);

  inputFields = new UiNumberField[]{
    groupACountField, groupAMinAgeField, groupAMaxAgeField, groupAOffspringField,
    groupBCountField, groupBMinAgeField, groupBMaxAgeField, groupBOffspringField
  };

  runButton = new UiButton("Run", color(52, 145, 88), color(68, 176, 105));
  pauseButton = new UiButton("Pause", color(172, 126, 34), color(207, 154, 45));
  stopButton = new UiButton("Stop", color(160, 64, 64), color(194, 78, 78));
}

void syncInputFieldsWithSettings(){
  groupACountField.text = str(groupACount);
  groupAMinAgeField.text = str(groupAMinAge);
  groupAMaxAgeField.text = str(groupAMaxAge);
  groupAOffspringField.text = str(groupAOffspring);

  groupBCountField.text = str(groupBCount);
  groupBMinAgeField.text = str(groupBMinAge);
  groupBMaxAgeField.text = str(groupBMaxAge);
  groupBOffspringField.text = str(groupBOffspring);
}

void layoutControls(){
  float left = CONTROL_PANEL_PADDING;
  float top = 66;
  float columnWidth = (simX - CONTROL_PANEL_PADDING * 2.0 - CONTROL_COLUMN_GAP) / 2.0;
  float rowStep = CONTROL_FIELD_HEIGHT + 18;
  float groupBLeft = left + columnWidth + CONTROL_COLUMN_GAP;
  float fieldsBottom = top + rowStep * 3 + CONTROL_FIELD_HEIGHT;

  groupACountField.setBounds(left, top, columnWidth, CONTROL_FIELD_HEIGHT);
  groupAMinAgeField.setBounds(left, top + rowStep, columnWidth, CONTROL_FIELD_HEIGHT);
  groupAMaxAgeField.setBounds(left, top + rowStep * 2, columnWidth, CONTROL_FIELD_HEIGHT);
  groupAOffspringField.setBounds(left, top + rowStep * 3, columnWidth, CONTROL_FIELD_HEIGHT);

  groupBCountField.setBounds(groupBLeft, top, columnWidth, CONTROL_FIELD_HEIGHT);
  groupBMinAgeField.setBounds(groupBLeft, top + rowStep, columnWidth, CONTROL_FIELD_HEIGHT);
  groupBMaxAgeField.setBounds(groupBLeft, top + rowStep * 2, columnWidth, CONTROL_FIELD_HEIGHT);
  groupBOffspringField.setBounds(groupBLeft, top + rowStep * 3, columnWidth, CONTROL_FIELD_HEIGHT);

  float buttonY = fieldsBottom + 28;
  float buttonWidth = (simX - CONTROL_PANEL_PADDING * 2.0 - CONTROL_FIELD_GAP * 2.0) / 3.0;
  runButton.setBounds(CONTROL_PANEL_PADDING, buttonY, buttonWidth, CONTROL_BUTTON_HEIGHT);
  pauseButton.setBounds(CONTROL_PANEL_PADDING + buttonWidth + CONTROL_FIELD_GAP, buttonY, buttonWidth, CONTROL_BUTTON_HEIGHT);
  stopButton.setBounds(CONTROL_PANEL_PADDING + (buttonWidth + CONTROL_FIELD_GAP) * 2, buttonY, buttonWidth, CONTROL_BUTTON_HEIGHT);
}

void resetSimulation(){
  particles = new ArrayList<Particle>();
  pendingParticles = new ArrayList<Particle>();
  history = new ArrayList<Integer>();
  historyRed = new ArrayList<Integer>();
  historyBlue = new ArrayList<Integer>();
  historyPopTotal = new ArrayList<Integer>();
  historyPopRed = new ArrayList<Integer>();
  historyPopBlue = new ArrayList<Integer>();
  collisionCount = 0;
  collisionCountRed = 0;
  collisionCountBlue = 0;
  yMax = GRAPH_Y_MAX_INITIAL;
  yMaxPop = GRAPH_POP_Y_MAX_INITIAL;
  simElapsedSec = 0;
  lastFrameMillis = millis();
}

void spawnParticles(){
  for(int i = 0; i < groupACount; i++){
    particles.add(new Particle(
      random(simX + 20, width - 20),
      random(20, height - 20),
      color(GROUP_A_R, GROUP_A_G, GROUP_A_B),
      0
    ));
  }

  for(int i = 0; i < groupBCount; i++){
    particles.add(new Particle(
      random(simX + 20, width - 20),
      random(20, height - 20),
      color(GROUP_B_R, GROUP_B_G, GROUP_B_B),
      1
    ));
  }
}

void updateSimulation(){
  if(particles.size() >= MAX_POPULATION){
    haltSimulation("Population cap reached: " + particles.size() + " particles.");
    return;
  }

  for(Particle p : particles){
    p.move();
    p.wallBounce();
  }

  for(int i = 0; i < particles.size(); i++){
    for(int j = i + 1; j < particles.size(); j++){
      particles.get(i).collide(particles.get(j));
    }
  }

  particles.addAll(pendingParticles);
  pendingParticles.clear();

  for(int i = particles.size() - 1; i >= 0; i--){
    if(particles.get(i).isDead()){
      particles.remove(i);
    }
  }

  if(STOP_ON_EXTINCTION && particles.size() == 0){
    haltSimulation("Extinction: all particles have died.");
  }

  recordHistory();

  if(particles.size() >= MAX_POPULATION){
    haltSimulation("Population cap reached: " + particles.size() + " particles.");
  }
}

void recordHistory(){
  history.add(collisionCount);
  historyRed.add(collisionCountRed);
  historyBlue.add(collisionCountBlue);

  int popRed = 0;
  int popBlue = 0;
  for(Particle p : particles){
    if(p.groupId == 0) popRed++;
    else               popBlue++;
  }

  historyPopTotal.add(particles.size());
  historyPopRed.add(popRed);
  historyPopBlue.add(popBlue);

  int activeMax = 0;
  if(SHOW_TOTAL_COLLISIONS) activeMax = max(activeMax, collisionCount);
  if(SHOW_RED_COLLISIONS)   activeMax = max(activeMax, collisionCountRed);
  if(SHOW_BLUE_COLLISIONS)  activeMax = max(activeMax, collisionCountBlue);
  if(activeMax >= yMax * GRAPH_Y_SCALE_AT){
    yMax = max(yMax + 1, (int)(yMax * GRAPH_Y_SCALE_FACTOR));
  }

  int popMax = 0;
  if(SHOW_TOTAL_POPULATION) popMax = max(popMax, particles.size());
  if(SHOW_RED_POPULATION)   popMax = max(popMax, popRed);
  if(SHOW_BLUE_POPULATION)  popMax = max(popMax, popBlue);
  if(popMax >= yMaxPop * GRAPH_Y_SCALE_AT){
    yMaxPop = max(yMaxPop + 1, (int)(yMaxPop * GRAPH_Y_SCALE_FACTOR));
  }
}

void haltSimulation(String message){
  simulationRunning = false;
  simulationPaused = false;
  statusMessage = message;
}

void handleRunButton(){
  if(simulationRunning){
    if(simulationPaused){
      simulationPaused = false;
      lastFrameMillis = millis();
      statusMessage = "Simulation resumed.";
    } else {
      statusMessage = "Simulation is already running. Press Stop to restart with new values.";
    }
    return;
  }

  if(!applyInputsToSettings()){
    return;
  }

  resetSimulation();
  spawnParticles();
  simulationRunning = true;
  simulationPaused = false;
  activeField = null;
  lastFrameMillis = millis();
  statusMessage = "Simulation running.";
}

void handlePauseButton(){
  if(!simulationRunning){
    statusMessage = "Simulation is not running.";
    return;
  }

  if(simulationPaused){
    statusMessage = "Simulation is already paused.";
    return;
  }

  simulationPaused = true;
  statusMessage = "Simulation paused.";
}

void handleStopButton(){
  simulationRunning = false;
  simulationPaused = false;
  resetSimulation();
  statusMessage = "Simulation stopped.";
}

boolean applyInputsToSettings(){
  try {
    int nextGroupACount = parseWholeNumber(groupACountField.text, "Group A population");
    float nextGroupAMinAge = parseDecimal(groupAMinAgeField.text, "Group A min age", false);
    float nextGroupAMaxAge = parseDecimal(groupAMaxAgeField.text, "Group A max age", true);
    int nextGroupAOffspring = parseWholeNumber(groupAOffspringField.text, "Group A offspring");

    int nextGroupBCount = parseWholeNumber(groupBCountField.text, "Group B population");
    float nextGroupBMinAge = parseDecimal(groupBMinAgeField.text, "Group B min age", false);
    float nextGroupBMaxAge = parseDecimal(groupBMaxAgeField.text, "Group B max age", true);
    int nextGroupBOffspring = parseWholeNumber(groupBOffspringField.text, "Group B offspring");

    if(nextGroupAMaxAge < nextGroupAMinAge){
      statusMessage = "Group A max age must be greater than or equal to min age.";
      return false;
    }

    if(nextGroupBMaxAge < nextGroupBMinAge){
      statusMessage = "Group B max age must be greater than or equal to min age.";
      return false;
    }

    groupACount = nextGroupACount;
    groupAMinAge = nextGroupAMinAge;
    groupAMaxAge = nextGroupAMaxAge;
    groupAOffspring = nextGroupAOffspring;

    groupBCount = nextGroupBCount;
    groupBMinAge = nextGroupBMinAge;
    groupBMaxAge = nextGroupBMaxAge;
    groupBOffspring = nextGroupBOffspring;
    syncInputFieldsWithSettings();
    return true;
  }
  catch(RuntimeException ex){
    statusMessage = ex.getMessage();
    return false;
  }
}

int parseWholeNumber(String rawValue, String label){
  String trimmed = rawValue.trim();
  if(trimmed.length() == 0){
    throw new RuntimeException(label + " is required.");
  }

  int parsedValue;
  try {
    parsedValue = Integer.parseInt(trimmed);
  }
  catch(Exception ex){
    throw new RuntimeException(label + " must be a whole number.");
  }

  if(parsedValue < 0){
    throw new RuntimeException(label + " must be 0 or greater.");
  }

  return parsedValue;
}

float parseDecimal(String rawValue, String label, boolean mustBePositive){
  String trimmed = rawValue.trim();
  if(trimmed.length() == 0){
    throw new RuntimeException(label + " is required.");
  }

  float parsedValue;
  try {
    parsedValue = Float.parseFloat(trimmed);
  }
  catch(Exception ex){
    throw new RuntimeException(label + " must be a number.");
  }

  if(parsedValue < 0 || (mustBePositive && parsedValue == 0)){
    throw new RuntimeException(label + (mustBePositive ? " must be greater than 0." : " must be 0 or greater."));
  }

  return parsedValue;
}

void drawSimulationArea(){
  stroke(70);
  noFill();
  rect(simX, 0, width - simX, height);

  for(Particle p : particles){
    p.show();
  }

  if(!simulationRunning || simulationPaused){
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(24);
    text(statusMessage, simX + (width - simX) / 2.0, height / 2.0);
  }
}

void drawControlPanel(){
  layoutControls();

  noStroke();
  fill(24, 28, 36);
  rect(0, 0, simX, CONTROL_PANEL_HEIGHT);

  fill(255);
  textAlign(LEFT, TOP);
  textSize(22);
  text("Simulation Controls", CONTROL_PANEL_PADDING, 16);

  textSize(CONTROL_GROUP_TITLE_SIZE);
  fill(GROUP_A_R, GROUP_A_G, GROUP_A_B);
  text("Group A", CONTROL_PANEL_PADDING, 40);
  fill(GROUP_B_R, GROUP_B_G, GROUP_B_B);
  text("Group B", CONTROL_PANEL_PADDING + (simX - CONTROL_PANEL_PADDING * 2.0 - CONTROL_COLUMN_GAP) / 2.0 + CONTROL_COLUMN_GAP, 40);

  for(UiNumberField field : inputFields){
    field.draw(field == activeField);
  }

  runButton.draw();
  pauseButton.draw();
  stopButton.draw();

  fill(205);
  textAlign(LEFT, TOP);
  textSize(CONTROL_STATUS_SIZE);
  text(statusMessage, CONTROL_PANEL_PADDING, CONTROL_PANEL_HEIGHT - CONTROL_PANEL_PADDING - 14);
}

void mousePressed(){
  layoutControls();

  if(runButton.contains(mouseX, mouseY)){
    handleRunButton();
    return;
  }

  if(pauseButton.contains(mouseX, mouseY)){
    handlePauseButton();
    return;
  }

  if(stopButton.contains(mouseX, mouseY)){
    handleStopButton();
    return;
  }

  for(UiNumberField field : inputFields){
    if(field.contains(mouseX, mouseY)){
      activeField = field;
      return;
    }
  }

  activeField = null;
}

void keyPressed(){
  if(activeField != null){
    activeField.handleKey(key, keyCode);
  }
}

// ---- Graph ----

// Draws a y-axis with smooth appearing/thinning ticks inside a subplot band.
// pxBottom/pxTop = pixel y boundaries; curVal = current max data value; yAxisMax = scale ceiling
void drawYAxis(int m, int pxBottom, int pxTop, int curVal, int yAxisMax, int tickBase){
  int yStep = tickBase;
  float plotH = pxBottom - pxTop;
  while(yAxisMax > 0 && (yStep / (float)yAxisMax) * plotH < (GRAPH_MIN_Y_TICK_PX / 4.0)){
    yStep *= 2;
  }
  float lastDrawnTy = pxBottom;
  for(int v = yStep; v <= curVal; v += yStep){
    float ty = map(v, 0, yAxisMax, pxBottom, pxTop);
    if(lastDrawnTy - ty >= GRAPH_MIN_Y_TICK_PX){
      stroke(180);
      line(m - 5, ty, m, ty);
      fill(200); noStroke(); textAlign(RIGHT, CENTER);
      String lbl;
      if(v >= 1000000)    lbl = nf(v/1000000.0, 1, 1) + "M";
      else if(v >= 1000)  lbl = nf(v/1000.0, 1, 1) + "k";
      else                lbl = str(v);
      text(lbl, m - 7, ty);
      lastDrawnTy = ty;
    }
  }
  fill(200); noStroke(); textAlign(RIGHT, CENTER);
  text("0", m - 7, pxBottom);
}

// Draws x-axis ticks and labels along a given pixel y (the axis line).
void drawXAxis(int m, int pxAxisY, float elapsedSec){
  float plotW = (simX - m/2.0) - m;
  float tickInterval = TICK_INTERVALS[0];
  for(int ti = 0; ti < TICK_THRESHOLDS.length; ti++){
    if(elapsedSec >= TICK_THRESHOLDS[ti]) tickInterval = TICK_INTERVALS[ti + 1];
  }
  while(elapsedSec > 0 && (tickInterval / elapsedSec) * plotW < GRAPH_MIN_TICK_PX){
    tickInterval *= 2;
  }
  textSize(GRAPH_TICK_SIZE);
  for(float t = tickInterval; t <= elapsedSec; t += tickInterval){
    float tx = map(t, 0, elapsedSec, m, simX - m/2);
    stroke(180);
    line(tx, pxAxisY, tx, pxAxisY + 5);
    fill(200); noStroke(); textAlign(CENTER, TOP);
    int totalSec = (int)t;
    String lbl;
    if(totalSec < 60)            lbl = totalSec + "s";
    else if(totalSec < 3600)   { int mn=totalSec/60; int sc=totalSec%60;   lbl = sc==0 ? mn+"m" : mn+"m"+sc+"s"; }
    else if(totalSec < 86400)  { int hr=totalSec/3600; int mn=(totalSec%3600)/60; lbl = mn==0 ? hr+"h" : hr+"h"+mn+"m"; }
    else                       { int dy=totalSec/86400; int hr=(totalSec%86400)/3600; lbl = hr==0 ? dy+"d" : dy+"d"+hr+"h"; }
    text(lbl, tx, pxAxisY + 7);
  }
  fill(200); noStroke(); textAlign(CENTER, TOP);
  text("0", m, pxAxisY + 7);
}

// Draws data lines for a subplot given history arrays, pixel bounds, and y ceiling.
void drawLines(ArrayList<Integer> hist1, color c1, boolean show1,
               ArrayList<Integer> hist2, color c2, boolean show2,
               ArrayList<Integer> hist3, color c3, boolean show3,
               int m, int pxBottom, int pxTop, int yAxisMax){
  int n = hist1.size();
  if(n < 2) return;
  if(show1){ noFill(); stroke(c1);
    beginShape();
    for(int i=0;i<n;i++) vertex(map(i,0,n,m,simX-m/2), map(hist1.get(i),0,yAxisMax,pxBottom,pxTop));
    endShape(); }
  if(show2 && hist2.size()>=2){ noFill(); stroke(c2);
    beginShape();
    for(int i=0;i<hist2.size();i++) vertex(map(i,0,n,m,simX-m/2), map(hist2.get(i),0,yAxisMax,pxBottom,pxTop));
    endShape(); }
  if(show3 && hist3.size()>=2){ noFill(); stroke(c3);
    beginShape();
    for(int i=0;i<hist3.size();i++) vertex(map(i,0,n,m,simX-m/2), map(hist3.get(i),0,yAxisMax,pxBottom,pxTop));
    endShape(); }
}

void drawGraph(){
  int panelTop = CONTROL_PANEL_HEIGHT;
  int graphHeight = height - panelTop;
  if(graphHeight <= GRAPH_MARGIN * 2){
    return;
  }

  int m    = GRAPH_MARGIN;
  int midY = panelTop + graphHeight / 2;

  stroke(255); noFill();
  rect(0, 0, simX, height);
  stroke(80);
  line(0, panelTop, simX, panelTop);
  line(0, midY, simX, midY);

  float elapsedSec = simElapsedSec;

  int topPxBottom = midY - m/2;
  int topPxTop    = panelTop + m/2;
  stroke(180);
  line(m, topPxBottom, simX - m/2, topPxBottom);
  line(m, topPxTop,    m, topPxBottom);
  textSize(GRAPH_TICK_SIZE);
  int refCount = 0;
  if(SHOW_TOTAL_COLLISIONS) refCount = max(refCount, collisionCount);
  if(SHOW_RED_COLLISIONS)   refCount = max(refCount, collisionCountRed);
  if(SHOW_BLUE_COLLISIONS)  refCount = max(refCount, collisionCountBlue);
  drawYAxis(m, topPxBottom, topPxTop, refCount, yMax, GRAPH_Y_TICK_BASE);
  drawXAxis(m, topPxBottom, elapsedSec);
  textSize(GRAPH_LABEL_SIZE); fill(255); noStroke();
  textAlign(CENTER, BOTTOM);
  text("Time", simX/2, midY - 2);
  pushMatrix();
    translate(12, midY/2); rotate(-HALF_PI);
    textAlign(CENTER, CENTER);
    text("Collisions", 0, 0);
  popMatrix();
  drawLines(history,      color(255,255,255), SHOW_TOTAL_COLLISIONS,
            historyRed,   color(GROUP_A_R, GROUP_A_G, GROUP_A_B), SHOW_RED_COLLISIONS,
            historyBlue,  color(GROUP_B_R, GROUP_B_G, GROUP_B_B), SHOW_BLUE_COLLISIONS,
            m, topPxBottom, topPxTop, yMax);

  int botPxBottom = height - m/2;
  int botPxTop    = midY + m/2;
  stroke(180);
  line(m, botPxBottom, simX - m/2, botPxBottom);
  line(m, botPxTop,    m, botPxBottom);
  textSize(GRAPH_TICK_SIZE);
  int refPop = 0;
  if(SHOW_TOTAL_POPULATION) refPop = max(refPop, historyPopTotal.size() > 0 ? historyPopTotal.get(historyPopTotal.size()-1) : 0);
  if(SHOW_RED_POPULATION)   refPop = max(refPop, historyPopRed.size()   > 0 ? historyPopRed.get(historyPopRed.size()-1)     : 0);
  if(SHOW_BLUE_POPULATION)  refPop = max(refPop, historyPopBlue.size()  > 0 ? historyPopBlue.get(historyPopBlue.size()-1)   : 0);
  drawYAxis(m, botPxBottom, botPxTop, refPop, yMaxPop, GRAPH_Y_TICK_BASE);
  drawXAxis(m, botPxBottom, elapsedSec);
  textSize(GRAPH_LABEL_SIZE); fill(255); noStroke();
  textAlign(CENTER, BOTTOM);
  text("Time", simX/2, height - 2);
  pushMatrix();
    translate(12, midY + (height - midY)/2); rotate(-HALF_PI);
    textAlign(CENTER, CENTER);
    text("Population", 0, 0);
  popMatrix();
  drawLines(historyPopTotal, color(255,255,255), SHOW_TOTAL_POPULATION,
            historyPopRed,   color(GROUP_A_R, GROUP_A_G, GROUP_A_B), SHOW_RED_POPULATION,
            historyPopBlue,  color(GROUP_B_R, GROUP_B_G, GROUP_B_B), SHOW_BLUE_POPULATION,
            m, botPxBottom, botPxTop, yMaxPop);
}

