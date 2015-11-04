library game_of_life;

import 'dart:html';
import 'dart:math';
import 'dart:async';

part 'Engine.dart';
part 'Rules.dart';
part 'Node.dart';
part 'GameOfLife.dart';

void main() {
    GameOfLife gol = new GameOfLife(
        sizeX: 500, sizeY: 500,
        fieldX: 50, fieldY: 50
    );
    gol.rules.add(new AwakeRule(gol));
    gol.rules.add(new DieRule(gol));

    InputElement delaySlider = new InputElement();
    delaySlider.type = "range";
    delaySlider.min = "0";
    delaySlider.max = "1000";
    delaySlider.step = "50";
    delaySlider.value = gol.renderDelay.toString();
    delaySlider.onChange.listen((e){
        gol.renderDelay = int.parse(delaySlider.value);
    });

    ButtonElement reset = new ButtonElement();
    reset.text="random";
    reset.onClick.listen((e){
        gol.randomizeField();
    });

    ButtonElement startStop = new ButtonElement();
    startStop.text="start";
    startStop.onClick.listen((e){
        if (gol.runs == true) {
            startStop.text="start";
            gol.stop();
        } else {
            startStop.text="stop";
            gol.start();
        }
    });

    ButtonElement clear = new ButtonElement();
    clear.text="clear";
    clear.onClick.listen((e){
        gol.clearField();
    });

    DivElement cyclesCounter = new DivElement();
    gol.loops.add((num time){
        cyclesCounter.text = gol.cycles.toString();
    });

    document.body.nodes.add(cyclesCounter);
    document.body.nodes.add(delaySlider);
    document.body.nodes.add(reset);
    document.body.nodes.add(clear);
    document.body.nodes.add(startStop);

    // gol.start();
}
