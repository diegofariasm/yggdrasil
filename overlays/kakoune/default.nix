(self: super: {
  kakoune = super.wrapKakoune self.kakoune-unwrapped {
    configure = {
      plugins = with self.kakounePlugins; [
        parinfer-rust
      ];
    };
  };
})
