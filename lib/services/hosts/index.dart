import 'base.dart';
import 'streamtape.dart';
import 'x_stream_cdn.dart';

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
