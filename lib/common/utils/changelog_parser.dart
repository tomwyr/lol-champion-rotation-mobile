import 'package:equatable/equatable.dart';

class ChangelogParser {
  final _blankRegex = RegExp(r'^\s*$');
  final _releaseRegex = RegExp(r'^## \[(\d+\.\d+\.\d+)\] - (\d{4}-\d{2}-\d{2})$');
  final _changeRegex = RegExp(r'^- (.+)$');

  Changelog parse(String input) {
    final changelog = Changelog(releases: []);
    ChangelogRelease? currentRelease;

    for (var line in input.split('\n')) {
      if (_blankRegex.hasMatch(line)) {
        continue;
      } else if (_releaseRegex.firstMatch(line) case var releaseMatch?) {
        final release = _parseRelease(releaseMatch);
        changelog.releases.add(release);
        currentRelease = release;
      } else if (_changeRegex.firstMatch(line) case var changeMatch?) {
        if (currentRelease == null) {
          throw ChangelogParserError.missingReleaseForChange(line);
        }
        final change = _parseChange(changeMatch);
        currentRelease.changes.add(change);
      } else {
        throw ChangelogParserError.unrecognizedLine(line);
      }
    }

    return changelog;
  }

  ChangelogRelease _parseRelease(Match releaseMatch) {
    final version = releaseMatch.group(1);
    final dateString = releaseMatch.group(2);
    final date = dateString != null ? DateTime.tryParse(dateString) : null;
    if (date == null || version == null) {
      throw ChangelogParserError.invalidRelease(releaseMatch.input);
    }
    return ChangelogRelease(version: version, date: date, changes: []);
  }

  String _parseChange(Match changeMatch) {
    final change = changeMatch.group(1);
    if (change == null) {
      throw ChangelogParserError.invalidChange(changeMatch.input);
    }
    return change;
  }
}

class ChangelogParserError implements Exception {
  ChangelogParserError(this.message);

  ChangelogParserError.unrecognizedLine(String text)
    : message = 'Could not parse text in line "$text"';

  ChangelogParserError.missingReleaseForChange(String text)
    : message = 'Found a change without a release in line "$text"';

  ChangelogParserError.invalidRelease(String text)
    : message = 'Invalid release format in line "$text"';

  ChangelogParserError.invalidChange(String text)
    : message = 'Invalid change format in line "$text"';

  final String message;

  @override
  String toString() => 'ChangelogParserError: $message';
}

class Changelog extends Equatable {
  const Changelog({required this.releases});

  final List<ChangelogRelease> releases;

  @override
  List<Object?> get props => [releases];
}

class ChangelogRelease extends Equatable {
  const ChangelogRelease({required this.version, required this.date, required this.changes});

  final String version;
  final DateTime date;
  final List<String> changes;

  @override
  List<Object?> get props => [version, date, changes];
}
