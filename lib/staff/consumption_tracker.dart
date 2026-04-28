import 'package:flutter/material.dart';

class ConsumptionTracker extends StatefulWidget {
  const ConsumptionTracker({super.key});

  @override
  State<ConsumptionTracker> createState() => _ConsumptionTrackerState();
}

class _ConsumptionTrackerState extends State<ConsumptionTracker> {
  String _activeCategory = 'Printing';

  // State for the "Current Order" list
  List<Map<String, dynamic>> currentOrders = [
    {'name': 'Sample Order', 'count': 1},
    {'name': 'Sample Order', 'count': 2},
  ];

  void _addItem(String name) {
    setState(() {
      // Check if item already exists
      bool exists = currentOrders.any((item) => item['name'] == name);
      if (exists) {
        // If exists, just increment (or you could add a new row depending on logic)
        // For this demo, let's just add a new row to mimic the screenshot
        currentOrders.add({'name': name, 'count': 1});
      } else {
        currentOrders.add({'name': name, 'count': 1});
      }
    });
  }

  void _incrementItem(int index) {
    setState(() {
      currentOrders[index]['count']++;
    });
  }

  void _decrementItem(int index) {
    setState(() {
      if (currentOrders[index]['count'] > 0) {
        currentOrders[index]['count']--;
      }
    });
  }

  void _removeItem(int index) {
    setState(() {
      currentOrders.removeAt(index);
    });
  }

  void _clearAllItems() {
    setState(() {
      currentOrders.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFA5C9FF), Color(0xFFE8F1FF)],
          ),
        ),
        child: Column(
          children: [
            // REMOVED _buildTopBar() because MainLayout handles it.
            // If you are using this page independently, you can add it back.
            
            const SizedBox(height: 20), // Spacing from the MainLayout top bar

            // MAIN CONTENT AREA
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // LEFT SIDE (Printing Orders & Grid)
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          const Text(
                            "Printing Orders",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E3A59),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // CATEGORY TABS
                          Row(
                            children: [
                              _buildCategoryTab("Printing"),
                              const SizedBox(width: 8),
                              _buildCategoryTab("Xerox"),
                              const SizedBox(width: 8),
                              _buildCategoryTab("School Supplies"),
                              const SizedBox(width: 8),
                              _buildCategoryTab("Party Needs"),
                            ],
                          ),
                          const SizedBox(height: 25),

                          // ITEM GRID (Clickable Empty Boxes)
                          Expanded(
                            child: GridView.count(
                              crossAxisCount: 4,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              childAspectRatio: 1.5,
                              children: List.generate(8, (index) {
                                return InkWell(
                                  onTap: () {
                                    // Example: Add "Item X" to the current order list
                                    _addItem("Item ${index + 1}");
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 24),

                    // RIGHT SIDE (Current Order Panel)
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Header with Delete Button
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                              decoration: const BoxDecoration(
                                color: Color(0xFF2C3E87), // Dark Navy Blue
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Current Order",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  // CLICKABLE DELETE BUTTON
                                  InkWell(
                                    onTap: _clearAllItems,
                                    child: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                  ),
                                ],
                              ),
                            ),
                            
                            // List of Orders
                            Expanded(
                              child: ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: currentOrders.length,
                                itemBuilder: (context, index) {
                                  return _buildOrderItem(index);
                                },
                              ),
                            ),

                            // Footer Button
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF00C853), // Green
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: const Text(
                                    "Save and Finish",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= UI HELPER METHODS =================

  Widget _buildCategoryTab(String label) {
    bool isActive = _activeCategory == label;
    return GestureDetector(
      onTap: () => setState(() => _activeCategory = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: isActive ? Border.all(color: Colors.transparent) : null,
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.black : Colors.black54,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildOrderItem(int index) {
    final order = currentOrders[index];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                order['name'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2E3A59),
                ),
              ),
            ),
            // Remove Item Button (Small X next to name)
            IconButton(
              icon: const Icon(Icons.close, color: Colors.grey, size: 16),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => _removeItem(index),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // MINUS BUTTON
            InkWell(
              onTap: () => _decrementItem(index),
              borderRadius: BorderRadius.circular(6),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E7EB),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Center(child: Text("-", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              "${order['count']}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E3A59),
              ),
            ),
            const SizedBox(width: 12),
            // PLUS BUTTON
            InkWell(
              onTap: () => _incrementItem(index),
              borderRadius: BorderRadius.circular(6),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E7EB),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Center(child: Text("+", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
              ),
            ),
          ],
        ),
        const Divider(height: 25),
      ],
    );
  }
}

