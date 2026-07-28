import 'package:react/react.dart';

@reactComponent
ReactNode App(({String title}) props) => div(children: [Text(props.title)]);
