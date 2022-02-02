import 'package:fish_redux/fish_redux.dart';
import '../../character_cells/component.dart';
import 'state.dart';

class CharactersAdapter extends SourceFlowAdapter<CharactersState> {
  CharactersAdapter()
      : super(pool: <String, Component<Object>>{
          'character_cells': CharacterCellsComponent(),
        });
}
