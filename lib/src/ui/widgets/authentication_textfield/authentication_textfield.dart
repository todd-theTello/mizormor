import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mizormor/utils/extensions/padding.dart';

///
class AuthenticationTextField extends StatelessWidget {
  ///
  const AuthenticationTextField({
    required String labelText,
    required TextEditingController controller,
    required ValueNotifier<bool> validator,
    required String errorText,
    required ThemeData theme,
    void Function(String)? onFieldSubmitted,
    void Function(String)? onChanged,
    TextInputAction? textInputAction,
    this.keyboardType,
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    List<TextInputFormatter>? inputFormatters,
    bool? obscureText,
    super.key,
  })  : _labelText = labelText,
        _obscureText = obscureText ?? false,
        _hintText = hintText,
        _controller = controller,
        _validator = validator,
        _onFieldSubmitted = onFieldSubmitted,
        _onChanged = onChanged,
        _textInputAction = textInputAction,
        _errorText = errorText,
        _theme = theme,
        _prefixIcon = prefixIcon,
        _suffixIcon = suffixIcon,
        _inputFormatters = inputFormatters;
  final String _labelText;
  final TextEditingController _controller;
  final ValueNotifier<bool> _validator;
  final void Function(String)? _onFieldSubmitted;
  final void Function(String)? _onChanged;
  final TextInputAction? _textInputAction;
  final TextInputType? keyboardType;
  final String _errorText;
  final String? _hintText;
  final ThemeData _theme;
  final Widget? _prefixIcon;
  final Widget? _suffixIcon;
  final List<TextInputFormatter>? _inputFormatters;
  final bool _obscureText;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _validator,
        builder: (context, isValid, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _labelText,
                style: _theme.textTheme.bodyLarge?.copyWith(
                  color: isValid ? _theme.colorScheme.tertiary : _theme.colorScheme.error,
                ),
              ).paddingOnly(bottom: 4),
              TextFormField(
                onChanged: _onChanged,
                autocorrect: false,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                style: _theme.textTheme.bodyLarge,
                controller: _controller,
                onFieldSubmitted: _onFieldSubmitted,
                obscureText: _obscureText,
                keyboardType: keyboardType,
                textInputAction: _textInputAction ?? TextInputAction.next,
                inputFormatters: _inputFormatters,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  prefixIcon: _prefixIcon,
                  suffixIcon: _suffixIcon,
                  hintText: _hintText,
                  enabledBorder: isValid
                      ? null
                      : OutlineInputBorder(
                          borderSide: BorderSide(color: _theme.colorScheme.error),
                          borderRadius: BorderRadius.circular(8),
                        ),
                  focusedBorder: isValid
                      ? null
                      : OutlineInputBorder(
                          borderSide: BorderSide(color: _theme.colorScheme.error),
                          borderRadius: BorderRadius.circular(8),
                        ),
                ),
              ),
              Visibility(
                visible: !isValid,
                child: Text(
                  _errorText,
                  style: _theme.textTheme.bodyMedium?.copyWith(
                    color: _theme.colorScheme.error,
                  ),
                ),
              )
            ],
          );
        });
  }
}
