library data.core;

// import 'dart:async';
// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show compute;

/// NOTE: Preference
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// NOTE: Authentication
import 'package:lidea/unit/authenticate.dart';

/// NOTE: Core notify and Initializing properties
import 'package:lidea/unit/core.dart';

/// NOTE: Analytics
import 'package:lidea/unit/analytics.dart';

/// NOTE: Individual
import 'package:lidea/unit/store.dart';
import 'package:lidea/unit/sqlite.dart';
import 'package:lidea/unit/speech.dart';
import 'package:lidea/unit/audio.dart';

import 'package:lidea/view/main.dart' show ViewScrolls, ViewData;
export 'package:lidea/view/main.dart';

/// NOTE: Nest and Type
import '/type/main.dart';
export '/type/main.dart';

part 'abstracts.dart';
part 'mocks.dart';
part 'engines.dart';
part 'searches.dart';
part 'view.dart';

part 'preference.dart';
part 'authenticate.dart';
part 'analytics.dart';

part 'store.dart';
part 'sqlite.dart';
part 'speech.dart';
part 'audio.dart';
part 'poll.dart';

part 'scripture/scripture.dart';

/// Scripture marks (user)
part 'scripture/marks.dart';

/// Scripture categories and references (app)
part 'scripture/refs.dart';

class Core extends _Searches {
  @override
  Future<void> initialized(BuildContext context) async {
    Stopwatch initWatch = Stopwatch()..start();

    preference.setContext(context);
    await super.initialized(context);

    await mockTest();
    await engineInitialized();

    // await store.init();
    // await sql.init();
    await poll.init();

    data.suggestQuery = data.searchQuery;

    switchIdentifyPrimary();
    await primaryInit.catchError((e) {
      // debugPrint('scripturePrimary: $e');
    });
    switchIdentifyParallel();
    // await scriptureParallel.init().catchError((e) {
    //   debugPrint('scriptureParallel: $e');
    // });
    await scriptureParallel.init();

    message.value = '';

    debugPrint('Initiated in ${initWatch.elapsedMilliseconds} ms');
  }
}
