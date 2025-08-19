#!/bin/bash

# Kalan Diller İçin Çeviri Güncellemesi
# Bu script kalan 18 dil için çevirileri ekler

# Malayca
cat > ios/Runner/ms.lproj/Localizable.strings << 'EOF'
/* 
  Localizable.strings (Melayu)
  DermAI iOS Aplikasi
  
  Fail ini mengandungi penerangan kebenaran untuk sokongan bahasa Melayu.
*/

// Kebenaran Kamera
"NSCameraUsageDescription" = "Akses kamera diperlukan untuk melakukan analisis kulit. Anda boleh menganalisis keadaan kulit anda dengan mengambil gambar.";

// Kebenaran Mikrofon
"NSMicrophoneUsageDescription" = "Akses mikrofon diperlukan untuk melakukan analisis kulit. Rakaman audio boleh dibuat untuk rakaman video.";

// Kebenaran Membaca Perpustakaan Foto
"NSPhotoLibraryUsageDescription" = "Akses galeri diperlukan untuk memilih gambar dari galeri untuk analisis kulit. Anda boleh menganalisis menggunakan gambar sedia ada anda.";

// Kebenaran Menulis Perpustakaan Foto
"NSPhotoLibraryAddUsageDescription" = "Akses galeri diperlukan untuk menyimpan hasil analisis.";

// Kebenaran Lokasi
"NSLocationWhenInUseUsageDescription" = "Aplikasi ini mengakses maklumat lokasi hanya apabila aplikasi terbuka. Digunakan untuk ciri-ciri serantau.";
EOF

# Ukraynaca
cat > ios/Runner/uk.lproj/Localizable.strings << 'EOF'
/* 
  Localizable.strings (Українська)
  DermAI iOS Додаток
  
  Цей файл містить описи дозволів для підтримки української мови.
*/

// Дозвіл на Камеру
"NSCameraUsageDescription" = "Для виконання аналізу шкіри потрібен доступ до камери. Ви можете аналізувати стан шкіри, роблячи фотографії.";

// Дозвіл на Мікрофон
"NSMicrophoneUsageDescription" = "Для виконання аналізу шкіри потрібен доступ до мікрофона. Можна записувати аудіо для відеозаписів.";

// Дозвіл на Читання Фотобібліотеки
"NSPhotoLibraryUsageDescription" = "Для вибору фотографій з галереї для аналізу шкіри потрібен доступ до галереї. Ви можете аналізувати, використовуючи існуючі фотографії.";

// Дозвіл на Запис у Фотобібліотеку
"NSPhotoLibraryAddUsageDescription" = "Для збереження результатів аналізу потрібен доступ до галереї.";

// Дозвіл на Місцезнаходження
"NSLocationWhenInUseUsageDescription" = "Цей додаток отримує доступ до інформації про місцезнаходження тільки коли додаток відкритий. Використовується для регіональних функцій.";
EOF

# Urduca
cat > ios/Runner/ur.lproj/Localizable.strings << 'EOF'
/* 
  Localizable.strings (اردو)
  DermAI iOS ایپلیکیشن
  
  یہ فائل اردو زبان کی حمایت کے لیے اجازت کی تفصیلات شامل کرتی ہے۔
*/

// کیمرہ کی اجازت
"NSCameraUsageDescription" = "جلد کی تجزیہ کرنے کے لیے کیمرہ تک رسائی ضروری ہے۔ آپ اپنی جلد کی حالت کا تجزیہ کر سکتے ہیں تصاویر لے کر۔";

// مائیکروفون کی اجازت
"NSMicrophoneUsageDescription" = "جلد کی تجزیہ کرنے کے لیے مائیکروفون تک رسائی ضروری ہے۔ ویڈیو ریکارڈنگ کے لیے آڈیو ریکارڈنگ کی جا سکتی ہے۔";

