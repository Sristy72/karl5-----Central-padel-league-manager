# Responsive Design - Developer Guide

## Quick Reference

### Using ResponsiveUtils

```dart
import 'package:flutter_karlfive223_manager/core/utils/responsive_utils.dart';

// Check screen size
if (ResponsiveUtils.isSmallScreen(context)) {
  // Render for small screens
}

// Get responsive values
double padding = ResponsiveUtils.getHorizontalPadding(context);
double fontSize = ResponsiveUtils.getHeadingFontSize(context);
double spacing = ResponsiveUtils.getSpacing(context);
```

---

## Common Patterns

### Pattern 1: Responsive Padding

❌ **WRONG - Fixed padding**
```dart
padding: const EdgeInsets.symmetric(horizontal: 24.0),
```

✅ **CORRECT - Responsive padding**
```dart
padding: EdgeInsets.symmetric(
  horizontal: MediaQuery.of(context).size.width < 400 ? 12.0 : 24.0,
),
```

✅ **BETTER - Using helper**
```dart
padding: EdgeInsets.symmetric(
  horizontal: ResponsiveUtils.getHorizontalPadding(context),
),
```

---

### Pattern 2: Responsive Font Sizes

❌ **WRONG - Fixed font**
```dart
style: const TextStyle(fontSize: 18),
```

✅ **CORRECT - Responsive font**
```dart
style: TextStyle(
  fontSize: MediaQuery.of(context).size.width < 350 ? 16 : 18,
),
```

✅ **BETTER - Using helper**
```dart
style: TextStyle(
  fontSize: ResponsiveUtils.getHeadingFontSize(context),
),
```

---

### Pattern 3: Responsive Spacing

❌ **WRONG - Fixed spacing**
```dart
children: [
  Widget1(),
  const SizedBox(height: 20),
  Widget2(),
]
```

✅ **CORRECT - Responsive spacing**
```dart
children: [
  Widget1(),
  SizedBox(height: MediaQuery.of(context).size.width < 350 ? 12 : 20),
  Widget2(),
]
```

✅ **BETTER - Using helper**
```dart
children: [
  Widget1(),
  SizedBox(height: ResponsiveUtils.getSpacing(context)),
  Widget2(),
]
```

---

### Pattern 4: Responsive Widget Size

❌ **WRONG - Fixed size**
```dart
SizedBox(
  width: 100,
  height: 100,
  child: Icon(Icons.add),
)
```

✅ **CORRECT - Responsive size**
```dart
SizedBox(
  width: 100,
  height: 100,
  child: Icon(
    Icons.add,
    size: MediaQuery.of(context).size.width < 350 ? 20 : 24,
  ),
)
```

✅ **BETTER - Using helper**
```dart
SizedBox(
  width: 100,
  height: 100,
  child: Icon(
    Icons.add,
    size: ResponsiveUtils.getIconSize(context),
  ),
)
```

---

## Breakpoints Reference

```dart
// Use these constants for consistency
const SMALL_SCREEN_BREAKPOINT = 350;   // < 350px = small
const MEDIUM_SCREEN_BREAKPOINT = 400;  // 350-399px = medium
const LARGE_SCREEN_BREAKPOINT = 400;   // >= 400px = large

// Padding values by screen size
const SMALL_PADDING = 12.0;   // for screens < 350px
const MEDIUM_PADDING = 16.0;  // for screens 350-399px
const LARGE_PADDING = 24.0;   // for screens >= 400px

// Font sizes by screen size
const SMALL_FONT = 12.0;      // for screens < 350px
const MEDIUM_FONT = 14.0;     // for screens 350-399px
const LARGE_FONT = 16.0;      // for screens >= 400px
```

---

## Implementation Examples

### Example 1: Simple Widget

```dart
class MyResponsiveWidget extends StatelessWidget {
  const MyResponsiveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth < 400 ? 12 : 24,
      ),
      child: Column(
        children: [
          Text(
            'Hello World',
            style: TextStyle(
              fontSize: screenWidth < 350 ? 16 : 18,
            ),
          ),
          SizedBox(height: screenWidth < 350 ? 8 : 12),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Click Me'),
          ),
        ],
      ),
    );
  }
}
```

