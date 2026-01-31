import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:ebisu/core/configuration/string_constants.dart';
import 'package:ebisu/core/configuration/numeric_constants.dart';
import 'package:ebisu/core/configuration/route_constants.dart';
import 'package:ebisu/features/onboarding/providers/onboarding_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      final success = await ref
          .read(onboardingControllerProvider.notifier)
          .completeOnboarding(_nameController.text.trim());

      if (success && mounted) {
        context.go(RouteConstants.pathHome);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(NumericConstants.paddingExtraLarge),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.auto_awesome_rounded,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                )
                    .animate()
                    .fadeIn(duration: const Duration(milliseconds: 600))
                    .scale(
                      begin: const Offset(0.5, 0.5),
                      end: const Offset(1.0, 1.0),
                      curve: Curves.elasticOut,
                      duration: const Duration(milliseconds: 800),
                    ),
                const SizedBox(height: NumericConstants.paddingLarge),
                Text(
                  StringConstants.onboardingWelcomeTitle,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 200))
                    .slideY(begin: 0.3, end: 0),
                const SizedBox(height: NumericConstants.paddingSmall),
                Text(
                  StringConstants.onboardingWelcomeSubtitle,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                  textAlign: TextAlign.center,
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 400))
                    .slideY(begin: 0.3, end: 0),
                const SizedBox(height: NumericConstants.paddingExtraLarge * 2),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        StringConstants.onboardingNamePrompt,
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      )
                          .animate()
                          .fadeIn(delay: const Duration(milliseconds: 600)),
                      const SizedBox(height: NumericConstants.paddingMedium),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          hintText: StringConstants.onboardingNameHint,
                          prefixIcon: Icon(Icons.person_rounded),
                        ),
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _onSubmit(),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return StringConstants.onboardingNameValidation;
                          }
                          if (value.trim().length < NumericConstants.nameMinLength) {
                            return StringConstants.onboardingNameTooShort;
                          }
                          if (value.trim().length > NumericConstants.nameMaxLength) {
                            return StringConstants.onboardingNameTooLong;
                          }
                          return null;
                        },
                      )
                          .animate()
                          .fadeIn(delay: const Duration(milliseconds: 700))
                          .slideY(begin: 0.2, end: 0),
                      const SizedBox(height: NumericConstants.paddingLarge),
                      if (state.error != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: NumericConstants.paddingMedium),
                          child: Text(
                            state.error!,
                            style: TextStyle(color: Theme.of(context).colorScheme.error),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: state.isLoading ? null : _onSubmit,
                          child: state.isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  StringConstants.onboardingStartButton,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      )
                          .animate()
                          .fadeIn(delay: const Duration(milliseconds: 800))
                          .slideY(begin: 0.2, end: 0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
