import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show compute;

/// NOTE: Locale Preference
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// NOTE: Lidea view ???
import 'package:lidea/view/main.dart';
export 'package:lidea/view/main.dart';
export 'package:lidea/extension.dart';

export 'package:lidea/routes.dart';

/// NOTE: Route
import '/view/routes.dart';

/// NOTE: Nest and Type
import '/type/main.dart';
export '/type/main.dart';

part 'abstracts.dart';
part 'mocks.dart';
part 'searches.dart';
part 'engines.dart';
part 'view.dart';
part 'app.dart';

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

    await super.initialized(context);

    await mockTest();
    await engineInitialized();

    // await store.init();
    // await sql.init();
    // await poll.init();

    data.suggestQuery = data.searchQuery;

    switchIdentifyPrimary();
    await primaryInit.catchError((e) {
      message.value = e;
    });
    switchIdentifyParallel();
    await scriptureParallel.init();

    message.value = '';

    debugPrint('Initiated in ${initWatch.elapsedMilliseconds} ms');
  }
}
