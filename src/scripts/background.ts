import { Application, Sprite, Assets, Graphics } from "pixi.js";
import type { PointData } from "pixi.js";

class Node {
    graphics = new Graphics().circle(100, 100, 5).fill(0xffffff);
    velocity: PointData = { x: 0.0, y: 0 };
    constructor(app: Application) {
        let v = 1;
        let rad = Math.random() * Math.PI;
        this.velocity = { x: Math.cos(rad) * v, y: Math.sin(rad) * v };
        app.stage.addChild(this.graphics);
    }

    update() {
        // move circle in direction of angle
        //
        this.graphics.position.x += this.velocity.x;
        this.graphics.position.y += this.velocity.y;
    }
}

(async () => {
    // The application will create a renderer using WebGL, if possible,
    // with a fallback to a canvas render. It will also setup the ticker
    // and the root stage PIXI.Container
    const app = new Application();

    // Wait for the Renderer to be available
    await app.init({ resizeTo: window, backgroundAlpha: 0 });

    // The application will create a canvas element for you that you
    // can then insert into the DOM
    document.getElementById("background")?.appendChild(app.canvas);

    // load the texture we need
    const texture = await Assets.load(
        "https://raw.githubusercontent.com/pixijs/pixijs/dev/tests/visual/assets/bunny.png",
    );

    // This creates a texture from a 'bunny.png' image
    const bunny = new Sprite(texture);

    // Setup the position of the bunny
    bunny.x = app.renderer.width / 2;
    bunny.y = app.renderer.height / 2;

    // Rotate around the center
    bunny.anchor.x = 0.5;
    bunny.anchor.y = 0.5;
    // Add the bunny to the scene we are building
    app.stage.addChild(bunny);

    let nodes: Node[] = [new Node(app)];

    // Listen for frame updates
    //
    app.ticker.add(() => {
        for (let node of nodes) {
            node.update();
        }

        bunny.rotation += 0.01;
    });
})();