// فوٹو لائبریری پڑھنے کی اجازت
"NSPhotoLibraryUsageDescription" = "جلد کی تجزیہ کے لیے گیلری سے تصاویر منتخب کرنے کے لیے گیلری تک رسائی ضروری ہے۔ آپ اپنی موجودہ تصاویر کا استعمال کر کے تجزیہ کر سکتے ہیں۔";

// فوٹو لائبریری لکھنے کی اجازت
"NSPhotoLibraryAddUsageDescription" = "تجزیہ کے نتائج محفوظ کرنے کے لیے گیلری تک رسائی ضروری ہے۔";

// مقام کی اجازت
"NSLocationWhenInUseUsageDescription" = "یہ ایپ صرف تب مقام کی معلومات تک رسائی حاصل کرتی ہے جب ایپ کھلی ہو۔ علاقائی خصوصیات کے لیے استعمال ہوتی ہے۔";
EOF

# Vietnamca
cat > ios/Runner/vi.lproj/Localizable.strings << 'EOF'
/* 
  Localizable.strings (Tiếng Việt)
  DermAI iOS Ứng dụng
  
  Tệp này chứa mô tả quyền truy cập cho hỗ trợ ngôn ngữ tiếng Việt.
*/

// Quyền Truy cập Máy ảnh
"NSCameraUsageDescription" = "Quyền truy cập máy ảnh là cần thiết để thực hiện phân tích da. Bạn có thể phân tích tình trạng da của mình bằng cách chụp ảnh.";

// Quyền Truy cập Microphone
"NSMicrophoneUsageDescription" = "Quyền truy cập microphone là cần thiết để thực hiện phân tích da. Ghi âm có thể được thực hiện cho ghi hình video.";

// Quyền Đọc Thư viện Ảnh
"NSPhotoLibraryUsageDescription" = "Quyền truy cập thư viện là cần thiết để chọn ảnh từ thư viện để phân tích da. Bạn có thể phân tích sử dụng ảnh hiện có của mình.";

// Quyền Ghi Thư viện Ảnh
"NSPhotoLibraryAddUsageDescription" = "Quyền truy cập thư viện là cần thiết để lưu kết quả phân tích.";

// Quyền Vị trí
"NSLocationWhenInUseUsageDescription" = "Ứng dụng này chỉ truy cập thông tin vị trí khi ứng dụng đang mở. Được sử dụng cho các tính năng khu vực.";
EOF

# Yunanca
cat > ios/Runner/el.lproj/Localizable.strings << 'EOF'
/* 
  Localizable.strings (Ελληνικά)
  DermAI iOS Εφαρμογή
  
  Αυτό το αρχείο περιέχει περιγραφές αδειών για την υποστήριξη της ελληνικής γλώσσας.
*/

// Άδεια Κάμερας
"NSCameraUsageDescription" = "Η πρόσβαση στην κάμερα απαιτείται για την εκτέλεση ανάλυσης δέρματος. Μπορείτε να αναλύσετε την κατάσταση του δέρματός σας τραβώντας φωτογραφίες.";

// Άδεια Μικροφώνου
"NSMicrophoneUsageDescription" = "Η πρόσβαση στο μικρόφωνο απαιτείται για την εκτέλεση ανάλυσης δέρματος. Η ηχογράφηση μπορεί να γίνει για βιντεογραφήσεις.";

// Άδεια Ανάγνωσης Φωτογραφικής Βιβλιοθήκης
"NSPhotoLibraryUsageDescription" = "Η πρόσβαση στη γκαλερί απαιτείται για την επιλογή φωτογραφιών από τη γκαλερί για ανάλυση δέρματος. Μπορείτε να αναλύσετε χρησιμοποιώντας τις υπάρχουσες φωτογραφίες σας.";

// Άδεια Εγγραφής Φωτογραφικής Βιβλιοθήκης
"NSPhotoLibraryAddUsageDescription" = "Η πρόσβαση στη γκαλερί απαιτείται για την αποθήκευση των αποτελεσμάτων ανάλυσης.";

