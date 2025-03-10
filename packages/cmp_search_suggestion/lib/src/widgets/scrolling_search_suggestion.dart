import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/category_item_bloc.dart';

class ScrollingSearchSuggestion extends StatefulWidget {
  const ScrollingSearchSuggestion({super.key});

  @override
  ScrollingSearchSuggestionState createState() =>
      ScrollingSearchSuggestionState();
}

class ScrollingSearchSuggestionState extends State<ScrollingSearchSuggestion>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  late Animation<double> _fadeAnimation;
  Timer? _timer;
  String _suggestion = '';

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(
          milliseconds: 3000), // Increased duration for better timing
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.01,
            curve:
                Curves.easeIn), // 🔹 Fade-in happens first (5% of total time)
      ),
    );

    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.8, 1.0, curve: Curves.easeInOut),
      ),
    );

    _startScrolling();
  }

  void _startScrolling() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _controller.forward().then((_) {
        context.read<CategoryItemBloc>().add(EmitRandomCategoryItem());
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryItemBloc, CategoryItemState>(
      listener: (context, state) {
        setState(() {
          _suggestion = state.categoryItem;
          _controller.reset(); // Reset for next cycle
        });
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: double.infinity,
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey, width: 1),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.grey),
                const SizedBox(width: 10),
                Expanded(
                  child: ClipRect(
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return SlideTransition(
                          position: _animation,
                          child: FadeTransition(
                            opacity:
                                _fadeAnimation, // 🔹 Fade-in happens fully before scrolling
                            child: Text(
                                _suggestion.isNotEmpty
                                    ? "Search for \"$_suggestion\""
                                    : "",
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Color.fromRGBO(0, 0, 0, 1.0))),
                          ),
                        );
                      },
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
}
