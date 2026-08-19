# syntax=docker/dockerfile:1

# Build context: the workspace root that contains both `packages/` and the
# generated project at `example/`:
#
#   docker build -f example/Dockerfile .
#
# Stage 1 compiles the Dart server binary and the client/SSR JS bundles.
# Stage 2 is a slim runtime: just the compiled server and Node for the SSR
# worker.

# --- Stage 1: build ------------------------------------------------------
FROM dart:stable AS build

# Node runs the JS bundler and the SSR worker; Rust compiles react_tool's
# native TypeScript-extraction library on first use.
RUN apt-get update \
  && apt-get install -y --no-install-recommends curl ca-certificates \
  && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
  && apt-get install -y nodejs \
  && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
      | sh -s -- -y --profile minimal \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
COPY packages/ ./packages/
COPY example/ ./example/

WORKDIR /workspace/example
RUN dart pub get
RUN dart run react_tool:react build --server

# --- Stage 2: runtime -----------------------------------------------------
FROM node:20-bookworm-slim AS runtime

# Keep the same absolute path the SSR entry was bundled against so its React
# imports resolve to the provisioned JS environment.
WORKDIR /workspace/example
ENV PORT=8080 \
    SSR_PORT=3001 \
    REACT_SSR_PORT=3001 \
    REACT_SSR_URL=http://127.0.0.1:3001/
COPY --from=build /workspace/example/build/ ./build/
COPY --from=build /workspace/example/.dart_tool/react/ ./.dart_tool/react/
EXPOSE 8080

# Run the SSR worker in the background, then the Dart application server.
CMD ["sh", "-c", "node build/react/ssr.entry.mjs & exec ./build/react/server"]