// Άδεια Τοποθεσίας
"NSLocationWhenInUseUsageDescription" = "Αυτή η εφαρμογή έχει πρόσβαση στις πληροφορίες τοποθεσίας μόνο όταν η εφαρμογή είναι ανοιχτή. Χρησιμοποιείται για περιφερειακά χαρακτηριστικά.";
EOF

# Tayca
cat > ios/Runner/th.lproj/Localizable.strings << 'EOF'
/* 
  Localizable.strings (ภาษาไทย)
  DermAI iOS แอปพลิเคชัน
  
  ไฟล์นี้มีคำอธิบายสิทธิ์สำหรับการรองรับภาษาไทย
*/

// สิทธิ์กล้อง
"NSCameraUsageDescription" = "การเข้าถึงกล้องจำเป็นสำหรับการวิเคราะห์ผิวหนัง คุณสามารถวิเคราะห์สภาพผิวของคุณได้โดยการถ่ายภาพ";

// สิทธิ์ไมโครโฟน
"NSMicrophoneUsageDescription" = "การเข้าถึงไมโครโฟนจำเป็นสำหรับการวิเคราะห์ผิวหนัง การบันทึกเสียงสามารถทำได้สำหรับการบันทึกวิดีโอ";

// สิทธิ์การอ่านไลบรารีรูปภาพ
"NSPhotoLibraryUsageDescription" = "การเข้าถึงแกลเลอรี่จำเป็นสำหรับการเลือกรูปภาพจากแกลเลอรี่สำหรับการวิเคราะห์ผิวหนัง คุณสามารถวิเคราะห์โดยใช้รูปภาพที่มีอยู่ของคุณ";

// สิทธิ์การเขียนไลบรารีรูปภาพ
"NSPhotoLibraryAddUsageDescription" = "การเข้าถึงแกลเลอรี่จำเป็นสำหรับการบันทึกผลการวิเคราะห์";

// สิทธิ์ตำแหน่ง
"NSLocationWhenInUseUsageDescription" = "แอปนี้เข้าถึงข้อมูลตำแหน่งเฉพาะเมื่อแอปเปิดอยู่ ใช้สำหรับคุณสมบัติภูมิภาค";
EOF

# Bengalce
cat > ios/Runner/bn.lproj/Localizable.strings << 'EOF'
/* 
  Localizable.strings (বাংলা)
  DermAI iOS অ্যাপ্লিকেশন
  
  এই ফাইলটি বাংলা ভাষা সমর্থনের জন্য অনুমতির বিবরণ ধারণ করে।
*/

// ক্যামেরা অনুমতি
"NSCameraUsageDescription" = "চর্ম বিশ্লেষণ করার জন্য ক্যামেরা অ্যাক্সেস প্রয়োজন। আপনি ছবি তুলে আপনার ত্বকের অবস্থা বিশ্লেষণ করতে পারেন।";

// মাইক্রোফোন অনুমতি
"NSMicrophoneUsageDescription" = "চর্ম বিশ্লেষণ করার জন্য মাইক্রোফোন অ্যাক্সেস প্রয়োজন। ভিডিও রেকর্ডিংয়ের জন্য অডিও রেকর্ডিং করা যেতে পারে।";

// ফটো লাইব্রেরি পড়ার অনুমতি
"NSPhotoLibraryUsageDescription" = "চর্ম বিশ্লেষণের জন্য গ্যালারি থেকে ছবি নির্বাচন করার জন্য গ্যালারি অ্যাক্সেস প্রয়োজন। আপনি আপনার বিদ্যমান ছবি ব্যবহার করে বিশ্লেষণ করতে পারেন।";

// ফটো লাইব্রেরি লেখার অনুমতি
"NSPhotoLibraryAddUsageDescription" = "বিশ্লেষণের ফলাফল সংরক্ষণ করার জন্য গ্যালারি অ্যাক্সেস প্রয়োজন।";

