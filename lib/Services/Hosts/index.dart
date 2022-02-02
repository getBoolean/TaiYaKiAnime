import 'Base.dart';
import 'StreamTape.dart';
import 'XstreamCDN.dart';

HostsBase nameToHostsBase(String name) {
  switch (name.toLowerCase().trim()) {
    case 'xstreamcdn':
      return XstreamCDN();
    case 'streamtape':
      return StreamTape();
    default:
      throw Exception('This host does not exist');
  }
}
