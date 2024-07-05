use askama_axum::Template;
use axum::{routing::get, Router};
use tower_http::services::ServeDir;

#[derive(Template)]
#[template(path = "blog.html")]
struct BlogTemplate {
    dark: bool,
}

#[derive(Template)]
#[template(path = "home.html")]
struct HomeTemplate<'a> {
    dark: bool,
    text: &'a str,
}

#[tokio::main]
async fn main() {
    let router = Router::new()
        .route(
            "/",
            get(|| async {
                HomeTemplate {
                    dark: false,
                    text: "# Hello World",
                }
            }),
        )
        .route("/blog", get(|| async { BlogTemplate { dark: false } }))
        .nest_service("/static", ServeDir::new("static"))
        .layer(tower_livereload::LiveReloadLayer::new());

    let listener = tokio::net::TcpListener::bind("0.0.0.0:8000").await.unwrap();
    axum::serve(listener, router).await.unwrap();
}
