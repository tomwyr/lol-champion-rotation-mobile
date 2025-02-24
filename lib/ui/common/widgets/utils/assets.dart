import '../../../../common/app_images.dart';
import '../../../../core/model/rotation.dart';

extension RotationTypeImage on ChampionRotationType {
  String get imageAsset {
    return switch (this) {
      ChampionRotationType.regular => AppImages.iconSummonersRift,
      ChampionRotationType.beginner => AppImages.iconSummonersRiftBeginner,
    };
  }
}
