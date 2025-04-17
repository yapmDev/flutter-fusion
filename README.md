# 📦 Flutter Fusion

A lightweight Flutter package that offers a set of **widgets**, **utilities**, and **extensions** to **enhance development efficiency** and **optimize user experience**. **No external dependencies** – fully based on the official Flutter SDK.

---

## ✨ Features

- ✅ Reusable widget set for various common UI elements.
- ✅ Utilities for rapid development (e.g., generating random numbers and colors).
- ✅ Ready-to-use UX enhancements (such as **floating Toast** messages and **StatusBarController**).
- ✅ Handy extensions on native types.
- ✅ Lightweight, fast, and easy to integrate.
- ✅ No external dependencies – everything is built with the Flutter SDK.

---

## 🚀 Installation

Add the package to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter_fusion: latest
```

Then run:

```bash
flutter pub get
```

---

## 🔥 API References

### Toolbox

#### 🎲 Random Number Generation

```dart
int value = randomNumber(10, 100);
```

#### 🎨 Random Color Generation

```dart
Color random = randomColor();
```

### Widgets

#### 🗨️ Show Toast

Displays a fully customizable floating message with an optional action.

```dart
showToast(
  context: context,
  message: 'This is a test message',
  duration: Duration(seconds: 3),
  leadingIcon: Icon(Icons.info),
  actionLabel: 'Undo',
  onAction: () {
    print("Action executed");
  },
);
```

#### 📱 Status Bar Controller

`StatusBarController` allows you to customize the appearance and behavior of the status bar on mobile devices.

```dart
StatusBarController(
  statusBarColorResolver: (isDarkMode) {
    return isDarkMode ? randomColor() : randomColor();
  },
  allowBrightnessContrast: true,
  allowOverlap: false,
  child: YourWidget(),
);
```

#### 📝 Onboarding Screen

The `OnboardingScreen` widget creates an interactive introduction to your app with flip animations between presentation cards.

```dart
List<PresentationData> views = [
  PresentationData(
    'assets/intro_image1.png',
    'Welcome',
    'Discover the most important features of our app.',
  ),
  PresentationData(
    'assets/intro_image2.png',
    'Personalize Your Experience',
    'Adjust settings to your preferences.',
  ),
  // Add more views if needed
];

OnboardingScreen(
  viewData: views,
  navigateTo: const HomeScreen(),
  localizationClassType: GeneratedLocalizationsClass,
);
```

#### 🖥️ KeyboardLayoutBuilder (Reactive Layout for Views with Keyboard)

The `KeyboardLayoutBuilder` widget allows you to create views that respond to the keyboard's visibility and adjusting the UI accordingly.

```dart
KeyboardLayoutBuilder(
  allowOverlap: false,
  backgroundColor: Colors.white,
  builder: (context, isKeyboardVisible) {
    return Column(
      children: [
        TextField(),
        if (!isKeyboardVisible) ...[
          // Additional widgets that should appear when the keyboard is hidden
        ]
      ],
    );
  },
);
```

---

## 🛠️ Contribute

Got new ideas or improvements? We welcome contributions!  
Fork the repo, create a branch, and submit a pull request with the description of your changes.

---

## 📜 License

This package is licensed under the [MIT License](LICENSE).
