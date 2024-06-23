use askama_axum::Template;
use axum::{routing::get, Router};


#[derive(Template)]
#[template(path = "hello.html")]
struct HelloTemplate<'a> {
    name: &'a str,
}

async fn templated_hello() -> HelloTemplate<'static> {
    HelloTemplate { name: "Nitro" }
}

async fn hello_world() -> &'static str {
    "Hello, world"
}

#[tokio::main]
async fn main() {
    let mut router = Router::new().route("/", get(hello_world));
    
    
    if cfg!(debug_assertions) {
        router = router.layer(tower_livereload::LiveReloadLayer::new());
    }
    // Needed for axum but not hyper
    let listener = tokio::net::TcpListener::bind("0.0.0.0:8000").await.unwrap();
    axum::serve(listener, router).await.unwrap()
}
