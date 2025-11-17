import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class PracticeTimerDialog extends StatefulWidget {
  final int durationInMinutes;
  final String practiceTitle;

  const PracticeTimerDialog({
    super.key,
    required this.durationInMinutes,
    required this.practiceTitle,
  });

  @override
  State<PracticeTimerDialog> createState() => _PracticeTimerDialogState();
}

class _PracticeTimerDialogState extends State<PracticeTimerDialog> {
  late int _remainingSeconds;
  Timer? _timer;
  bool _isPaused = false;
  bool _isCountdown = true;
  int _countdownSeconds = 5;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdownSeconds > 0) {
          _countdownSeconds--;
        } else {
          _isCountdown = false;
          _remainingSeconds = widget.durationInMinutes * 60;
          timer.cancel();
          _startTimer();
        }
      });
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
          } else {
            timer.cancel();
            _showCompletionDialog();
          }
        });
      }
    });
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _finishSession() {
    _timer?.cancel();
    Navigator.of(context).pop();
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Parabéns!',
          style: AppTypography.heading1Primary,
          textAlign: TextAlign.center,
        ),
        content: Text(
          'Você completou a sessão de ${widget.practiceTitle}!',
          style: AppTypography.textPrimary.copyWith(
            color: AppColors.textDisabled,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close completion dialog
                Navigator.of(context).pop(); // Close timer dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Concluir',
                style: AppTypography.textPrimary.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isCountdown) {
      return Dialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Prepare-se!',
                style: AppTypography.heading1Primary.copyWith(
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Text(
                _countdownSeconds.toString(),
                style: AppTypography.heading1Primary.copyWith(
                  fontSize: 72,
                  color: AppColors.buttonPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'A sessão começará em breve',
                style: AppTypography.textPrimary.copyWith(
                  color: AppColors.textDisabled,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.practiceTitle,
              style: AppTypography.heading1Primary.copyWith(
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.buttonPrimary,
                  width: 8,
                ),
              ),
              child: Center(
                child: Text(
                  _formatTime(_remainingSeconds),
                  style: AppTypography.heading1Primary.copyWith(
                    fontSize: 48,
                    color: AppColors.buttonPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _togglePause,
                    icon: Icon(
                      _isPaused ? Icons.play_arrow : Icons.pause,
                      color: AppColors.buttonPrimary,
                    ),
                    label: Text(
                      _isPaused ? 'Continuar' : 'Pausar',
                      style: AppTypography.textPrimary.copyWith(
                        color: AppColors.buttonPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: AppColors.buttonPrimary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _finishSession,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.stateError,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Finalizar',
                      style: AppTypography.textPrimary.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
