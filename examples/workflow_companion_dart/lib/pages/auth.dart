import 'package:react_dom/react_dom.dart';
import 'package:react_web/web.dart' show HTMLInputElement;

import '../components/ui/button.dart';
import '../components/ui/card.dart';
import '../components/ui/input.dart';
import '../components/ui/label.dart';
import '../router.dart' as router;

/// Shared sign-in/sign-up page. The `signUp` prop corresponds to the two
/// separate React route modules in the source application.
@reactComponent
// ignore: non_constant_identifier_names
ReactNode AuthPage(({bool signUp}) props) {
  final navigate = router.useNavigate();
  final (name, setName) = useState('');
  final (email, setEmail) = useState('');
  final (password, setPassword) = useState('');
  final (confirmation, setConfirmation) = useState('');
  final (showPassword, setShowPassword) = useState(false);
  final (loading, setLoading) = useState(false);
  final (notice, setNotice) = useState<String?>(null);

  void submit() {
    if (email.trim().isEmpty || password.isEmpty) {
      setNotice('Please enter your email and password.');
      return;
    }
    if (props.signUp && password != confirmation) {
      setNotice("Passwords don't match.");
      return;
    }
    setLoading(true);
    Future<void>.delayed(const Duration(milliseconds: 500), () {
      setLoading(false);
      setNotice(
        props.signUp ? 'Account created successfully.' : 'Welcome back!',
      );
      navigate('/dashboard', replace: true);
    });
  }

  final requirements = [
    ('At least 8 characters', password.length >= 8),
    ('Contains a number', RegExp(r'\d').hasMatch(password)),
    ('Contains uppercase letter', RegExp('[A-Z]').hasMatch(password)),
  ];

  ReactNode field({
    required String id,
    required String label,
    required String placeholder,
    required String value,
    required void Function(String) onValue,
    String type = 'text',
  }) => div(
    className: 'space-y-2',
    children: [
      uiLabel(text: label, htmlFor: id),
      uiInput(
        id: id,
        type: type,
        value: value,
        placeholder: placeholder,
        required: true,
        onChanged: (event) => onValue((event.target as HTMLInputElement).value),
      ),
    ],
  );

  return div(
    className:
        'flex min-h-screen items-center justify-center bg-background p-4',
    children: [
      div(
        className: 'w-full max-w-md',
        children: [
          div(
            className: 'mb-8 flex items-center justify-center gap-2',
            children: [
              div(
                className: 'flex h-10 w-10 items-center justify-center rounded-lg bg-primary text-primary-foreground',
                children: const [Text('✦')],
              ),
              span(
                className: 'text-2xl font-bold',
                children: const [Text('FlowDash')],
              ),
            ],
          ),
          uiCard(
            children: [
              uiCardHeader(
                children: [
                  uiCardTitle(
                    props.signUp ? 'Create an account' : 'Sign in',
                    className: 'text-center',
                  ),
                  uiCardDescription(
                    props.signUp
                        ? 'Enter your details to get started'
                        : 'Enter your credentials to access your account',
                    className: 'text-center',
                  ),
                ],
              ),
              uiCardContent(
                children: [
                  div(
                    className: 'space-y-4',
                    children: [
                      if (props.signUp)
                        field(
                          id: 'name',
                          label: 'Full name',
                          placeholder: 'John Doe',
                          value: name,
                          onValue: setName.call,
                        ),
                      field(
                        id: 'email',
                        label: 'Email',
                        placeholder: 'name@example.com',
                        type: 'email',
                        value: email,
                        onValue: setEmail.call,
                      ),
                      div(
                        className: 'space-y-2',
                        children: [
                          uiLabel(text: 'Password', htmlFor: 'password'),
                          div(
                            className: 'flex gap-2',
                            children: [
                              uiInput(
                                id: 'password',
                                type: showPassword ? 'text' : 'password',
                                value: password,
                                placeholder: props.signUp
                                    ? 'Create a password'
                                    : 'Enter your password',
                                required: true,
                                onChanged: (event) => setPassword(
                                  (event.target as HTMLInputElement).value,
                                ),
                              ),
                              uiButton(
                                label: showPassword ? 'Hide' : 'Show',
                                variant: UiButtonVariant.ghost,
                                size: UiButtonSize.sm,
                                onPressed: (_) =>
                                    setShowPassword(!showPassword),
                              ),
                            ],
                          ),
                          if (props.signUp)
                            div(
                              className: 'space-y-1 pt-2',
                              children: [
                                for (final requirement in requirements)
                                  div(
                                    className: requirement.$2
                                        ? 'text-xs text-success'
                                        : 'text-xs text-muted-foreground',
                                    children: [
                                      Text(
                                        '${requirement.$2 ? '✓' : '○'} ${requirement.$1}',
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                        ],
                      ),
                      if (props.signUp)
                        field(
                          id: 'confirm-password',
                          label: 'Confirm password',
                          placeholder: 'Confirm your password',
                          type: showPassword ? 'text' : 'password',
                          value: confirmation,
                          onValue: setConfirmation.call,
                        ),
                      if (notice != null)
                        div(
                          className: 'rounded-md bg-destructive/10 p-3 text-sm text-destructive',
                          children: [Text(notice)],
                        ),
                    ],
                  ),
                ],
              ),
              uiCardFooter(
                children: [
                  div(
                    className: 'w-full space-y-4',
                    children: [
                      uiButton(
                        label: loading
                            ? (props.signUp
                                  ? 'Creating account...'
                                  : 'Signing in...')
                            : (props.signUp ? 'Create account' : 'Sign in'),
                        disabled: loading,
                        onPressed: (_) => submit(),
                        className: 'w-full',
                      ),
                      p(
                        className: 'text-center text-sm text-muted-foreground',
                        children: [
                          Text(
                            props.signUp
                                ? 'Already have an account? '
                                : "Don't have an account? ",
                          ),
                          router.navLink(
                            to: props.signUp ? '/signin' : '/signup',
                            className: 'text-primary hover:underline',
                            children: [
                              Text(props.signUp ? 'Sign in' : 'Sign up'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
