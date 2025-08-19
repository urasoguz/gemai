#!/bin/bash

# DermAI iOS Localization Files Creator
# Bu script tüm desteklenen diller için Localizable.strings dosyalarını oluşturur

# Desteklenen diller
languages=(
    "zh" "ru" "es" "pt" "hi" "fr" "de" "it" "id" "fa" 
    "nl" "sv" "ja" "ko" "pl" "ms" "uk" "ur" "vi" "el" 
    "th" "bn" "fi" "az" "ro" "hu" "cs" "sk" "sr" "he"
)

# Ana dizin
base_dir="ios/Runner"

# Her dil için dosya oluştur
for lang in "${languages[@]}"; do
    lang_dir="$base_dir/$lang.lproj"
    
    # Klasör oluştur
    mkdir -p "$lang_dir"
    
    # Localizable.strings dosyası oluştur
    cat > "$lang_dir/Localizable.strings" << EOF
/* 
  Localizable.strings ($lang)
  DermAI iOS Application
  
  This file contains permission descriptions for $lang language support.
*/

// Camera Permission
"NSCameraUsageDescription" = "Camera access is required to perform skin analysis. You can analyze your skin condition by taking photos.";

// Microphone Permission
"NSMicrophoneUsageDescription" = "Microphone access is required to perform skin analysis. Audio recording can be made for video recordings.";

// Photo Library Read Permission
"NSPhotoLibraryUsageDescription" = "Gallery access is required to select photos from gallery for skin analysis. You can analyze using your existing photos.";

// Photo Library Write Permission
"NSPhotoLibraryAddUsageDescription" = "Gallery access is required to save analysis results.";

// Location Permission
"NSLocationWhenInUseUsageDescription" = "This app accesses location information only when the app is open. Used for regional features.";
EOF

    echo "✅ Created: $lang_dir/Localizable.strings"
done

echo "🎉 All localization files created successfully!"
echo "📁 Total languages: ${#languages[@]}"
echo "📍 Location: $base_dir/*.lproj/"
