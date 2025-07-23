# Flutter BMI Calculator

A modern, gender-specific BMI (Body Mass Index) calculator built with Flutter. This app provides accurate BMI calculations with different thresholds for males and females, along with personalized health tips based on the calculated BMI category.

## Features

- **Gender-specific BMI calculation**: Different formulas and thresholds for males and females
- **Dynamic UI**: Changes colors and styles based on selected gender (blue for male, pink for female)
- **Smooth animations**: Includes scale, fade, and slide animations for a polished user experience
- **Personalized health tips**: Provides gender-specific health advice based on BMI category
- **Age consideration**: Includes age input for more comprehensive health assessment
- **Reset functionality**: Easily reset all inputs to start a new calculation

## Screenshots

*Screenshots will be added soon*

## How to Use

1. Select your gender (male or female)
2. Adjust the height slider to your height in centimeters
3. Adjust the weight slider to your weight in kilograms
4. Set your age using the age selector
5. Tap the "Calculate BMI" button to see your results
6. View your BMI value, category, and personalized health tip
7. Use the "Reset" button to start over or "Recalculate" to update your BMI

## BMI Categories

### Male
- Underweight: BMI < 18.5
- Normal: BMI 18.5-24.9
- Overweight: BMI 25-29.9
- Obese: BMI ≥ 30

### Female
- Underweight: BMI < 18.5
- Normal: BMI 18.5-23.9
- Overweight: BMI 24-28.9
- Obese: BMI ≥ 29

## Technical Details

- Built with Flutter (latest stable version)
- Uses Material Design principles
- Implements custom animations with AnimationController
- Responsive design that works across different screen sizes
- Uses Google Fonts for typography

## Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone this repository
   ```
   git clone https://github.com/Muhit10/flutter-bmi-calculator.git
   ```

2. Navigate to the project directory
   ```
   cd flutter-bmi-calculator
   ```

3. Get dependencies
   ```
   flutter pub get
   ```

4. Run the app
   ```
   flutter run
   ```

## Dependencies

- google_fonts: ^6.2.1
- cupertino_icons: ^1.0.8

## License

This project is open source and available under the MIT License.

## Acknowledgements

- Flutter team for the amazing framework
- The open-source community for inspiration and resources
