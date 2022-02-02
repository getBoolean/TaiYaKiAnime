import 'package:fish_redux/fish_redux.dart';
import 'cells/component.dart';
import 'state.dart';

class SearchAdapter extends SourceFlowAdapter<SearchState> {
  SearchAdapter()
      : super(pool: <String, Component<Object>>{
          'search_cells': SearchCellsComponent(),
        });
}
