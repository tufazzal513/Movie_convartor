# Variables
container_name := "my_shitverter_container"
image_name := "shitverter:latest"
build_env_image_name := "shitverter-buildenv:latest"

# Show available commands
default:
    @just --list

# Stop the container if it is running
stop-container:
    docker stop {{container_name}} || true
    docker rm {{container_name}} || true

# Rebuild the project from scratch and start the container
rebuild:
    IMAGE_NAME={{image_name}} CONTAINER_NAME={{container_name}} ./rebuild.sh

# Start the container without rebuilding
run:
    IMAGE_NAME={{image_name}} CONTAINER_NAME={{container_name}} ./run.sh

# Build the Rust + musl toolchain image for local builds and debugging
build-env:
    docker build --target build-env -t {{build_env_image_name}} .
