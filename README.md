# HCD Flutter Package

HCD Flutter is a proprietary Flutter package that provides a collection of utility classes, extensions, and widgets to streamline Flutter development.

## Features

- **Utility Classes**: AppLogger, DialogUtils, and more.
- **Extensions**: String, DateTime, Color, Number, and Iterable extensions.
- **Widgets**: Multi-stream BLoC widgets and more.
- **Models**: Base model and example model with Freezed integration.
- **Localization**: AppLocalizations for easy internationalization.

## Important Notice

This package is proprietary and not licensed for public use. It is intended for internal use only within authorized projects.

## Installation

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  hcd:
    git:
      url: https://github.com/hafencity-dev/hcd-flutter.git
      ref: main # or specify a tag/commit
```

Then run:

```
flutter pub get
```

## Usage

```dart
import 'package:hcd/hcd.dart';
```

### Examples

1. Using AppLogger:

```dart
await AppLogger.initialize();
AppLogger.info('This is an info message');
```

2. Using String extensions:

```dart
String text = 'hello world';
print(text.capitalize()); // Output: Hello world
```

3. Using Color extensions:

```dart
Color color = Colors.blue;
Color lighterBlue = color.lighten();
```

4. Using DateTime extensions:

```dart
DateTime now = DateTime.now();
print(now.format(format: 'dd/MM/yyyy'));
```

## No License

This package is not licensed for public use. All rights are reserved.
