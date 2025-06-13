import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search_recommendation/search_recommendation.dart';
import 'package:search_recommendation/src/data/search_recommendation_view_model.dart';

class SearchRecommendationView extends StatefulWidget {
  const SearchRecommendationView({super.key, this.onTap});
  final VoidCallback? onTap;

  @override
  ScrollingSearchRecommendationState createState() =>
      ScrollingSearchRecommendationState();
}

class ScrollingSearchRecommendationState extends State<SearchRecommendationView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _scrollCenterToUp;
  late Animation<Offset> _scrollBottomToCenter;

  bool _flipAnimation = true;
  Timer? _timer;
  int _counter = 0;
  List<SearchRecommendationViewModel> _recommendations = [
    const SearchRecommendationViewModel(name: 'items'),
  ];
  String _recommendation = 'items';

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scrollCenterToUp = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.8, curve: Curves.easeInOut),
      ),
    );

    _scrollBottomToCenter = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.8, curve: Curves.easeInOut),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchRecommendationBloc>().add(FetchSearchRecommendation());
    });
  }

  void _startScrolling() {
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      _controller.forward().then((_) {
        _flipAnimation = !_flipAnimation;
        setState(() {
          if (_recommendations.isNotEmpty) {
            _recommendation = _recommendations[_counter].name;
          }
          _controller.reset(); // Reset for next cycle
        });
        if (_flipAnimation) {
          _counter++;
          if (_counter >= _recommendations.length) {
            _counter = 0;
          }
        }
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
    return BlocConsumer<SearchRecommendationBloc, SearchRecommendationState>(
      listener: (context, state) {
        if (state is SearchRecommendationLoaded) {
          _recommendations = state.recommendations;
          _startScrolling();
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              width: double.infinity,
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
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
                            position: _flipAnimation
                                ? _scrollCenterToUp
                                : _scrollBottomToCenter,
                            child: Text(
                              'Search for "$_recommendation"',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(0, 0, 0, 1),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
