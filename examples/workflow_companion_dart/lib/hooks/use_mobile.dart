import 'package:react_core/react.dart';
import 'package:react_web/web.dart' as web;

/// Breakpoint used by the reference dashboard.
const mobileBreakpoint = 768;

/// Tracks whether the browser viewport is narrower than [mobileBreakpoint].
///
/// The Web API access lives inside an effect, so SSR still renders a stable
/// desktop-shaped tree and the browser updates it after hydration.
bool useIsMobile() {
  final (isMobile, setIsMobile) = useState(false);

  useEffect(() {
    try {
      Object update(web.Event _) {
        setIsMobile(web.window.innerWidth < mobileBreakpoint);
        return true;
      }

      update(web.Event('resize'));
      final previous = web.window.onresize;
      web.window.onresize = update;
      return () => web.window.onresize = previous;
    } on Object {
      return null;
    }
  }, const []);

  return isMobile;
}
