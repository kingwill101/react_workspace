import 'package:react/react.dart';

@reactComponent
ReactNode Badge(({String label}) props) => div(children: [Text(props.label)]);
