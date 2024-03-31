final: prev: {
  diegofariasm-hello = prev.hello.overrideAttrs (old: {
    separateDebugInfo = true;
  });
}
