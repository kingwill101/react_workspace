import 'package:react_core/react.dart';

@reactComponent
ReactNode Avatar(({String src, int size}) props) =>
    Text('${props.src}:${props.size}');
