part of game_of_life;

abstract class Rule {
    GameOfLife gol;
    Rule(this.gol);

    bool execute (Node node);
}

class AwakeRule extends Rule {

    AwakeRule(GameOfLife gol) : super(gol);

    bool execute (Node node){
        bool hasAffected = false;

        if (node.alive == false) {
            int awakeNeighbors = node.countAliveNeighbors();
            if (awakeNeighbors == 3) {
                node.nextAliveState = true;
                hasAffected = true;
            }
        }

        return hasAffected;
    }
}

class DieRule extends Rule {

    DieRule(GameOfLife gol) : super(gol);

    bool execute (Node node){
        bool hasAffected = false;

        if (node.alive == true) {
            int awakeNeighbors = node.countAliveNeighbors();
            if (awakeNeighbors < 2) {
                node.nextAliveState = false;
                hasAffected = true;
            }
            if (awakeNeighbors > 3) {
                node.nextAliveState = false;
                hasAffected = true;
            }
        }

        return hasAffected;
    }
}
