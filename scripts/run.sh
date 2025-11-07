#!/bin/bash

# GlowAI - Run Script for Multiple Environments
# Usage: ./scripts/run.sh [dev|staging|prod]

set -e

ENV=${1:-dev}

case $ENV in
  dev)
    echo "🚀 Running in DEVELOPMENT mode..."
    flutter run --dart-define=ENV=dev
    ;;
  staging)
    echo "🚀 Running in STAGING mode..."
    flutter run --dart-define=ENV=staging
    ;;
  prod)
    echo "🚀 Running in PRODUCTION mode..."
    flutter run --dart-define=ENV=prod --release
    ;;
  *)
    echo "❌ Invalid environment: $ENV"
    echo "Usage: ./scripts/run.sh [dev|staging|prod]"
    exit 1
    ;;
esac

