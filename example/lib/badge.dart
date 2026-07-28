import 'package:react_web/react_web.dart';

@reactComponent
ReactNode Badge(({String label}) props) => div(children: [Text(props.label)]);