### Example 2: List Item

```dart
class MyListItem extends StatelessWidget {
  final String title;
  final String description;

  const MyListItem({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.getHorizontalPadding(context),
        vertical: ResponsiveUtils.getVerticalPadding(context),
      ),
      padding: EdgeInsets.all(
        ResponsiveUtils.getVerticalPadding(context),
      ),
      decoration: BoxDecoration(
        borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: ResponsiveUtils.getHeadingFontSize(context),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: ResponsiveUtils.getVerticalPadding(context)),
          Text(
            description,
            style: TextStyle(
              fontSize: ResponsiveUtils.getBodyFontSize(context),
            ),
          ),
        ],
      ),
    );
  }
}
```

### Example 3: Grid Layout

```dart
class MyResponsiveGrid extends StatelessWidget {
  final List<String> items;

  const MyResponsiveGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final screenWidth = ResponsiveUtils.getScreenWidth(context);
    final isSmall = ResponsiveUtils.isSmallScreen(context);
    
    int crossAxisCount = isSmall ? 2 : 3;
    double spacing = ResponsiveUtils.getSpacing(context);

    return GridView.builder(
      padding: EdgeInsets.all(
        ResponsiveUtils.getHorizontalPadding(context),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: ResponsiveUtils.getResponsiveBorderRadius(context),
          ),
          child: Center(
            child: Text(
              items[index],
              style: TextStyle(
                fontSize: ResponsiveUtils.getBodyFontSize(context),
              ),
            ),
          ),
        );
      },
    );
  }
}
```

---

## Testing Responsive Design

### Manual Testing

```dart
// Test all breakpoints:
// 1. Screen width: 320px (small phone)
// 2. Screen width: 360px (medium phone)
// 3. Screen width: 400px (large phone)
// 4. Screen width: 600px+ (tablet)

// In Android Emulator:
// Settings > Screen Size > Custom
// Set to different widths to test

// In iOS Simulator:
// Device > Rotate
// Window > Scale > 75%, 100%, 125%
```

### Automated Testing

```dart
void main() {
  testWidgets('Widget is responsive on small screens', (WidgetTester tester) async {
    // Set small screen size
    addTearDown(tester.binding.window.physicalSizeTestValue = const Size(320, 640));
    addTearDown(addTearDown);
    
    await tester.pumpWidget(const MyApp());
    
    // Verify responsive behavior
    expect(find.byType(MyResponsiveWidget), findsOneWidget);
  });
}
```

---

## Best Practices

### ✅ DO:
- Use `MediaQuery.of(context).size.width` for dynamic values
- Use `ResponsiveUtils` helper methods for consistency
- Test on multiple screen sizes
- Use `Expanded` and `Flexible` for flexible layouts
- Use `LayoutBuilder` for complex responsive layouts
- Provide adequate padding on small screens

### ❌ DON'T:
- Use fixed pixel values for padding/spacing
- Use fixed font sizes
- Use fixed widget sizes
- Ignore screen orientation changes
- Forget to test on small devices
- Remove padding to fit content
- Use hardcoded breakpoints in multiple places

---

## Responsive Design Checklist

Before deploying any widget, ensure:

- [ ] Padding is responsive on small screens (< 350px)
- [ ] Font sizes scale appropriately
- [ ] No text overflow on small screens
- [ ] Buttons are clickable (min 48px height)
- [ ] Images scale without distortion
- [ ] Layouts don't break on any screen size
- [ ] Vertical scrolling works smoothly
- [ ] Bottom navigation is accessible
- [ ] All colors are visible on all devices
- [ ] Performance is not impacted
- [ ] Works in both portrait and landscape
- [ ] Tablet devices are supported (600px+)

---

## Resources

- **ResponsiveUtils location**: `lib/core/utils/responsive_utils.dart`
- **Flutter MediaQuery docs**: https://api.flutter.dev/flutter/widgets/MediaQuery-class.html
- **Layout guide**: https://flutter.dev/docs/development/ui/layout
- **Responsive design**: https://flutter.dev/docs/development/data-and-backend/json