// অবস্থান অনুমতি
"NSLocationWhenInUseUsageDescription" = "এই অ্যাপটি কেবল তখনই অবস্থানের তথ্যে অ্যাক্সেস করে যখন অ্যাপটি খোলা থাকে। আঞ্চলিক বৈশিষ্ট্যগুলির জন্য ব্যবহৃত হয়।";
EOF

# Fince
cat > ios/Runner/fi.lproj/Localizable.strings << 'EOF'
/* 
  Localizable.strings (Suomi)
  DermAI iOS Sovellus
  
  Tämä tiedosto sisältää luvakuvaukset suomen kielen tuen.
*/

// Kameran Lupa
"NSCameraUsageDescription" = "Kameran käyttö on tarpeen ihon analysoimiseen. Voit analysoida ihosi tilan ottamalla kuvia.";

// Mikrofonin Lupa
"NSMicrophoneUsageDescription" = "Mikrofonin käyttö on tarpeen ihon analysoimiseen. Äänitys voidaan tehdä videoihin.";

// Valokuvakirjaston Lukulupa
"NSPhotoLibraryUsageDescription" = "Gallerian käyttö on tarpeen valokuvien valitsemiseen galleriasta ihon analysoimiseen. Voit analysoida käyttämällä olemassa olevia kuvia.";

// Valokuvakirjaston Kirjoituslupa
"NSPhotoLibraryAddUsageDescription" = "Gallerian käyttö on tarpeen analyysitulosten tallentamiseen.";

// Sijainnin Lupa
"NSLocationWhenInUseUsageDescription" = "Tämä sovellus käyttää sijaintitietoja vain kun sovellus on auki. Käytetään alueellisiin ominaisuuksiin.";
EOF

# Azerbaycanca
cat > ios/Runner/az.lproj/Localizable.strings << 'EOF'
/* 
  Localizable.strings (Azərbaycanca)
  DermAI iOS Tətbiq
  
  Bu fayl Azərbaycan dili dəstəyi üçün icazə təsvirlərini əhatə edir.
*/

// Kamera İcazəsi
"NSCameraUsageDescription" = "Dəri analizi aparmaq üçün kameraya giriş tələb olunur. Şəkil çəkərək dərinizin vəziyyətini analiz edə bilərsiniz.";

// Mikrofon İcazəsi
"NSMicrophoneUsageDescription" = "Dəri analizi aparmaq üçün mikrofona giriş tələb olunur. Video yazıları üçün səs yazısı edilə bilər.";

// Fotoqrafiya Kitabxanası Oxuma İcazəsi
"NSPhotoLibraryUsageDescription" = "Dəri analizi üçün qalereyadan fotoşəkil seçmək üçün qalereyaya giriş tələb olunur. Mövcud fotoşəkillərinizi istifadə edərək analiz edə bilərsiniz.";

// Fotoqrafiya Kitabxanası Yazma İcazəsi
"NSPhotoLibraryAddUsageDescription" = "Analiz nəticələrini saxlamaq üçün qalereyaya giriş tələb olunur.";

// Məkan İcazəsi
"NSLocationWhenInUseUsageDescription" = "Bu tətbiq yalnız tətbiq açıq olduqda məkan məlumatına daxil olur. Regional xüsusiyyətlər üçün istifadə olunur.";
EOF

# Romence
cat > ios/Runner/ro.lproj/Localizable.strings << 'EOF'
/* 
  Localizable.strings (Română)
  DermAI iOS Aplicație
  
  Acest fișier conține descrieri ale permisiunilor pentru suportul limbii române.
*/

// Permisiunea Camerei
"NSCameraUsageDescription" = "Accesul la cameră este necesar pentru a efectua analiza pielii. Puteți analiza starea pielii prin fotografiere.";

