import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const BMICalculatorApp());
}

class BMICalculatorApp extends StatelessWidget {
  const BMICalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData(brightness: Brightness.dark).textTheme,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const BMICalculatorScreen(),
    );
  }
}

class BMICalculatorScreen extends StatefulWidget {
  const BMICalculatorScreen({super.key});

  @override
  State<BMICalculatorScreen> createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen>
    with TickerProviderStateMixin {
  // State variables
  double height = 170.0;
  double weight = 70.0;
  int age = 25;
  bool isMale = true;
  double bmi = 0.0;
  String category = '';
  Color color = Colors.grey;
  bool hasCalculated = false;

  // Animation controllers
  late AnimationController _resultController;
  late AnimationController _maleController;
  late AnimationController _femaleController;
  late AnimationController _sliderController;

  // Animations
  late Animation<double> _resultAnimation;
  late Animation<double> _maleAnimation;
  late Animation<double> _femaleAnimation;
  late Animation<double> _sliderAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _resultController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _maleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _femaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _sliderController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Initialize animations
    _resultAnimation = CurvedAnimation(
      parent: _resultController,
      curve: Curves.easeInOut,
    );

    _maleAnimation = CurvedAnimation(
      parent: _maleController,
      curve: Curves.easeInOut,
    );

    _femaleAnimation = CurvedAnimation(
      parent: _femaleController,
      curve: Curves.easeInOut,
    );

    _sliderAnimation = CurvedAnimation(
      parent: _sliderController,
      curve: Curves.easeInOut,
    );

    // Set initial animation states
    if (isMale) {
      _maleController.value = 1.0;
    } else {
      _femaleController.value = 1.0;
    }

    _sliderController.forward();
  }

  @override
  void dispose() {
    _resultController.dispose();
    _maleController.dispose();
    _femaleController.dispose();
    _sliderController.dispose();
    super.dispose();
  }

  // Calculate BMI with gender-specific adjustments
  void calculateBMI() {
    setState(() {
      // Calculate raw BMI
      bmi = weight / ((height / 100) * (height / 100));
      
      // Apply gender-specific adjustment
      if (!isMale) {
        // Women typically have higher body fat percentage
        // Adjust BMI calculation for females
        bmi = bmi * 0.95;
      }

      // Determine BMI category and color based on gender
      if (isMale) {
        // Male BMI categories
        if (bmi < 18.5) {
          category = 'Underweight';
          color = Colors.blue;
        } else if (bmi >= 18.5 && bmi < 25) {
          category = 'Normal';
          color = Colors.green;
        } else if (bmi >= 25 && bmi < 30) {
          category = 'Overweight';
          color = Colors.orange;
        } else {
          category = 'Obese';
          color = Colors.red;
        }
      } else {
        // Female BMI categories (slightly different thresholds)
        if (bmi < 18) {
          category = 'Underweight';
          color = Colors.blue;
        } else if (bmi >= 18 && bmi < 24) {
          category = 'Normal';
          color = Colors.green;
        } else if (bmi >= 24 && bmi < 29) {
          category = 'Overweight';
          color = Colors.orange;
        } else {
          category = 'Obese';
          color = Colors.red;
        }
      }

      hasCalculated = true;
      _resultController.forward(from: 0.0);
    });
  }

  // Reset calculator
  void resetCalculator() {
    setState(() {
      height = 170.0;
      weight = 70.0;
      age = 25;
      // Keep the gender selection
      bmi = 0.0;
      category = '';
      color = Colors.grey;
      hasCalculated = false;
      _resultController.reverse();
      _sliderController.forward(from: 0.0);
    });
  }

