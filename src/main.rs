use askama_axum::Template;
use axum::{routing::get, Router};
use markdown::{Constructs, Options, ParseOptions};
use tokio::fs;
use tower_http::services::ServeDir;

#[derive(Template)]
#[template(path = "blog.html")]
struct BlogTemplate {
    content: String,
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
        .route(
            "/blog",
            get(|| async {
                BlogTemplate {
                    content: markdown::to_html_with_options(
                        &fs::read_to_string("src/pi.md")
                            .await
                            .expect("to be a markdown file"),
                        &Options {
                            parse: ParseOptions {
                                constructs: Constructs {
                                    code_indented: false,
                                    ..Constructs::default()
                                },
                                ..ParseOptions::default()
                            },
                            ..Options::default()
                        },
                    )
                    .expect("idk"),
                }
            }),
        )
        .nest_service("/static", ServeDir::new("static"))
        .layer(tower_livereload::LiveReloadLayer::new());

    let listener = tokio::net::TcpListener::bind("0.0.0.0:8000").await.unwrap();
    axum::serve(listener, router).await.unwrap();
}
