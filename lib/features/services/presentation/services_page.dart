import 'package:flutter/material.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    const tabs = [
      'Packages',
      'Souvenir',
      'Invitation',
      'Candle',
      'Ref Magnet',
      'T-Shirt',
      'Mug',
      'More',
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Services', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          TabBar(
            isScrollable: true,
            tabs: tabs.map((e) => Tab(text: e)).toList(),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: TabBarView(
              children: tabs
                  .map(
                    (tab) => Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Text('$tab Catalog'),
                          const SizedBox(height: 8),
                          const TextField(
                            decoration: InputDecoration(labelText: 'Name'),
                          ),
                          const SizedBox(height: 8),
                          const TextField(
                            decoration: InputDecoration(labelText: 'Price'),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
