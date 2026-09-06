import 'package:react_core/react.dart';
import 'package:react_dom/react_dom.dart';
import 'package:react_web/web.dart' as web;

/// Theme values supported by the dashboard.
enum ThemeMode { dark, light }

/// Value exposed by [useTheme].
final class ThemeContextValue {
  /// Creates a theme context value.
  const ThemeContextValue({
    required this.theme,
    required this.setTheme,
    required this.toggleTheme,
  });

  /// The active theme.
  final ThemeMode theme;

  /// Selects [theme].
  final void Function(ThemeMode theme) setTheme;

  /// Switches between light and dark themes.
  final void Function() toggleTheme;
}

final ReactContext<ThemeContextValue?> _themeContext = createContext(null);

void _ignoreTheme(ThemeMode _) {}
void _ignoreThemeToggle() {}

// Isolated component tests can render a leaf without reproducing the full
// application shell. The browser entrypoint still always installs the real
// provider boundary.
const _standaloneTheme = ThemeContextValue(
  theme: ThemeMode.dark,
  setTheme: _ignoreTheme,
  toggleTheme: _ignoreThemeToggle,
);

/// Provides the dashboard theme and mirrors it to the document root.
@reactComponent
// ignore: non_constant_identifier_names
ReactNode ThemeProvider(({List<ReactNode> children}) props) {
  final (theme, setThemeState) = useState(ThemeMode.dark);

  useEffect(() {
    try {
      final stored = web.window.localStorage.getItem('theme');
      if (stored == 'light' && theme != ThemeMode.light) {
        setThemeState(ThemeMode.light);
      } else if (stored == 'dark' && theme != ThemeMode.dark) {
        setThemeState(ThemeMode.dark);
      }
    } on Object {
      // SSR exposes the Web API surface but correctly throws for storage.
    }
  }, const []);

  useEffect(() {
    try {
      final root = web.document.documentElement;
      final classList = root?.classList;
      classList?.remove(const ['light', 'dark']);
      classList?.add([theme.name]);
      web.window.localStorage.setItem('theme', theme.name);
    } on Object {
      // The effect is a no-op for SSR and test runtimes without a DOM.
    }
  }, [theme]);

  void setTheme(ThemeMode next) => setThemeState(next);
  void toggleTheme() {
    setThemeState.update(
      (current) => current == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
    );
  }

  return provideContext(
    _themeContext,
    ThemeContextValue(
      theme: theme,
      setTheme: setTheme,
      toggleTheme: toggleTheme,
    ),
    props.children,
  );
}

/// Reads the nearest [ThemeProvider].
ThemeContextValue useTheme() {
  final value = useContext(_themeContext);
  return value ?? _standaloneTheme;
}
