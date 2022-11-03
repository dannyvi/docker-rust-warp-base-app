FROM rust:1.64.0-alpine3.15 as builder

RUN apk add --no-cache musl-dev
WORKDIR /opt
RUN USER=root cargo new --bin demo
WORKDIR /opt/demo
COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml
RUN cargo build --release
RUN rm ./src/*.rs

ADD ./src ./src
RUN cargo build --release

FROM scratch
WORKDIR /opt/demo
COPY --from=builder /opt/demo/target/release/base .

EXPOSE 8000
CMD ["/opt/demo/base"]