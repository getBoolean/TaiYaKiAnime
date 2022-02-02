import 'package:fish_redux/fish_redux.dart';
import 'components/list_cells/component.dart';

import 'state.dart';

class AnimeListAdapter extends SourceFlowAdapter<AnimeListState> {
  AnimeListAdapter()
      : super(pool: <String, Component<Object>>{
          'anime_list_cell': ListCellComponent(),
        });
}
