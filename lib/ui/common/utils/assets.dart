import '../../../../common/app_images.dart';
import '../../../../core/model/rotation.dart';

extension RotationTypeImage on ChampionRotationType {
  String get imageAsset {
    return switch (this) {
      .regular => AppImages.iconSummonersRift,
      .beginner => AppImages.iconSummonersRiftBeginner,
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
