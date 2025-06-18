#!/bin/bash

# Test script for GitHub workflow logic
# This script simulates the file discovery and naming logic without actually compiling

echo "=== Typst Notes Workflow Test ==="
echo

echo "Finding Typst files to compile..."
echo

echo "📝 Note files found:"
find . -name "note.typ" -type f | while read -r file; do
  dir=$(dirname "$file")
  dirname=$(basename "$dir")
  echo "  $file -> ${dirname}-note.pdf"
done

echo

echo "📚 Practice files found:"
find . -name "practice.typ" -type f | while read -r file; do
  dir=$(dirname "$file")
  dirname=$(basename "$dir")
  echo "  $file -> ${dirname}-practice.pdf"
done

echo

echo "Expected output PDFs:"
find . -name "note.typ" -type f | while read -r file; do
  dir=$(dirname "$file")
  dirname=$(basename "$dir")
  echo "  ${dirname}-note.pdf"
done

find . -name "practice.typ" -type f | while read -r file; do
  dir=$(dirname "$file")
  dirname=$(basename "$dir")
  echo "  ${dirname}-practice.pdf"
done

echo
echo "=== Test Complete ==="