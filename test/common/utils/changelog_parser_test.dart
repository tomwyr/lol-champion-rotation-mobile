import 'package:flutter_test/flutter_test.dart';
import 'package:lol_champion_rotation/common/utils/changelog_parser.dart';

void main() {
  final parser = ChangelogParser();

  test('single release', () {
    final input = """
## [0.0.1] - 2026-01-12

- First change
- Second change
""";

    final expected = Changelog(
      releases: [
        ChangelogRelease(
          version: '0.0.1',
          date: DateTime(2026, 1, 12),
          changes: ['First change', 'Second change'],
        ),
      ],
    );

    expect(parser.parse(input), expected);
  });

  test('single release without changes', () {
    final input = """
## [0.0.1] - 2026-01-12

""";

    final expected = Changelog(
      releases: [ChangelogRelease(version: '0.0.1', date: DateTime(2026, 1, 12), changes: [ ],
        )],
    );

    expect(parser.parse(input), expected);
  });

  test('multiple releases', () {
    final input = """
## [1.0.0] - 2026-05-16

- Added new feature
- Improved performance
- Removed tech debt

## [0.1.0] - 2026-02-01

- Fixed a few bugs

## [0.0.1] - 2026-01-12

- First change
- Second change
""";

    final expected = Changelog(
      releases: [
        ChangelogRelease(
          version: '1.0.0',
          date: DateTime(2026, 5, 16),
          changes: ['Added new feature', 'Improved performance', 'Removed tech debt'],
        ),
        ChangelogRelease(
          version: '0.1.0',
          date: DateTime(2026, 2, 1),
          changes: ['Fixed a few bugs'],
        ),
        ChangelogRelease(
          version: '0.0.1',
          date: DateTime(2026, 1, 12),
          changes: ['First change', 'Second change'],
        ),
      ],
    );

    expect(parser.parse(input), expected);
  });

  test('multiple releases with release with no changes', () {
    final input = """
## [1.0.0] - 2026-05-16

- Added new feature
- Improved performance
- Removed tech debt

## [0.1.0] - 2026-02-01

## [0.0.1] - 2026-01-12

- First change
- Second change
""";

    final expected = Changelog(
      releases: [
        ChangelogRelease(
          version: '1.0.0',
          date: DateTime(2026, 5, 16),
          changes: ['Added new feature', 'Improved performance', 'Removed tech debt'],
        ),
        ChangelogRelease(version: '0.1.0', date: DateTime(2026, 2, 1), changes: []),
        ChangelogRelease(
          version: '0.0.1',
          date: DateTime(2026, 1, 12),
          changes: ['First change', 'Second change'],
        ),
      ],
    );

    expect(parser.parse(input), expected);
  });

  test('invalid version format', () {
    final input = """
## [1.0] - 2026-05-16

- Added new feature
- Improved performance
- Removed tech debt

## [0.1.0] - 2026-02-01

- Fixed a few bugs

## [0.0.1] - 2026-01-12

- First change
- Second change
""";

    expect(() => parser.parse(input), throwsA(isA<ChangelogParserError>()));
  });

  test('invalid date format', () {
    final input = """
## [1.0.0] - 2026/05/16

- Added new feature
- Improved performance
- Removed tech debt

## [0.1.0] - 2026-02-01

- Fixed a few bugs

## [0.0.1] - 2026-01-12

- First change
- Second change
""";

    expect(() => parser.parse(input), throwsA(isA<ChangelogParserError>()));
  });

  test('invalid change format', () {
    final input = """
## [1.0.0] - 2026-05-16

* Added new feature
- Improved performance
- Removed tech debt

## [0.1.0] - 2026-02-01

- Fixed a few bugs

## [0.0.1] - 2026-01-12

- First change
- Second change
""";

    expect(() => parser.parse(input), throwsA(isA<ChangelogParserError>()));
  });
}
