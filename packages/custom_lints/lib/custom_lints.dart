import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

PluginBase createPlugin() => _CustomLintsPlugin();

class _CustomLintsPlugin extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        const _AvoidHardcodedTrKeys(),
      ];
}

class _AvoidHardcodedTrKeys extends DartLintRule {
  const _AvoidHardcodedTrKeys()
      : super(
          code: const LintCode(
            name: 'avoid_hardcoded_tr_keys',
            problemMessage:
                'Avoid hardcoded translation keys. Move this to AppStrings.',
            correctionMessage:
                'Use AppStrings.yourKey.tr() instead of "your.key".tr()',
          ),
        );

  @override
  void run(
      CustomLintResolver resolver,
      ErrorReporter reporter,
      CustomLintContext context,
      ) {    context.registry.addMethodInvocation((node) {
      if (node.methodName.name != 'tr') return;
      final target = node.target;
      if (target is StringLiteral) {
        reporter.atNode(target, code);
      }
    });
  }
}
