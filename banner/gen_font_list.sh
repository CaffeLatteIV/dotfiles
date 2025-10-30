font_dir="/usr/share/figlet/fonts"
output_file="valid_fonts.txt"

# Ensure directory exists
if [ ! -d "$font_dir" ]; then
  echo "❌ Font directory not found: $font_dir"
  exit 1
fi

# Temporary test string
test_text="Test"

# Clear or create output file
>"$output_file"

echo "🔍 Checking fonts in: $font_dir"
echo "--------------------------------"

# Loop through all font files
for font_path in "$font_dir"/*; do
  font_name=$(basename "$font_path")

  # Try loading the font quietly
  if figlet -f "$font_path" "$test_text" &>/dev/null; then
    echo "✅ OK: $font_name"
    echo "$font_name" >>"$output_file"
  else
    echo "❌ Bad: $font_name"
  fi
done

echo "--------------------------------"
echo "✅ Valid fonts saved to: $output_file"
echo "📄 Total valid fonts: $(wc -l <"$output_file")"
