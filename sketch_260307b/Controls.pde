class UiNumberField {
  String label;
  String text;
  float x, y, w, h;
  boolean allowDecimal;

  UiNumberField(String label_, String initialText, boolean allowDecimal_){
    label = label_;
    text = initialText;
    allowDecimal = allowDecimal_;
  }

  void setBounds(float x_, float y_, float w_, float h_){
    x = x_;
    y = y_;
    w = w_;
    h = h_;
  }

  boolean contains(float mx, float my){
    return mx >= x && mx <= x + w && my >= y && my <= y + h;
  }

  void draw(boolean active){
    textAlign(LEFT, BOTTOM);
    textSize(CONTROL_LABEL_SIZE);
    fill(220);
    text(label, x, y - 4);

    stroke(active ? color(255, 210, 90) : color(110));
    strokeWeight(active ? 2 : 1);
    fill(active ? color(50, 58, 68) : color(35, 40, 48));
    rect(x, y, w, h, 6);

    fill(245);
    textAlign(LEFT, CENTER);
    textSize(15);
    text(text.length() == 0 ? " " : text, x + 10, y + h / 2.0);
    strokeWeight(1);
  }

  void handleKey(char typedKey, int typedKeyCode){
    if(typedKeyCode == BACKSPACE || typedKey == BACKSPACE){
      if(text.length() > 0){
        text = text.substring(0, text.length() - 1);
      }
      return;
    }

    if(typedKeyCode == DELETE || typedKeyCode == TAB || typedKey == ENTER || typedKey == RETURN){
      return;
    }

    if(typedKey >= '0' && typedKey <= '9'){
      text += typedKey;
      return;
    }

    if(allowDecimal && typedKey == '.' && text.indexOf('.') == -1){
      text += typedKey;
    }
  }
}

class UiButton {
  String label;
  float x, y, w, h;
  color baseFill;
  color hoverFill;

  UiButton(String label_, color baseFill_, color hoverFill_){
    label = label_;
    baseFill = baseFill_;
    hoverFill = hoverFill_;
  }

  void setBounds(float x_, float y_, float w_, float h_){
    x = x_;
    y = y_;
    w = w_;
    h = h_;
  }

  boolean contains(float mx, float my){
    return mx >= x && mx <= x + w && my >= y && my <= y + h;
  }

  void draw(){
    boolean hovered = contains(mouseX, mouseY);
    noStroke();
    fill(hovered ? hoverFill : baseFill);
    rect(x, y, w, h, 8);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(15);
    text(label, x + w / 2.0, y + h / 2.0);
  }
}