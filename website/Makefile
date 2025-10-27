.PHONY: all build clean serve

all: build

build:
	@echo "Building website content..."
	@bash build.sh

clean:
	@echo "Cleaning generated files..."
	@rm -f publications_generated.html blog_index.json
	@rm -f blog/*.html

serve: build
	@echo "Starting local server at http://localhost:8000"
	@python3 -m http.server 8000

dev:
	@echo "Development mode: building and serving..."
	@make build
	@make serve
