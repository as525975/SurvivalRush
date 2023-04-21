public class Game {
    GameMap map;
    boolean pause;
    Player player;
    float gameTimer;
    boolean isOver;

    ArrayList<Enemy> enemies;

    PVector camera;


    public Game () {
        int template = 0; // Test template
        player = new Player(this, new PVector(600, 600));
        map = new GameMap(template); 

        player.setMap(map);
        gameTimer = 15 * 60; // 15 minutes

        camera = new PVector(0,0);

        enemies = new ArrayList<>();
    }

    void draw() {

        camera.x %= map.blockWidth;
        camera.x = camera.x < 0 ? map.blockWidth + camera.x : camera.x;
        camera.y %= map.blockHeight;
        camera.y = camera.y < 0 ? map.blockHeight + camera.y : camera.y;


        background(0);
        // Draw map
        map.draw(camera);
        enemies.forEach((e) -> {e.draw(camera);});
        player.draw();
        // Draw UI
        textSize(20);
        stroke(0);
        text("position:" + player.position, 50, 70);
        text("coord: "+ player.coord, 50, 50);
        if (pause) {
            // Draw pause menu
        }
    }

    void update(int time) {
        if (pause) return;

        float second = time / 1000.0;

        gameTimer -= second;
        if (gameTimer <= 0) timeOut();

        player.update(second);
        enemies.forEach((e) -> {
            e.update(second, camera);
            e.movingDirection(player.position.copy().sub(e.position));
            });

        // Collision Detection:
        // 1. Projectiles with enemies
        player.projectiles.forEach((p) -> {
            if (p.hitTimer <= 0.0) {
                int hits = p.hits;
                enemies.forEach((e) -> {
                    if (e.inCamera && e.isCollide(p, true)) {
                        if(p.active) p.hit(e);
                    }
                });
                if (p.hits != hits) p.runHitTimer();
            } 
        });
        player.projectiles.removeIf(p -> !p.active);
        // 2. Enemies with player
        enemies.forEach((e) -> {
            if (e.isCollide(player, false)) e.hit(player);
        });
        
    }

    void timeOut() {

    }

    void playerDie() {

    }

    void enemyDie(Enemy enemy) {
        enemies.remove(enemy);
        // Drop loot
    }

    void generateEnemy(String name, PVector position) {
        Enemy enemy = new Enemy(name, this, position);
        enemy.setMap(map);
        enemies.add(enemy);
    }

    void addWeapon(WeaponType type) {
        player.ce.addWeapon(type);
    }

    void levelUpWeapon(WeaponType type) {
        player.ce.levelUpWeapon(type);
    }

    void updateCamera(PVector camera) {
        this.camera = camera.copy();
    }

    void keyPressed(char keyChar) {
        if (!pause) {
            if (keyChar == 'd' || keyChar == 'D') player.movingDirection(1, 0);
            if (keyChar == 'a' || keyChar == 'A') player.movingDirection(-1, 0);
            if (keyChar == 'w' || keyChar == 'W') player.movingDirection(0, -1);
            if (keyChar == 's' || keyChar == 'S') player.movingDirection(0, 1);
            if (keyChar == 'c') generateEnemy("test", player.position.copy().add(200, 200));
            if (keyChar == 'x') addWeapon(WeaponType.MAGICWAND);
        }
    }

    void keyReleased(char keyChar) {
        if (!pause) {
            if (keyChar == 'd' || keyChar == 'D') player.movingDirection(-1, 0);
            if (keyChar == 'a' || keyChar == 'A') player.movingDirection(1, 0);
            if (keyChar == 'w' || keyChar == 'W') player.movingDirection(0, 1);
            if (keyChar == 's' || keyChar == 'S') player.movingDirection(0, -1);
        }
    }
}
