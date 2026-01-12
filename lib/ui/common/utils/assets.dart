import '../../../../core/model/rotation.dart';
import '../../../common/app_assets.dart';

extension RotationTypeImage on ChampionRotationType {
  String get imageAsset {
    return switch (this) {
      .regular => AppAssets.iconSummonersRift,
      .beginner => AppAssets.iconSummonersRiftBeginner,
    };
  }

  String get displayName {
    return switch (this) {
      .regular => "Summoner's Rift",
      .beginner => "Summoner's Rift (Beginners)",
    };
  }

  String get description {
    return switch (this) {
      .regular => "Classic map • Weekly rotation",
      .beginner => "Classic map • New players only",
    };
  }
}
