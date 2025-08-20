import 'package:gemai/app/core/localization/de.dart';
import 'package:gemai/app/core/localization/fr.dart';
import 'package:gemai/app/core/localization/it.dart';
import 'package:gemai/app/core/localization/en.dart';
import 'package:gemai/app/core/localization/tr.dart';
import 'package:gemai/app/core/localization/ar.dart';
import 'package:gemai/app/core/localization/zh.dart';
import 'package:gemai/app/core/localization/ja.dart';
import 'package:gemai/app/core/localization/hi.dart';
import 'package:gemai/app/core/localization/ru.dart';
import 'package:gemai/app/core/localization/es.dart';
import 'package:gemai/app/core/localization/id.dart';
import 'package:gemai/app/core/localization/nl.dart';
import 'package:gemai/app/core/localization/ko.dart';
import 'package:gemai/app/core/localization/pl.dart';
import 'package:gemai/app/core/localization/uk.dart';
import 'package:gemai/app/core/localization/vi.dart';
import 'package:gemai/app/core/localization/th.dart';
import 'package:gemai/app/core/localization/pt.dart';
import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en': en,
    'tr': tr,
    'ar': ar,
    'zh': zh,
    'ja': ja,
    'hi': hi,
    'ru': ru,
    'es': es,
    'fr': fr,
    'de': de,
    'it': it,
    'id': id,
    'nl': nl,
    'ko': ko,
    'pl': pl,
    'uk': uk,
    'vi': vi,
    'th': th,
    'pt': pt,
  };
}
