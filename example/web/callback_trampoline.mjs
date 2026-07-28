globalThis.__dartReactCallbacks ??= {};

globalThis.__dartReactCallbacks.create = function create(reference, dispatch) {
  return function (...args) {
    return dispatch(reference, args);
  };
};

globalThis.__dartReactCallbacks.createPromise = function createPromise(executor) {
  return new Promise(executor);
};

globalThis.__dartReactCallbacks.invoke = function invoke(callback, args) {
  return callback(...args);
};
