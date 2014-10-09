import 'dart:html';
import 'dart:async';

DivElement split, upper, lower, outer, inner, alien, antenna, earLeft, earRight, head, armLeft, armRight, abody, footLeft, footRight;
SpanElement otext, stext, lvltex;
int countParts = 7;

void main() {
  assignSelectors();
  startGameClick(); // Wait for a click to remove the brick walls and start the game
}

void startGameClick() {
  bool ready = false;
  const eightHun = const Duration(milliseconds: 800);
  const ninThou = const Duration(milliseconds: 9600);
  int timerIter = 0;
  new Timer(ninThou, () {
    lvltex.text = "Done";
    new Timer(eightHun, () {
      lvltex.text = "Click anywhere";
      ready = true;
      new Timer(eightHun, () {
        lvltex.style.transition = "all 1.8s ease-in-out";
        lvltex.style.transform = "translateY(-900px)";
        const removLvl = const Duration(milliseconds: 1800);
        new Timer(removLvl, () => lvltex.remove());
      });
    });
  });
  new Timer.periodic(eightHun * 2, (Timer t) { //Run optimization for filters
    outer.classes.remove("blurhue");
    alien.classes.add("tofront");
    new Timer(eightHun, () {
      outer.classes.add("blurhue");
      alien.classes.remove("tofront");
      timerIter += 1;
      if (timerIter >= 3) {
        t.cancel();
      }
    });
  });
  StreamSubscription clickStart = split.onClick.listen(ex);
  clickStart.onData((startGame) { //Everything starts here
    if (ready) { //Optimization done
      clickStart.cancel();
      upper.style.transform = "translateY(-2000px)";
      lower.style.transform = "translateY(2000px)";
      const twoSecs = const Duration(milliseconds: 2000);
      const lastTim = const Duration(milliseconds: 8000);
      new Timer(twoSecs, () { //First remove the outer split panels
        upper.remove();
        lower.remove();
        split.remove();
        new Timer(twoSecs, () { //Then fade the otext out and remove it
          otext.style.opacity = "0";
          outer.classes.remove("blurhue");
          const eightHundredMillis = const Duration(milliseconds: 800);
          const onehalfSecs = const Duration(milliseconds: 1500);
          new Timer(eightHundredMillis, () => otext.remove()); //Wait for the transition
          new Timer(onehalfSecs, () { //Wait to pop the red text
            stext.style.opacity = "1";
            new Timer(onehalfSecs, () { //Wait to fade out and z-index to the back
              stext.style.transition = "all 0.8s ease-in-out";
              stext.style.opacity = "0";
              new Timer(eightHundredMillis, () => stext.remove()); //Wait for the transition to remove
            });
          });
        });
      });
      new Timer(lastTim, () { //Get Snoo in front
        alien.classes.add("tofront");
        const eightHundredMillis = const Duration(milliseconds: 800);
        new Timer(eightHundredMillis, () => tearingMeApart()); //Wait for the transition and start tearing
      });
    }
  });
}

void tearingMeApart() { //Tearing happens here TODO: on #outer MouseUp cancel the mousedown effect
  alien.style.transition = "0 !important"; //The script handles everything now
  earLeft.onMouseDown.listen((e) => handleBodyPartClick(earLeft, e));
  earRight.onMouseDown.listen((e) => handleBodyPartClick(earRight, e));
  armLeft.onMouseDown.listen((e) => handleBodyPartClick(armLeft, e));
  armRight.onMouseDown.listen((e) => handleBodyPartClick(armRight, e));
  footLeft.onMouseDown.listen((e) => handleBodyPartClick(footLeft, e));
  footRight.onMouseDown.listen((e) => handleBodyPartClick(footRight, e));
  antenna.onMouseDown.listen((e) => handleBodyPartClick(antenna, e));
  abody.onMouseDown.listen((e) => handleBodyPartClick(abody, e));
  head.onMouseDown.listen((e) => handleBodyPartClick(head, e));
}