  // Build gender selector
  Widget _buildGenderSelector() {
    return Row(
      children: [
        Expanded(
          child: _buildGenderCard(
            icon: Icons.male,
            label: 'Male',
            isSelected: isMale,
            animation: _maleAnimation,
            onTap: () {
              if (!isMale) {
                setState(() {
                  isMale = true;
                  _maleController.forward();
                  _femaleController.reverse();
                });
              }
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildGenderCard(
            icon: Icons.female,
            label: 'Female',
            isSelected: !isMale,
            animation: _femaleAnimation,
            onTap: () {
              if (isMale) {
                setState(() {
                  isMale = false;
                  _femaleController.forward();
                  _maleController.reverse();
                });
              }
            },
          ),
        ),
      ],
    );
  }

  // Build gender card
  Widget _buildGenderCard({
    required IconData icon,
    required String label,
    required bool isSelected,
    required Animation<double> animation,
    required VoidCallback onTap,
  }) {
    final color = isSelected
        ? (isMale ? Colors.blue.shade100 : Colors.pink.shade100)
        : Colors.grey.shade200;
    final iconColor = isSelected
        ? (isMale ? Colors.blue : Colors.pink)
        : Colors.grey;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color.lerp(
                Colors.grey.shade200,
                color,
                animation.value,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 80 * (0.8 + (animation.value * 0.2)),
                  color: Color.lerp(
                    Colors.grey,
                    iconColor,
                    animation.value,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.lerp(
                      Colors.grey,
                      iconColor,
                      animation.value,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Build slider card for height and weight
  Widget _buildSliderCard({
    required String label,
    required String unit,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
    required String displayValue,
  }) {
    final primaryColor = isMale ? Colors.blue : Colors.pink;

    return FadeTransition(
      opacity: _sliderAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(_sliderAnimation),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    displayValue,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    unit,
                    style: TextStyle(
                      fontSize: 16,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: primaryColor,
                  inactiveTrackColor: primaryColor.withOpacity(0.2),
                  thumbColor: primaryColor,
                  overlayColor: primaryColor.withOpacity(0.2),
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
                ),
                child: Slider(
                  value: value,
                  min: min,
                  max: max,
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build age selector
  Widget _buildAgeSelector() {
    final primaryColor = isMale ? Colors.blue : Colors.pink;

    return FadeTransition(
      opacity: _sliderAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(_sliderAnimation),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                'Age',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                age.toString(),
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCircularButton(
                    icon: Icons.remove,
                    onPressed: () {
                      setState(() {
                        if (age > 1) age--;
                      });
                    },
                  ),
                  const SizedBox(width: 16),
                  _buildCircularButton(
                    icon: Icons.add,
                    onPressed: () {
                      setState(() {
                        if (age < 120) age++;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build circular button
  Widget _buildCircularButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    final primaryColor = isMale ? Colors.blue : Colors.pink;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: primaryColor,
        ),
      ),
    );
  }

  // Build action buttons (Calculate/Recalculate and Reset)
  Widget _buildActionButtons() {
    final primaryColor = isMale ? Colors.blue : Colors.pink;

    return FadeTransition(
      opacity: _sliderAnimation,
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: calculateBMI,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                hasCalculated ? 'Recalculate' : 'Calculate BMI',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (hasCalculated) ...[  
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: resetCalculator,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Reset',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Build result card
  Widget _buildResultCard() {
    return FadeTransition(
      opacity: _resultAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(_resultAnimation),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                'Your BMI Result',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isMale ? Icons.male : Icons.female,
                    size: 40,
                    color: color,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0, end: bmi),
                        duration: const Duration(milliseconds: 1500),
                        builder: (context, value, child) {
                          return Text(
                            value.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          );
                        },
                      ),
                      Text(
                        category,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildHealthTip(),
            ],
          ),
        ),
      ),
    );
  }

  // Build health tip based on BMI category and gender
  Widget _buildHealthTip() {
    String tip = '';
    IconData tipIcon = Icons.info_outline;

    if (category == 'Underweight') {
      tipIcon = Icons.restaurant;
      if (isMale) {
        tip =
            'Consider increasing your caloric intake with protein-rich foods like lean meats, eggs, and nuts. Strength training can help build muscle mass.';
      } else {
        tip =
            'Focus on nutrient-dense foods and healthy fats. Consider consulting with a nutritionist about a balanced diet plan that supports weight gain while maintaining hormonal balance.';
      }
    } else if (category == 'Normal') {
      tipIcon = Icons.check_circle_outline;
      if (isMale) {
        tip =
            'Maintain your healthy weight with regular exercise and a balanced diet. Focus on strength training and cardio for overall fitness.';
      } else {
        tip =
            'Continue your balanced lifestyle with regular exercise and nutritious meals. Include calcium-rich foods and consider weight-bearing exercises for bone health.';
      }
    } else if (category == 'Overweight') {
      tipIcon = Icons.directions_run;
      if (isMale) {
        tip =
            'Incorporate more cardio and strength training into your routine. Reduce processed foods and increase protein intake to support muscle development.';
      } else {
        tip =
            'Consider a combination of cardio, strength training, and flexibility exercises. Focus on whole foods and be mindful of portion sizes.';
      }
    } else if (category == 'Obese') {
      tipIcon = Icons.medical_services_outlined;
      if (isMale) {
        tip =
            'Consider consulting with a healthcare provider about a weight management plan. Focus on sustainable lifestyle changes rather than quick fixes.';
      } else {
        tip =
            'Speak with a healthcare provider about a personalized weight management approach. Small, consistent changes to diet and activity levels can lead to significant improvements.';
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          tipIcon,
          color: color,
          size: 24,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            tip,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = isMale ? Colors.blue : Colors.pink;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Calculator'),
        backgroundColor: primaryColor.withOpacity(0.1),
        foregroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGenderSelector(),
            const SizedBox(height: 24),
            _buildSliderCard(
              label: 'Height',
              unit: 'cm',
              value: height,
              min: 100,
              max: 220,
              onChanged: (value) {
                setState(() {
                  height = value;
                });
              },
              displayValue: height.toStringAsFixed(0),
            ),
            const SizedBox(height: 16),
            _buildSliderCard(
              label: 'Weight',
              unit: 'kg',
              value: weight,
              min: 30,
              max: 150,
              onChanged: (value) {
                setState(() {
                  weight = value;
                });
              },
              displayValue: weight.toStringAsFixed(0),
            ),
            const SizedBox(height: 16),
            _buildAgeSelector(),
            const SizedBox(height: 24),
            _buildActionButtons(),
            if (hasCalculated) ...[  
              const SizedBox(height: 24),
              _buildResultCard(),
            ],
          ],
        ),
      ),
    );
  }
}
