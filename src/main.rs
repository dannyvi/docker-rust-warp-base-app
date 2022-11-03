#![deny(warnings)]
use warp::{Filter};

#[tokio::main]
async fn main() {

    let route = warp::any().map(|| "Hello");
    warp::serve(route).run(([0, 0, 0, 0], 8000)).await;
}
