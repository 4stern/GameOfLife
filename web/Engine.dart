part of game_of_life;

abstract class Engine {
    CanvasElement canvas = new CanvasElement();
    CanvasRenderingContext2D context2D;
    int renderDelay = 100;
    int cycles = 0;
    List<Function> loops = new List<Function>();

    Engine() {
        document.body.nodes.add(canvas);
        context2D = canvas.context2D;
    }

    void start() {
        window.requestAnimationFrame(_update);
    }

    void _update(num time) {
        loops.forEach((callback){
            callback(time);
        });
        cycles++;
        Duration d = new Duration(milliseconds: renderDelay);
        new Future.delayed(d, (){
            window.requestAnimationFrame(_update);
        });
    }
}
