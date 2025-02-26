import '../../../common/app_images.dart';
import '../../../core/model/rotation.dart';

extension RotationTypeImage on ChampionRotationType {
  String get imageAsset {
    return switch (this) {
      ChampionRotationType.regular => AppImages.iconSummonersRift,
      ChampionRotationType.beginner => AppImages.iconSummonersRiftBeginner,
    };
  }

  String get displayName {
    return switch (this) {
      ChampionRotationType.regular => "Summoner's Rift",
      ChampionRotationType.beginner => "Summoner's Rift (Beginners)",
    };
  }

  String get description {
    return switch (this) {
      ChampionRotationType.regular => "Classic map • Weekly rotation",
      ChampionRotationType.beginner => "Classic map • New players only",
    };
  }
}
