public class Projectile extends MovableObject {
    float attack;
    float hitInterval;
    int hits;
    Player owner;

    float hitTimer;

    PImage img;

    public Projectile(Player owner, PVector direction, float radius) {
        this.owner = owner;
        this.RADIUS = radius;
        position = owner.position.copy();
        this.direction = direction.copy();
    }
    
    void draw() {
        
    }

    void update(float second) {
        if (hitTimer > 0) hitTimer -= second;
    }

    void hit(MovableObject obj) {
        if (hit > 0) {
            owner.ce.hit(obj.ce);
            hit--;
            if (hit <= 0) die();
        }
    }

    void runHitTimer() {
        hitTimer = hitInterval;
    }

    void die() {
        player.projectils.remove(this);
    }


}