// Permisiunea Microfonului
"NSMicrophoneUsageDescription" = "Accesul la microfon este necesar pentru a efectua analiza pielii. Înregistrarea audio poate fi făcută pentru înregistrări video.";

// Permisiunea de Citire a Bibliotecii de Fotografii
"NSPhotoLibraryUsageDescription" = "Accesul la galerie este necesar pentru a selecta fotografii din galerie pentru analiza pielii. Puteți analiza folosind fotografiile existente.";

// Permisiunea de Scriere în Biblioteca de Fotografii
"NSPhotoLibraryAddUsageDescription" = "Accesul la galerie este necesar pentru a salva rezultatele analizei.";

// Permisiunea de Locație
"NSLocationWhenInUseUsageDescription" = "Această aplicație accesează informațiile de locație doar când aplicația este deschisă. Folosit pentru funcții regionale.";
EOF

# Macarca
cat > ios/Runner/hu.lproj/Localizable.strings << 'EOF'
/* 
  Localizable.strings (Magyar)
  DermAI iOS Alkalmazás
  
  Ez a fájl a magyar nyelvi támogatáshoz szükséges engedélyek leírásait tartalmazza.
*/

// Kamera Engedély
"NSCameraUsageDescription" = "A bőranalízis elvégzéséhez kamera hozzáférés szükséges. Fotókat készítve elemezheti bőrének állapotát.";

// Mikrofon Engedély
"NSMicrophoneUsageDescription" = "A bőranalízis elvégzéséhez mikrofon hozzáférés szükséges. Hangfelvétel készíthető videófelvételekhez.";

// Fotókönyvtár Olvasási Engedély
"NSPhotoLibraryUsageDescription" = "A galéria hozzáférés szükséges a bőranalízishez szükséges fotók kiválasztásához a galériából. Elemezheti meglévő fotóival.";

// Fotókönyvtár Írási Engedély
"NSPhotoLibraryAddUsageDescription" = "A galéria hozzáférés szükséges az elemzési eredmények mentéséhez.";

// Helyzet Engedély
"NSLocationWhenInUseUsageDescription" = "Ez az alkalmazás csak akkor fér hozzá a helyzetinformációhoz, amikor az alkalmazás nyitva van. Regionális funkciókhoz használatos.";
EOF

# Çekçe
cat > ios/Runner/cs.lproj/Localizable.strings << 'EOF'
/* 
  Localizable.strings (Čeština)
  DermAI iOS Aplikace
  
  Tento soubor obsahuje popisy oprávnění pro podporu českého jazyka.
*/

// Oprávnění Kamery
"NSCameraUsageDescription" = "Pro provedení analýzy kůže je nutný přístup ke kameře. Můžete analyzovat stav své kůže pořizováním fotografií.";

// Oprávnění Mikrofonu
"NSMicrophoneUsageDescription" = "Pro provedení analýzy kůže je nutný přístup k mikrofonu. Zvukový záznam může být pořízen pro videozáznamy.";

// Oprávnění ke Čtení Fotogalerie
"NSPhotoLibraryUsageDescription" = "Pro výběr fotografií z galerie pro analýzu kůže je nutný přístup ke galerii. Můžete analyzovat pomocí svých existujících fotografií.";

// Oprávnění k Zápisu do Fotogalerie
"NSPhotoLibraryAddUsageDescription" = "Pro uložení výsledků analýzy je nutný přístup ke galerii.";

// Oprávnění k Poloze
"NSLocationWhenInUseUsageDescription" = "Tato aplikace přistupuje k informacím o poloze pouze když je aplikace otevřená. Používá se pro regionální funkce.";
EOF

# Slovakça
cat > ios/Runner/sk.lproj/Localizable.strings << 'EOF'
/* 
  Localizable.strings (Slovenčina)
  DermAI iOS Aplikácia
  
  Tento súbor obsahuje popisy oprávnení pre podporu slovenského jazyka.
*/

