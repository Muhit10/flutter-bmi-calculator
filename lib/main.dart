import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

void main() {
  runApp(const BMICalculatorApp());
}

class BMICalculatorApp extends StatelessWidget {
  const BMICalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: GoogleFonts.poppins().fontFamily,
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0A0E21),
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: const BMICalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BMICalculatorScreen extends StatefulWidget {
  const BMICalculatorScreen({Key? key}) : super(key: key);

  @override
  _BMICalculatorScreenState createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen>
    with TickerProviderStateMixin {
  // Default values
  double height = 170.0;
  double weight = 70.0;
  int age = 25;
  bool isMale = true;
  double bmi = 0.0;
  String bmiCategory = '';
  Color bmiColor = Colors.grey;
  bool hasCalculated = false;
  
  // Animation controllers
  late AnimationController _resultAnimationController;
  late AnimationController _genderAnimationController;
  late AnimationController _sliderAnimationController;
  
  // Animations
  late Animation<double> _resultScaleAnimation;
  late Animation<double> _resultFadeAnimation;
  late Animation<double> _genderSlideAnimation;
  late Animation<double> _sliderSlideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Result animations
    _resultAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _resultScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _resultAnimationController,
      curve: Curves.elasticOut,
    ));
    
    _resultFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _resultAnimationController,
      curve: Curves.easeInOut,
    ));
    
    // Gender selector animations
    _genderAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _genderSlideAnimation = Tween<double>(
      begin: -50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _genderAnimationController,
      curve: Curves.easeOut,
    ));
    
    // Slider animations
    _sliderAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _sliderSlideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _sliderAnimationController,
      curve: Curves.easeOut,
    ));
    
    // Start initial animations
    _genderAnimationController.forward();
    _sliderAnimationController.forward();
  }

  @override
  void dispose() {
    _resultAnimationController.dispose();
    _genderAnimationController.dispose();
    _sliderAnimationController.dispose();
    super.dispose();
  }

  // Calculate BMI with gender-specific formulas
  void calculateBMI() {
    setState(() {
      // Standard BMI calculation
      double heightInMeters = height / 100;
      bmi = weight / (heightInMeters * heightInMeters);
      
      // Apply gender-specific adjustments
      if (!isMale) {
        // Female adjustment (women typically have higher body fat %)
        bmi = bmi * 0.95; // Slight adjustment for female BMI
      }
      
      // Determine BMI category and color based on gender
      if (isMale) {
        // Male BMI categories
        if (bmi < 18.5) {
          bmiCategory = 'Underweight';
          bmiColor = Colors.blue;
        } else if (bmi >= 18.5 && bmi < 25) {
          bmiCategory = 'Normal';
          bmiColor = Colors.green;
        } else if (bmi >= 25 && bmi < 30) {
          bmiCategory = 'Overweight';
          bmiColor = Colors.orange;
        } else {
          bmiCategory = 'Obese';
          bmiColor = Colors.red;
        }
      } else {
        // Female BMI categories (slightly different thresholds)
        if (bmi < 18.5) {
          bmiCategory = 'Underweight';
          bmiColor = Colors.blue;
        } else if (bmi >= 18.5 && bmi < 24) {
          bmiCategory = 'Normal';
          bmiColor = Colors.green;
        } else if (bmi >= 24 && bmi < 29) {
          bmiCategory = 'Overweight';
          bmiColor = Colors.orange;
        } else {
          bmiCategory = 'Obese';
          bmiColor = Colors.red;
        }
      }
      
      hasCalculated = true;
    });
    
    // Trigger result animation
    _resultAnimationController.reset();
    _resultAnimationController.forward();
  }
  
  // Reset all values
  void resetCalculator() {
    setState(() {
      height = 170.0;
      weight = 70.0;
      age = 25;
      bmi = 0.0;
      bmiCategory = '';
      bmiColor = Colors.grey;
      hasCalculated = false;
    });
  }

  Widget _buildGenderSelector() {
    return AnimatedBuilder(
      animation: _genderAnimationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_genderSlideAnimation.value, 0),
          child: Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Select Gender',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildGenderCard(true),
                    _buildGenderCard(false),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGenderCard(bool male) {
    bool isSelected = male ? isMale : !isMale;
    Color activeColor = male ? Colors.blue : Colors.pink;
    
    return GestureDetector(
      onTap: () => setState(() => isMale = male),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? activeColor : Colors.grey.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                male ? Icons.male : Icons.female,
                size: isSelected ? 55 : 50,
                color: isSelected ? activeColor : Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              male ? 'Male' : 'Female',
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? activeColor : Colors.grey,
              ),
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 5),
                height: 3,
                width: 30,
                decoration: BoxDecoration(
                  color: activeColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderCard(String title, double value, String unit, 
      double min, double max, ValueChanged<double> onChanged) {
    return AnimatedBuilder(
      animation: _sliderAnimationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_sliderSlideAnimation.value, 0),
          child: Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${value.toInt()} $unit',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isMale ? Colors.blue : Colors.pink,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: isMale ? Colors.blue : Colors.pink,
                    inactiveTrackColor: (isMale ? Colors.blue : Colors.pink).withOpacity(0.3),
                    thumbColor: isMale ? Colors.blue : Colors.pink,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                    overlayColor: (isMale ? Colors.blue : Colors.pink).withOpacity(0.2),
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
        );
      },
    );
  }

  Widget _buildAgeSelector() {
    return AnimatedBuilder(
      animation: _sliderAnimationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_sliderSlideAnimation.value, 0),
          child: Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Age',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCircularButton(
                      icon: Icons.remove,
                      onPressed: () {
                        if (age > 1) {
                          setState(() => age--);
                        }
                      },
                    ),
                    const SizedBox(width: 20),
                    Text(
                      '$age',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: isMale ? Colors.blue : Colors.pink,
                      ),
                    ),
                    const SizedBox(width: 20),
                    _buildCircularButton(
                      icon: Icons.add,
                      onPressed: () {
                        if (age < 120) {
                          setState(() => age++);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCircularButton({required IconData icon, required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: (isMale ? Colors.blue : Colors.pink).withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isMale ? Colors.blue : Colors.pink,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return AnimatedBuilder(
      animation: _sliderAnimationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_sliderSlideAnimation.value, 0),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                if (hasCalculated)
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: ElevatedButton(
                        onPressed: resetCalculator,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 3,
                        ),
                        child: const Text(
                          'Reset',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  flex: hasCalculated ? 2 : 1,
                  child: ElevatedButton(
                    onPressed: calculateBMI,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isMale ? Colors.blue : Colors.pink,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      hasCalculated ? 'Recalculate' : 'Calculate BMI',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildResultCard() {
    if (!hasCalculated) return const SizedBox.shrink();
    
    return AnimatedBuilder(
      animation: _resultAnimationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _resultScaleAnimation.value,
          child: Opacity(
            opacity: _resultFadeAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(30),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: bmiColor.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
                border: Border.all(
                  color: bmiColor.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isMale ? Icons.male : Icons.female,
                        color: isMale ? Colors.blue : Colors.pink,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Your BMI Result',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: bmi),
                    duration: const Duration(milliseconds: 1000),
                    builder: (context, value, child) {
                      return Text(
                        value.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: bmiColor,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: bmiColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      bmiCategory,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: bmiColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildHealthTip(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHealthTip() {
    String tip = '';
    
    if (isMale) {
      // Male-specific health tips
      switch (bmiCategory) {
        case 'Underweight':
          tip = 'Focus on strength training and protein-rich diet to build muscle mass. Consult a nutritionist.';
          break;
        case 'Normal':
          tip = 'Excellent! Maintain with regular exercise and balanced nutrition. Aim for 150 min/week cardio.';
          break;
        case 'Overweight':
          tip = 'Combine cardio with weight training. Reduce portion sizes and limit processed foods.';
          break;
        case 'Obese':
          tip = 'Consult a healthcare provider. Start with low-impact exercises and gradual dietary changes.';
          break;
      }
    } else {
      // Female-specific health tips
      switch (bmiCategory) {
        case 'Underweight':
          tip = 'Focus on healthy weight gain with nutrient-dense foods. Consider calcium and iron supplements.';
          break;
        case 'Normal':
          tip = 'Perfect! Maintain with yoga, pilates, or cardio. Ensure adequate calcium and vitamin D intake.';
          break;
        case 'Overweight':
          tip = 'Try combination of cardio and strength training. Focus on whole foods and portion control.';
          break;
        case 'Obese':
          tip = 'Seek professional guidance. Start with gentle exercises like walking and swimming.';
          break;
        default:
          tip = 'Maintain a healthy lifestyle with balanced diet and regular exercise.';
      }
    }
    
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isMale ? Colors.blue.withOpacity(0.3) : Colors.pink.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                isMale ? Icons.medical_services : Icons.favorite,
                color: isMale ? Colors.blue : Colors.pink,
                size: 16,
              ),
              const SizedBox(width: 5),
              Text(
                'Health Tip',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isMale ? Colors.blue : Colors.pink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            tip,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BMI Calculator',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: isMale ? Colors.blue : Colors.pink,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildGenderSelector(),
            _buildSliderCard(
              'Height',
              height,
              'cm',
              100,
              220,
              (value) => setState(() => height = value),
            ),
            _buildSliderCard(
              'Weight',
              weight,
              'kg',
              30,
              150,
              (value) => setState(() => weight = value),
            ),
            _buildAgeSelector(),
            _buildActionButtons(),
            _buildResultCard(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}