handleBodyPartClick(DivElement bodyPart, MouseEvent event) {
  if ((bodyPart != head && bodyPart != abody) || countParts <= 0) {
    StreamSubscription strm = outer.onMouseUp.listen(ex);
    strm.onData((e) {
      strm.cancel();
      //return to normal
      ////////////// Test: shoot at cursor point on mouseup //////////////
      //Point parentPos = getPosition(e.currentTarget); //First click point
      bodyPart.style.transition = "all 0.2s linear";
      bodyPart.style.borderColor = "#FFF";
      bodyPart.style.transition = "all 1.8s";
      bodyPart.style.transitionTimingFunction = "cubic-bezier(0.000, 1.000, 1.000, 1.000)";
      int xPosition = (e.page.x - event.page.x) * 4;
      int yPosition = (e.page.y - event.page.y) * 4;
      //String trans = "translateX($xPosition" + "px) translateY($yPosition" + "px)";
      bodyPart.style.left = xPosition.toString() + "px";
      bodyPart.style.top = yPosition.toString() + "px";
      //earLeft.style.transform = trans;
      bodyPart.style.opacity = "0";
      //bodyPart.style.transform = "scale(0)";
      const removalDelay = const Duration(milliseconds: 2000);
      new Timer(removalDelay, () => bodyPart.remove());
      countParts -= 1;
      if (countParts == -2) { //gameEnd
        new Timer(removalDelay, () => alien.remove());
        doEndGame();
      }
    });
  }
}


void doEndGame() {
  document.head.appendHtml('<link rel="stylesheet" href="end.css">'); //pretty resource intensive
  ImageElement image = new ImageElement(src: "bloody-link2.gif");
  DivElement imgwrap = new DivElement();
  imgwrap.id = "imgwrap";
  image.onLoad.listen((e) { //load link
    document.body.append(imgwrap);
    imgwrap.append(image);
    const waitSo = const Duration(milliseconds: 200); //This might be needed due to lag, but not sure
    new Timer(waitSo, () {
      imgwrap.style.opacity = "1";
      DivElement speech = new DivElement();
      speech.id = "speech";
      imgwrap.append(speech);
      speech.style.transform = "scaleY(1)";
      String speechText = "Thank you for saving me! I am the Github Link and that was Krov, an evil alien. He took Snoo's form in order to ruin his reputation.";
      speech.text = "T"; //Avoid range error
      int iterCount = 1; //Count string index and timer iterations
      const letterTime = const Duration(milliseconds: 10); //Letter typing
      const sentenceTime = const Duration(milliseconds: 200); //"Pause" at end of sentence
      const endTime = const Duration(milliseconds: 2000); //Roll credits
      new Timer.periodic(letterTime, (Timer t) {
        if (speechText[iterCount - 1] != "." && speechText[iterCount - 1] != "!" && iterCount < speechText.length) { //Previous letter
          speech.text += speechText[iterCount];
          iterCount++;
        } else if (iterCount < speechText.length) {
          new Timer(sentenceTime, () {
            speech.text += speechText[iterCount];
            iterCount++;
          });
        } else {
          new Timer(endTime, () { //End scene
            outer.style.width = "20%";
            imgwrap.style.left = "0";
            new Timer(sentenceTime * 7, () {
              speech.style.transform = "scaleY(0)";
              new Timer(sentenceTime * 3, () { //Timer hell, gotta fix that
                var link1 = new AnchorElement() //This is a workaround because innerHtml alone doesn't work (dart bug?)
                    ..href = 'https://www.github.com/GeKorm';
                speech.innerHtml = """Here's the Github!<div id="key"></div>"""; //TODO: I can get this from a server app on click to keep it private, outside of the client code. Not worth it in this case though.
                querySelector("#key").append(link1);
                link1.innerHtml = '<img src="key.png" id="keyimg">';
                speech.style.transform = "scaleY(1)";
              });
            });
          });
          t.cancel();
        }
      });
    });
  });
  image.onError.listen((e) {
    print("Couldn't load the link gif!");
  });
}

void assignSelectors() {
  lvltex = querySelector("#lvltex");
  split = querySelector("#split");
  upper = querySelector("#upper");
  lower = querySelector("#lower");
  outer = querySelector("#overlay-outer");
  inner = querySelector("#overlay-inner");
  alien = querySelector("#reddit-alien");
  antenna = querySelector("#antenna");
  earLeft = querySelector("#ear-left");
  earRight = querySelector("#ear-right");
  head = querySelector("#alien-head");
  armLeft = querySelector("#arm-left");
  armRight = querySelector("#arm-right");
  abody = querySelector("#alien-body");
  footLeft = querySelector("#foot-left");
  footRight = querySelector("#foot-right");
  otext = querySelector("#otext");
  stext = querySelector("#stext");
}

void ex(MouseEvent event) {
  //Null this
}

/* Point getPosition(Element element) {
    int xPosition = 0;
    int yPosition = 0;

    while (!(element is BodyElement)) {
        xPosition += (element.offsetLeft - element.scrollLeft + element.clientLeft - (alien.client.width/2).round());
        yPosition += (element.offsetTop - element.scrollTop + element.clientTop - (alien.client.height/2).round());
        element = element.offsetParent;
    }

    Point p = new Point(xPosition, yPosition);
    return p;
} */

class Point {
  int x;
  int y;

  Point(this.x, this.y);
}
