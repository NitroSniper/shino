use askama_axum::Template;
use axum::{routing::get, Router};
use tower_http::services::ServeDir;

#[derive(Template)]
#[template(path = "hello.html")]
struct HelloTemplate<'a> {
    name: &'a str,
    dark: bool,
}

async fn templated_hello() -> HelloTemplate<'static> {
    HelloTemplate {
        name: "Nitro",
        dark: true,
    }
}

async fn hello_world() -> &'static str {
    "Hello, wor"
}

#[tokio::main]
async fn main() {
    let router = Router::new()
        .route(
            "/",
            get(|| async {
                HelloTemplate {
                    name: "Nitro",
                    dark: false,
                }
            }),
        )
        .nest_service("/static", ServeDir::new("static"))
        .layer(tower_livereload::LiveReloadLayer::new());
    // Needed for axum but not hyper
    let listener = tokio::net::TcpListener::bind("0.0.0.0:8000").await.unwrap();
    axum::serve(listener, router).await.unwrap()
}
