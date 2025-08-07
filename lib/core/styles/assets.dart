class Assets {
  ///
  /// Local Assets
  ///
  static const _basePath = 'assets';
  static const _logo = '$_basePath/logo.png';
  static const _google = '$_basePath/google.png';
  static const _background = '$_basePath/background.jpg';

  static String get logo => _logo;
  static String get google => _google;
  static String get background => _background;

  ///
  /// Network Assets
  ///
  static String buildPokemonSpriteUrl(int index) =>
      'https://unpkg.com/pokeapi-sprites@2.0.2/sprites/pokemon/other/dream-world/$index.svg';
}
