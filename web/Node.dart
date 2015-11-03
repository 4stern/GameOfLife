part of game_of_life;

class Node {
    List<Node> neighbors;
    bool alive = false;
    bool nextAliveState = null;

    int x;
    int y;

    Node(this.x, this.y) {
        neighbors = new List<Node>();
    }

    void tip(){
        if (nextAliveState != null) {
            alive = nextAliveState;
            nextAliveState = null;
        }
    }

    int countAliveNeighbors() => neighbors.map((item) => item.alive==true?1:0).reduce((value, item) => value+item);
}
