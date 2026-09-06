import 'package:react_dom/react_dom.dart';

import '../../utils.dart';
import 'button.dart';

/// State passed to a portable carousel.
final class UiCarouselState {
  /// Creates a carousel state.
  const UiCarouselState({required this.index, required this.itemCount});

  final int index;
  final int itemCount;

  bool get canGoPrevious => index > 0;
  bool get canGoNext => index < itemCount - 1;
}

/// A semantic carousel viewport. Pages own the index, which keeps the API
/// deterministic during SSR and straightforward to test on the VM.
ReactNode uiCarousel({
  required UiCarouselState state,
  required ReactChildren children,
  required void Function(int index) onIndexChanged,
  String orientation = 'horizontal',
  String? className,
}) => div(
  className: cn(['relative', className]),
  role: 'region',
  additionalProps: {
    'aria-roledescription': 'carousel',
    'aria-label': 'Carousel',
    'data-orientation': orientation,
  },
  children: [
    div(
      className: 'overflow-hidden',
      children: [
        div(
          className: orientation == 'horizontal' ? 'flex' : 'flex flex-col',
          children: children,
        ),
      ],
    ),
    uiCarouselPrevious(
      enabled: state.canGoPrevious,
      onPressed: () => onIndexChanged(state.index - 1),
    ),
    uiCarouselNext(
      enabled: state.canGoNext,
      onPressed: () => onIndexChanged(state.index + 1),
    ),
  ],
);

/// A carousel item with the same group semantics as the reference primitive.
ReactNode uiCarouselItem({
  required int index,
  required int activeIndex,
  required ReactChildren children,
  String? className,
}) => div(
  className: cn([
    'min-w-0 shrink-0 grow-0 basis-full',
    index == activeIndex ? null : 'hidden',
    className,
  ]),
  role: 'group',
  additionalProps: {
    'aria-roledescription': 'slide',
    'aria-label': '${index + 1}',
  },
  children: children,
);

/// Previous navigation for [uiCarousel].
ReactNode uiCarouselPrevious({
  required bool enabled,
  required void Function() onPressed,
}) => uiButton(
  label: '←',
  variant: UiButtonVariant.outline,
  size: UiButtonSize.icon,
  disabled: !enabled,
  className: 'absolute left-2 top-1/2 -translate-y-1/2 rounded-full',
  onPressed: enabled ? (_) => onPressed() : null,
);

/// Next navigation for [uiCarousel].
ReactNode uiCarouselNext({
  required bool enabled,
  required void Function() onPressed,
}) => uiButton(
  label: '→',
  variant: UiButtonVariant.outline,
  size: UiButtonSize.icon,
  disabled: !enabled,
  className: 'absolute right-2 top-1/2 -translate-y-1/2 rounded-full',
  onPressed: enabled ? (_) => onPressed() : null,
);
