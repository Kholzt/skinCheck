import 'package:flutter/material.dart';
import 'package:skin_chek/screens/home/home.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Home(),
    const Center(child: Text("Chat Page")),
    const Center(child: Text("News Page")),
    const Center(child: Text("Profile Page")),
  ];

  final Color inactiveColor = Colors.grey.shade400;

  final List<IconData> icons = [
    Icons.home_outlined,
    Icons.chat_outlined,
    Icons.newspaper_outlined,
    Icons.person_2_outlined,
  ];

  final List<String> labels = ["Home", "Chat", "News", "Profile"];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomAppBar(
        elevation: 8,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(4, (index) {
              final isSelected = _selectedIndex == index;
              return InkWell(
                onTap: () => setState(() => _selectedIndex = index),
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow:
                        isSelected
                            ? [
                              BoxShadow(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary!.withOpacity(0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 4),
                              ),
                            ]
                            : [],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icons[index],
                        color: isSelected ? Colors.white : inactiveColor,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
