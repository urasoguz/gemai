#!/bin/bash

# DermAI iOS Localization Translations Updater
# Bu script tüm diller için gerçek çevirileri ekler

# Desteklenen diller ve çevirileri
declare -A translations

# Türkçe
translations["tr"]="tr"
translations["tr_title"]="Türkçe"
translations["tr_camera"]="Deri analizi yapabilmek için kamera erişimi gereklidir. Fotoğraf çekerek cilt durumunuzu analiz edebilirsiniz."
translations["tr_microphone"]="Deri analizi yapabilmek için mikrofon erişimi gereklidir. Video kayıtları için ses kaydı yapılabilir."
translations["tr_photo_read"]="Deri analizi için galeriden fotoğraf seçebilmek için galeri erişimi gereklidir. Mevcut fotoğraflarınızı kullanarak analiz yapabilirsiniz."
translations["tr_photo_write"]="Analiz sonuçlarını kaydetmek için galeri erişimi gereklidir."
translations["tr_location"]="Bu uygulama konum bilgisine yalnızca uygulama açıkken erişir. Bölgesel özellikler için kullanılır."

# İngilizce
translations["en"]="en"
translations["en_title"]="English"
translations["en_camera"]="Camera access is required to perform skin analysis. You can analyze your skin condition by taking photos."
translations["en_microphone"]="Microphone access is required to perform skin analysis. Audio recording can be made for video recordings."
translations["en_photo_read"]="Gallery access is required to select photos from gallery for skin analysis. You can analyze using your existing photos."
translations["en_photo_write"]="Gallery access is required to save analysis results."
translations["en_location"]="This app accesses location information only when the app is open. Used for regional features."

# Çince
translations["zh"]="zh"
translations["zh_title"]="中文"
translations["zh_camera"]="需要相机访问权限来执行皮肤分析。您可以通过拍照来分析皮肤状况。"
translations["zh_microphone"]="需要麦克风访问权限来执行皮肤分析。可以为视频录制进行音频录制。"
translations["zh_photo_read"]="需要图库访问权限来从图库中选择照片进行皮肤分析。您可以使用现有照片进行分析。"
translations["zh_photo_write"]="需要图库访问权限来保存分析结果。"
translations["zh_location"]="此应用程序仅在应用程序打开时访问位置信息。用于区域功能。"

# Rusça
translations["ru"]="ru"
translations["ru_title"]="Русский"
translations["ru_camera"]="Для выполнения анализа кожи требуется доступ к камере. Вы можете анализировать состояние кожи, делая фотографии."
translations["ru_microphone"]="Для выполнения анализа кожи требуется доступ к микрофону. Можно записывать аудио для видеозаписей."
translations["ru_photo_read"]="Для выбора фотографий из галереи для анализа кожи требуется доступ к галерее. Вы можете анализировать, используя существующие фотографии."
translations["ru_photo_write"]="Для сохранения результатов анализа требуется доступ к галерее."
translations["ru_location"]="Это приложение получает доступ к информации о местоположении только когда приложение открыто. Используется для региональных функций."

# İspanyolca
translations["es"]="es"
translations["es_title"]="Español"
translations["es_camera"]="Se requiere acceso a la cámara para realizar análisis de piel. Puede analizar la condición de su piel tomando fotos."
translations["es_microphone"]="Se requiere acceso al micrófono para realizar análisis de piel. Se puede hacer grabación de audio para grabaciones de video."
translations["es_photo_read"]="Se requiere acceso a la galería para seleccionar fotos de la galería para análisis de piel. Puede analizar usando sus fotos existentes."
translations["es_photo_write"]="Se requiere acceso a la galería para guardar los resultados del análisis."
translations["es_location"]="Esta aplicación accede a la información de ubicación solo cuando la aplicación está abierta. Se usa para funciones regionales."

# Fransızca
translations["fr"]="fr"
translations["fr_title"]="Français"
translations["fr_camera"]="L'accès à la caméra est requis pour effectuer l'analyse de la peau. Vous pouvez analyser l'état de votre peau en prenant des photos."
translations["fr_microphone"]="L'accès au microphone est requis pour effectuer l'analyse de la peau. L'enregistrement audio peut être effectué pour les enregistrements vidéo."
translations["fr_photo_read"]="L'accès à la galerie est requis pour sélectionner des photos de la galerie pour l'analyse de la peau. Vous pouvez analyser en utilisant vos photos existantes."
translations["fr_photo_write"]="L'accès à la galerie est requis pour sauvegarder les résultats de l'analyse."
translations["fr_location"]="Cette application accède aux informations de localisation uniquement lorsque l'application est ouverte. Utilisé pour les fonctionnalités régionales."

