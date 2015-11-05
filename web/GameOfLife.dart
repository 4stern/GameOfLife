part of game_of_life;

class GameOfLife extends Engine{

    List<List<Node>> field = new List<List<Node>>();
    List<Rule> rules = new List<Rule>();

    Point size;
    Point fieldSize;

    num widthFactor;
    num heightFactor;
    Point hoverCoords;

    Pattern patternList = new Pattern();
    List<List<int>> pattern;

    GameOfLife({int sizeX, int sizeY, int fieldX, int fieldY}) {

        size = new Point(sizeX, sizeY);
        fieldSize = new Point(fieldX,fieldY);

        widthFactor = size.x / fieldSize.x;
        heightFactor = size.y / fieldSize.y;

        canvas.width = size.x;
        canvas.height = size.y;

        _createField();
        _conntectNodes();


        loops.add(_loop);
        alwaysLoop.add(_alwaysLoop);

        canvas.onClick.listen((event){
            Point p = getNodeCoords(event);
            onNodeClick(field[p.x][p.y]);
        });
        canvas.onMouseMove.listen((event){
            int offsetY = canvas.offsetTop;
            int offsetX = canvas.offsetLeft;
            int x = event.page.x - offsetX - 1;
            int y = event.page.y - offsetY - 1;
            hoverCoords = new Point(x,y);
        });
        canvas.onMouseOut.listen((event) => hoverCoords = null);
        canvas.onMouseLeave.listen((event) => hoverCoords = null);

        randomizeField();

        pattern = patternList.pattern["glider"];
    }

    void _drawPattern(List<List<int>> pattern, int elementX, int elementY){
        context2D.setStrokeColorRgb(255,0,0);
        context2D.setFillColorRgb(255,0,0);
        for(int y=0; y < pattern.length; y++) {
            for(int x=0; x < pattern[y].length; x++) {
                if (pattern[y][x]==1) context2D.fillRect(
                    (elementX+x)*widthFactor, (elementY+y)*heightFactor,
                    widthFactor,heightFactor
                );
            }
        }
    }

    List<Node> _affectedPatternNodes(Node baseNode, List<List<int>> pattern){
        List<Node> list = new List<Node>();
        for(int y=0; y < pattern.length; y++) {
            for(int x=0; x < pattern[y].length; x++) {
                if (pattern[y][x]==1) {
                    list.add(field[baseNode.x+x][baseNode.y+y]);
                }
            }
        }
        return list;
    }

    void _showHover(){
        if (hoverCoords != null) {
            int x = hoverCoords.x;
            int y = hoverCoords.y;
            int elementX = (x/widthFactor).floor();
            int elementY = (y/heightFactor).floor();

            _drawPattern(pattern, elementX, elementY);
        }
    }

    void onNodeClick(Node node){
        _affectedPatternNodes(node, pattern).forEach((Node affectedNode){
            affectedNode.alive = true;
            affectedNode.nextAliveState = true;
            _renderNode(affectedNode);
        });
    }

    Point getNodeCoords(MouseEvent event){
        int offsetY = canvas.offsetTop;
        int offsetX = canvas.offsetLeft;
        int x = event.page.x - offsetX - 1;
        int y = event.page.y - offsetY - 1;
        int elementX = (x/widthFactor).floor();
        int elementY = (y/heightFactor).floor();
        Point point = new Point(elementX, elementY);
        return point;
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
            node.nextAliveState = node.alive;
        });
        _loop(0);
        stop();
    }

    void clearField(){
        forEachNode((Node node){
            node.alive = false;
        });
        _loop(0);
        stop();
    }

    void _loop(num time){
        _prepareNextState();
        _tipOverNextState();

    }

    void _alwaysLoop(num time){
        _render();
        _showHover();
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
