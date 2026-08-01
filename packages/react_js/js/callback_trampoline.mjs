globalThis.__dartReactCallbacks ??= {};

globalThis.__dartReactCallbacks.create = function create(reference, dispatch) {
  return function (...args) {
    return dispatch(reference, args);
  };
};

globalThis.__dartReactCallbacks.createPromise = function createPromise(executor) {
  return new Promise(executor);
};

globalThis.__dartReactCallbacks.invoke = function invoke(fn, args) {
  return fn(...args);
};

globalThis.__reactDartForeignComponents ??= {};
globalThis.__reactDartRegisterComponent = function registerComponent(name, component) {
  globalThis.__reactDartForeignComponents[name] = component;
};
globalThis.__reactDartResolveComponent = function resolveComponent(name) {
  return globalThis.__reactDartForeignComponents[name];
};

globalThis.__reactDartGetErrorBoundary = function getErrorBoundary() {
  if (globalThis.__reactDartErrorBoundary) {
    return globalThis.__reactDartErrorBoundary;
  }

  const React = globalThis.React;
  if (!React || !React.Component) {
    throw new Error('React must be loaded before creating an error boundary');
  }

  class DartErrorBoundary extends React.Component {
    constructor(props) {
      super(props);
      this.state = { hasError: false };
    }

    static getDerivedStateFromError() {
      return { hasError: true };
    }

    render() {
      return this.state.hasError ? this.props.fallback : this.props.children;
    }
  }

  globalThis.__reactDartErrorBoundary = DartErrorBoundary;
  return DartErrorBoundary;
};