# Almanca
translations["de"]="de"
translations["de_title"]="Deutsch"
translations["de_camera"]="Kamerazugriff ist erforderlich, um Hautanalysen durchzuführen. Sie können Ihren Hautzustand durch Fotografieren analysieren."
translations["de_microphone"]="Mikrofonzugriff ist erforderlich, um Hautanalysen durchzuführen. Audioaufnahmen können für Videoaufnahmen gemacht werden."
translations["de_photo_read"]="Galeriezugriff ist erforderlich, um Fotos aus der Galerie für Hautanalysen auszuwählen. Sie können mit Ihren vorhandenen Fotos analysieren."
translations["de_photo_write"]="Galeriezugriff ist erforderlich, um Analyseergebnisse zu speichern."
translations["de_location"]="Diese App greift nur dann auf Standortinformationen zu, wenn die App geöffnet ist. Wird für regionale Funktionen verwendet."

# Japonca
translations["ja"]="ja"
translations["ja_title"]="日本語"
translations["ja_camera"]="皮膚分析を実行するにはカメラアクセスが必要です。写真を撮ることで肌の状態を分析できます。"
translations["ja_microphone"]="皮膚分析を実行するにはマイクアクセスが必要です。ビデオ録画用に音声録音ができます。"
translations["ja_photo_read"]="皮膚分析のためにギャラリーから写真を選択するにはギャラリーアクセスが必要です。既存の写真を使用して分析できます。"
translations["ja_photo_write"]="分析結果を保存するにはギャラリーアクセスが必要です。"
translations["ja_location"]="このアプリはアプリが開いている時のみ位置情報にアクセスします。地域機能に使用されます。"

# Korece
translations["ko"]="ko"
translations["ko_title"]="한국어"
translations["ko_camera"]="피부 분석을 수행하려면 카메라 액세스가 필요합니다. 사진을 촬영하여 피부 상태를 분석할 수 있습니다."
translations["ko_microphone"]="피부 분석을 수행하려면 마이크 액세스가 필요합니다. 비디오 녹화를 위한 오디오 녹음이 가능합니다."
translations["ko_photo_read"]="피부 분석을 위해 갤러리에서 사진을 선택하려면 갤러리 액세스가 필요합니다. 기존 사진을 사용하여 분석할 수 있습니다."
translations["ko_photo_write"]="분석 결과를 저장하려면 갤러리 액세스가 필요합니다."
translations["ko_location"]="이 앱은 앱이 열려 있을 때만 위치 정보에 액세스합니다. 지역 기능에 사용됩니다."

# Arapça (zaten mevcut)
translations["ar"]="ar"
translations["ar_title"]="العربية"
translations["ar_camera"]="الوصول إلى الكاميرا مطلوب لإجراء تحليل الجلد. يمكنك تحليل حالة بشرتك من خلال التقاط الصور."
translations["ar_microphone"]="الوصول إلى الميكروفون مطلوب لإجراء تحليل الجلد. يمكن إجراء تسجيل صوتي للتسجيلات المرئية."
translations["ar_photo_read"]="الوصول إلى المعرض مطلوب لاختيار الصور من المعرض لتحليل الجلد. يمكنك التحليل باستخدام صورك الموجودة."
translations["ar_photo_write"]="الوصول إلى المعرض مطلوب لحفظ نتائج التحليل."
translations["ar_location"]="يصل هذا التطبيق إلى معلومات الموقع فقط عندما يكون التطبيق مفتوحاً. يستخدم للميزات الإقليمية."

# Ana dizin
base_dir="ios/Runner"

# Her dil için dosyayı güncelle
for lang_code in "tr" "en" "zh" "ru" "es" "fr" "de" "ja" "ko" "ar"; do
    lang_dir="$base_dir/$lang_code.lproj"
    lang_title="${translations[${lang_code}_title]}"
    
    if [ -d "$lang_dir" ]; then
        # Localizable.strings dosyasını güncelle
        cat > "$lang_dir/Localizable.strings" << EOF
/* 
  Localizable.strings ($lang_title)
  DermAI iOS Application
  
  This file contains permission descriptions for $lang_title language support.
*/

// Camera Permission
"NSCameraUsageDescription" = "${translations[${lang_code}_camera]}";

// Microphone Permission
"NSMicrophoneUsageDescription" = "${translations[${lang_code}_microphone]}";

// Photo Library Read Permission
"NSPhotoLibraryUsageDescription" = "${translations[${lang_code}_photo_read]}";

// Photo Library Write Permission
"NSPhotoLibraryAddUsageDescription" = "${translations[${lang_code}_photo_write]}";

// Location Permission
"NSLocationWhenInUseUsageDescription" = "${translations[${lang_code}_location]}";
EOF

        echo "✅ Updated: $lang_dir/Localizable.strings ($lang_title)"
    else
        echo "❌ Directory not found: $lang_dir"
    fi
done

echo "🎉 Localization translations updated successfully!"
echo "📁 Total languages updated: 10"
echo "📍 Location: $base_dir/*.lproj/"
echo ""
echo "⚠️  Note: Other languages still contain English text."
echo "💡 To add more languages, update the translations array in this script."
