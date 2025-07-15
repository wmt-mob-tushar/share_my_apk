# Share My APK - Development Makefile
# 
# Essential development tasks for Dart package

.PHONY: help install clean format analyze test coverage benchmark package-check quality-gate publish

# Default target
help:
	@echo "📦 Share My APK - Dart Package Development"
	@echo ""
	@echo "🔧 Development:"
	@echo "  install       Install dependencies"
	@echo "  clean         Clean build artifacts"
	@echo "  format        Format Dart code"
	@echo "  analyze       Static analysis"
	@echo "  test          Run tests"
	@echo "  coverage      Coverage report"
	@echo ""
	@echo "📈 Performance:"
	@echo "  benchmark     Performance benchmarks"
	@echo "  complexity    Code complexity analysis"
	@echo ""
	@echo "📦 Package Quality:"
	@echo "  package-check Pub.dev readiness check"
	@echo "  quality-gate  Complete quality validation"
	@echo "  dry-run       Test publishing"
	@echo "  publish       Publish to pub.dev"

# Setup & Dependencies
install:
	@echo "📦 Installing dependencies..."
	dart pub get

clean:
	@echo "🧹 Cleaning build artifacts..."
	dart clean
	rm -rf coverage/
	rm -rf doc/api/
	rm -rf build/

# Code Quality
format:
	@echo "🎨 Formatting code..."
	dart format .

analyze:
	@echo "🔍 Running static analysis..."
	dart analyze --fatal-warnings

test:
	@echo "🧪 Running tests..."
	dart test

coverage:
	@echo "📊 Generating coverage report..."
	dart run tool/coverage.dart

benchmark:
	@echo "⚡ Running performance benchmarks..."
	dart run tool/benchmark.dart

complexity:
	@echo "📈 Analyzing code complexity..."
	dart run tool/complexity_analyzer.dart

# Package Quality
package-check:
	@echo "📦 Checking package quality..."
	dart run tool/package_quality.dart

# Quality Gates
quality-gate: clean install format analyze test coverage benchmark complexity package-check
	@echo "✅ Quality gate completed successfully!"

# Publishing
dry-run:
	@echo "🔍 Testing package publishing..."
	dart pub publish --dry-run

publish: quality-gate dry-run
	@echo "📦 Publishing to pub.dev..."
	dart pub publish

# Development helpers
quick-check: format analyze test
	@echo "⚡ Quick quality check completed!"

# Git hooks setup
setup-hooks:
	@echo "🔗 Setting up Git hooks..."
	echo "#!/bin/sh\nmake quality-gate" > .git/hooks/pre-commit
	chmod +x .git/hooks/pre-commit
	@echo "✅ Pre-commit hook installed!"