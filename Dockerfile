# Rust as the base image
FROM rust:1.64 as build

# 1. Create a new empty repo
RUN USER=root cargo new --bin base
WORKDIR /base

# 2. Copy our manifests
COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml

# 3. Build only the dependencies to cache
RUN cargo build --release
RUN rm src/*.rs

# 4. Now that the dependency is built, copy source code 
COPY ./src ./src

# 5. Build for release.
RUN rm ./target/release/deps/base-*
RUN cargo build --release

# The final base image
FROM debian:buster-slim

# Copy from the previous build
COPY --from=build /base/target/release/base /usr/src/base

EXPOSE 8000

CMD ["/usr/src/base"]