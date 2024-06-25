use askama_axum::Template;
use axum::{routing::get, Router};
use tower_http::services::ServeDir;

#[derive(Template)]
#[template(path = "hello.html")]
struct HelloTemplate {
    dark: bool,
}

#[tokio::main]
async fn main() {
    let router = Router::new()
        .route("/", get(|| async { HelloTemplate { dark: false } }))
        .nest_service("/static", ServeDir::new("static"))
        .layer(tower_livereload::LiveReloadLayer::new());

    let listener = tokio::net::TcpListener::bind("0.0.0.0:8000").await.unwrap();
    axum::serve(listener, router).await.unwrap();
}