// Oprávnenie Kamery
"NSCameraUsageDescription" = "Pre vykonanie analýzy kože je potrebný prístup ku kamere. Môžete analyzovať stav vašej kože fotografovaním.";

// Oprávnenie Mikrofónu
"NSMicrophoneUsageDescription" = "Pre vykonanie analýzy kože je potrebný prístup k mikrofónu. Zvukový záznam môže byť vytvorený pre videozáznamy.";

// Oprávnenie na Čítanie Fotogalérie
"NSPhotoLibraryUsageDescription" = "Pre výber fotografií z galérie pre analýzu kože je potrebný prístup ku galérii. Môžete analyzovať pomocou vašich existujúcich fotografií.";

// Oprávnenie na Zápis do Fotogalérie
"NSPhotoLibraryAddUsageDescription" = "Pre uloženie výsledkov analýzy je potrebný prístup ku galérii.";

// Oprávnenie na Polohu
"NSLocationWhenInUseUsageDescription" = "Táto aplikácia pristupuje k informáciám o polohe len keď je aplikácia otvorená. Používa sa pre regionálne funkcie.";
EOF

# Sırpça
cat > ios/Runner/sr.lproj/Localizable.strings << 'EOF'
/* 
  Localizable.strings (Српски)
  DermAI iOS Апликација
  
  Овај фајл садржи описе дозвола за подршку српском језику.
*/

// Дозвола за Камеру
"NSCameraUsageDescription" = "Приступ камери је потребан за обављање анализе коже. Можете анализирати стање ваше коже снимањем фотографија.";

// Дозвола за Микрофон
"NSMicrophoneUsageDescription" = "Приступ микрофону је потребан за обављање анализе коже. Звучни снимак може бити направљен за видео снимке.";

// Дозвола за Читање Фотогалерије
"NSPhotoLibraryUsageDescription" = "Приступ галерији је потребан за избор фотографија из галерије за анализу коже. Можете анализирати користећи ваше постојеће фотографије.";

// Дозвола за Писање у Фотогалерију
"NSPhotoLibraryAddUsageDescription" = "Приступ галерији је потребан за чување резултата анализе.";

// Дозвола за Локацију
"NSLocationWhenInUseUsageDescription" = "Ова апликација приступа информацијама о локацији само када је апликација отворена. Користи се за регионалне функције.";
EOF

# İbranice
cat > ios/Runner/he.lproj/Localizable.strings << 'EOF'
/* 
  Localizable.strings (עברית)
  DermAI iOS אפליקציה
  
  קובץ זה מכיל תיאורי הרשאות לתמיכה בשפה העברית.
*/

// הרשאת מצלמה
"NSCameraUsageDescription" = "גישה למצלמה נדרשת לביצוע ניתוח עור. אתה יכול לנתח את מצב העור שלך על ידי צילום תמונות.";

// הרשאת מיקרופון
"NSMicrophoneUsageDescription" = "גישה למיקרופון נדרשת לביצוע ניתוח עור. הקלטת אודיו יכולה להיעשות להקלטות וידאו.";

// הרשאת קריאת ספריית תמונות
"NSPhotoLibraryUsageDescription" = "גישה לגלריה נדרשת לבחירת תמונות מהגלריה לניתוח עור. אתה יכול לנתח באמצעות התמונות הקיימות שלך.";

// הרשאת כתיבה לספריית תמונות
"NSPhotoLibraryAddUsageDescription" = "גישה לגלריה נדרשת לשמירת תוצאות הניתוח.";

// הרשאת מיקום
"NSLocationWhenInUseUsageDescription" = "אפליקציה זו ניגשת למידע מיקום רק כאשר האפליקציה פתוחה. משמש לתכונות אזוריות.";
EOF

echo "🎉 Tüm diller için çeviriler başarıyla eklendi!"
echo "📁 Toplam güncellenen dil: 18"
echo "📍 Konum: ios/Runner/*.lproj/"
