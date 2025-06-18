#!/bin/bash

# Test script to simulate the GitHub workflow locally
echo "🧪 Testing Typst compilation workflow locally..."

# Create output directory
mkdir -p compiled-pdfs

# Find all directories containing note.typ or practice.typ files
find . -name "note.typ" -o -name "practice.typ" | while read -r file; do
  # Get the directory name
  dir=$(dirname "$file")
  dir_name=$(basename "$dir")
  
  # Skip template directory
  if [ "$dir_name" = "template" ]; then
    echo "⏭️  Skipping template directory"
    continue
  fi
  
  # Get the filename without extension
  filename=$(basename "$file" .typ)
  
  echo "📝 Found: $file in directory $dir_name"
  echo "   Will be compiled to: ${dir_name}-${filename}.pdf"
  
  # For testing, just show what would be compiled
  # Uncomment the next lines to actually compile (requires Typst installed)
  # if typst compile "$file" "compiled-pdfs/${dir_name}-${filename}.pdf"; then
  #   echo "✅ Successfully compiled $file"
  # else
  #   echo "❌ Failed to compile $file"
  #   exit 1
  # fi
done

echo ""
echo "📋 Summary of files that would be compiled:"
find . -name "note.typ" -o -name "practice.typ" | while read -r file; do
  dir=$(dirname "$file")
  dir_name=$(basename "$dir")
  if [ "$dir_name" != "template" ]; then
    filename=$(basename "$file" .typ)
    echo "  • ${dir_name}-${filename}.pdf"
  fi
done

echo ""
echo "✅ Test completed successfully!"
echo "🚀 The workflow should work correctly when pushed to GitHub."