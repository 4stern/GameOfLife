part of game_of_life;

class GameOfLife extends Engine{

    List<List<Node>> field = new List<List<Node>>();
    List<Rule> rules = new List<Rule>();

    Point size;
    Point fieldSize;

    num widthFactor;
    num heightFactor;

    GameOfLife({int sizeX, int sizeY, int fieldX, int fieldY}) {

        size = new Point(sizeX, sizeY);
        fieldSize = new Point(fieldX,fieldY);

        widthFactor = size.x / fieldSize.x;
        heightFactor = size.y / fieldSize.y;

        canvas.width = size.x;
        canvas.height = size.y;

        _createField();
        _conntectNodes();
        randomizeField();

        loops.add(_loop);

        canvas.onClick.listen((event){
            int offsetY = canvas.offsetTop;
            int offsetX = canvas.offsetLeft;
            int x = event.page.x - offsetX - 1;
            int y = event.page.y - offsetY - 1;

            int elementX = (x/widthFactor).floor();
            int elementY = (y/heightFactor).floor();

            // print('x: '+x.toString()+' / y:'+y.toString());
            // print('x: '+elementX.toString()+' / y:'+elementY.toString());

            onNodeClick(field[elementX][elementY]);
        });
    }

    void onNodeClick(Node node){
        node.nextAliveState = true;
        node.alive = true;
        _renderNode(node);
    }

    void forEachNode(callback(Node node)){
        for (int x=0; x<field.length; x++) {
            List<Node> xrow = field[x];
            for (int y=0; y<xrow.length; y++) {
                Node node = field[x][y];
                callback(node);
            }
        }
    }

    void _createField() {
        int x = -1;
        int y = -1;

        while(x++ < fieldSize.x-1){
            List<Node> list = new List<Node>();
            while(y++ < fieldSize.y-1){
                list.add(new Node(x, y));
            }
            y=-1;
            field.add(list);
        }
    }

    void _conntectNodes(){
        int maxX = field.length-1;
        int maxY = field[0].length-1;
        forEachNode((Node node){
            if (node.x == 0) { // linke reihe
                if (node.y == 0) {
                    //links oben
                    node.neighbors.add(field[node.x +1][node.y   ]);
                    node.neighbors.add(field[node.x +1][node.y +1]);
                    node.neighbors.add(field[node.x   ][node.y +1]);
                } else if (node.y == maxY) {
                    //links unten
                    node.neighbors.add(field[node.x   ][node.y -1]);
                    node.neighbors.add(field[node.x +1][node.y -1]);
                    node.neighbors.add(field[node.x +1][node.y   ]);
                } else {
                    //linke spalte
                    node.neighbors.add(field[node.x ][node.y -1]);
                    node.neighbors.add(field[node.x ][node.y +1]);
                    node.neighbors.add(field[node.x +1][node.y -1]);
                    node.neighbors.add(field[node.x +1][node.y   ]);
                    node.neighbors.add(field[node.x +1][node.y +1]);
                }
            } else if (node.x == maxX) {//rechte reihe
                if (node.y == 0) {
                    //rechts oben
                    node.neighbors.add(field[node.x -1][node.y   ]);
                    node.neighbors.add(field[node.x -1][node.y +1]);
                    node.neighbors.add(field[node.x   ][node.y +1]);
                } else if (node.y == maxY) {
                    //rechts unten
                    node.neighbors.add(field[node.x   ][node.y -1]);
                    node.neighbors.add(field[node.x -1][node.y -1]);
                    node.neighbors.add(field[node.x -1][node.y   ]);
                } else {
                    //rechte spalte
                    node.neighbors.add(field[node.x   ][node.y -1]);
                    node.neighbors.add(field[node.x   ][node.y +1]);
                    node.neighbors.add(field[node.x -1][node.y -1]);
                    node.neighbors.add(field[node.x -1][node.y   ]);
                    node.neighbors.add(field[node.x -1][node.y +1]);
                }
            } else {// x = mitten im feld
                if (node.y == 0) {
                    //obere reihe
                    node.neighbors.add(field[node.x -1][node.y   ]);
                    node.neighbors.add(field[node.x +1][node.y   ]);
                    node.neighbors.add(field[node.x -1][node.y +1]);
                    node.neighbors.add(field[node.x   ][node.y +1]);
                    node.neighbors.add(field[node.x +1][node.y +1]);
                } else if (node.y == maxY) {
                    //untere reihe
                    node.neighbors.add(field[node.x -1][node.y   ]);
                    node.neighbors.add(field[node.x +1][node.y   ]);
                    node.neighbors.add(field[node.x -1][node.y -1]);
                    node.neighbors.add(field[node.x   ][node.y -1]);
                    node.neighbors.add(field[node.x +1][node.y -1]);
                } else {
                    //freies feld
                    node.neighbors.add(field[node.x -1][node.y -1]);
                    node.neighbors.add(field[node.x   ][node.y -1]);
                    node.neighbors.add(field[node.x +1][node.y -1]);
                    node.neighbors.add(field[node.x -1][node.y ]);
                    node.neighbors.add(field[node.x +1][node.y ]);
                    node.neighbors.add(field[node.x -1][node.y +1]);
                    node.neighbors.add(field[node.x   ][node.y +1]);
                    node.neighbors.add(field[node.x +1][node.y +1]);
                }
            }
        });
    }

    void randomizeField(){
        Random rnd = new Random();
        forEachNode((Node node){
            node.alive = rnd.nextBool();
        });
    }

    void _loop(num time){
        _prepareNextState();
        _tipOverNextState();
        _render();
    }

    void _prepareNextState(){
        forEachNode((Node node){
            for (int i=0; i<rules.length; i++) {
                Rule rule = rules[i];
                if (rule.execute(node)==true){
                    break;
                };
            }
        });
    }

    void _tipOverNextState() {
        forEachNode( (node) => node.tip());
    }

    void _renderNode(Node node){
        if (node.alive == true) {
            context2D.setStrokeColorRgb(0,0,0);
            context2D.setFillColorRgb(0,0,0);
        } else {
            context2D.setStrokeColorRgb(0,0,0);
            context2D.setFillColorRgb(180,180,180);
        }
        context2D.fillRect(
            node.x*widthFactor, node.y*heightFactor,
            widthFactor,heightFactor
        );
    }

    void _render() {
        forEachNode(_renderNode);
    }
}
