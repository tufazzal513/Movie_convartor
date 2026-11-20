# Upload this single file as Dockerfile to a Hugging Face Docker Space.
# The Space repository does not need the Rust source code.
FROM rust:1-bookworm AS builder
ARG SOURCE_REPOSITORY=https://github.com/tufazzal513/Movie_convartor.git
ARG SOURCE_BRANCH=main
RUN apt-get update && apt-get install -y --no-install-recommends git pkg-config libssl-dev ca-certificates ffmpeg python3 && rm -rf /var/lib/apt/lists/*
WORKDIR /build
RUN git clone --depth 1 --branch "${SOURCE_BRANCH}" "${SOURCE_REPOSITORY}" source
WORKDIR /build/source
RUN cargo build --release --locked

FROM debian:bookworm-slim
ENV PORT=7860 RUST_LOG=info TMPDIR=/tmp/jobs
RUN apt-get update && apt-get install -y --no-install-recommends ffmpeg ca-certificates python3 && rm -rf /var/lib/apt/lists/* \
    && useradd --create-home --uid 1000 app \
    && mkdir -p /app /tmp/jobs && chown -R app:app /app /tmp/jobs
COPY --from=builder /build/source/target/release/converter-bot /usr/local/bin/converter-bot
USER app
WORKDIR /app
EXPOSE 7860
# HF Spaces requires an HTTP listener on 7860. This lightweight endpoint is
# health-only; the Telegram bot remains the main foreground process.
CMD ["sh", "-lc", "python3 -u -c 'from http.server import BaseHTTPRequestHandler,HTTPServer; H=type(\"H\",(BaseHTTPRequestHandler,),{\"do_GET\":lambda s:(s.send_response(200),s.send_header(\"Content-Type\",\"text/plain\"),s.end_headers(),s.wfile.write(b\"ok\\n\")),\"log_message\":lambda *a:None}); HTTPServer((\"0.0.0.0\",7860),H).serve_forever()' & exec /usr/local/bin/converter-bot"]
