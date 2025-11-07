.PHONY: help run-dev run-staging run-prod test analyze format clean

help:
	@echo "Available commands:"
	@echo "  make run-dev        - Run app in development mode"
	@echo "  make run-staging    - Run app in staging mode"
	@echo "  make run-prod       - Run app in production mode"
	@echo "  make test           - Run all tests"
	@echo "  make analyze        - Run static analysis"
	@echo "  make format         - Format code"
	@echo "  make clean          - Clean build artifacts"

run-dev:
	@echo "🚀 Running in DEVELOPMENT mode..."
	flutter run --dart-define=ENV=dev

run-staging:
	@echo "🚀 Running in STAGING mode..."
	flutter run --dart-define=ENV=staging

run-prod:
	@echo "🚀 Running in PRODUCTION mode..."
	flutter run --dart-define=ENV=prod --release

test:
	flutter test

analyze:
	flutter analyze

format:
	dart format .

clean:
	flutter clean
	flutter pub get

