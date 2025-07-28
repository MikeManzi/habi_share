import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(totalSteps, (index) {
            final isActive = index <= currentStep;
            final isCompleted = index < currentStep;

            return Expanded(
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          isActive ? const Color(0xFF8A2851) : Colors.grey[300],
                    ),
                    child:
                        isCompleted
                            ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 18,
                            )
                            : isActive
                            ? const Icon(
                              Icons.directions_bike,
                              color: Colors.white,
                              size: 18,
                            )
                            : null,
                  ),
                  if (index < totalSteps - 1)
                    Expanded(
                      child: Container(
                        height: 3,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color:
                              isCompleted
                                  ? const Color(0xFF8A2851)
                                  : Colors.grey[300],
                          borderRadius: BorderRadius.circular(1.5),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
