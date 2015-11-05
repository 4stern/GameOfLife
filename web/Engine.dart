part of game_of_life;

abstract class Engine {
    CanvasElement canvas = new CanvasElement();
    CanvasRenderingContext2D context2D;
    int renderDelay = 100;
    int cycles = 0;
    bool runs = false;
    List<Function> loops = new List<Function>();
    List<Function> alwaysLoop = new List<Function>();

    Engine() {
        document.body.nodes.add(canvas);
        context2D = canvas.context2D;
        window.requestAnimationFrame(_update);
    }

    void start() {
        if (runs == false) {
            runs = true;
        }
    }

    void stop() {
        if (runs == true) {
            runs = false;
        }
    }

    void _update(num time) {
        if (runs == true) {
            loops.forEach((callback){
                callback(time);
            });
            cycles++;
        }

        alwaysLoop.forEach((callback){
            callback(time);
        });
        Duration d = new Duration(milliseconds: renderDelay);
        new Future.delayed(d, (){
            window.requestAnimationFrame(_update);
        });
    }
}
