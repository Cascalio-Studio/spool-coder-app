# Spool Coder App - Design Concept

## Overview
A modern, minimalist RFID spool management application inspired by contemporary fintech interfaces. The design emphasizes simplicity, functionality, and user experience with a clean visual hierarchy.

## Design Philosophy
- **Minimalist**: Clean interface with plenty of white space
- **Functional**: Every element serves a clear purpose
- **Consistent**: Unified design language throughout the app
- **Accessible**: High contrast and readable typography

## Color Palette

### Primary Colors
- **Primary Black**: `#202020` - Main text, icons, primary buttons
- **Accent Green**: `#C9F158` - Call-to-action buttons, highlights, success states
- **Background Gray**: `#F2F3F5` - Card backgrounds, section dividers
- **Pure White**: `#FFFFFF` - Main background, card overlays

### Usage Guidelines
- **Black (#202020)**: Primary text, navigation icons, card outlines
- **Green (#C9F158)**: Action buttons, selected states, progress indicators
- **Gray (#F2F3F5)**: Card backgrounds, inactive elements, subtle dividers
- **White (#FFFFFF)**: Main backgrounds, overlays, contrast elements

## Typography

### Font Family
**Space Grotesk** - Used consistently throughout the entire application

### Font Hierarchy
- **Display Large**: 32px, Bold - Welcome messages, main headings
- **Display Medium**: 24px, Medium - Section headers
- **Title Large**: 20px, Medium - Card titles
- **Body Large**: 16px, Regular - Primary content text
- **Body Medium**: 14px, Regular - Secondary content
- **Label Large**: 14px, Medium - Button labels
- **Label Small**: 12px, Regular - Helper text, captions

## Layout Structure

### Main Screen Layout
```
┌─────────────────────────────────────┐
│ Welcome Section                     │
│ "Good morning, [User]"              │
│ Greeting and status info            │
├─────────────────────────────────────┤
│ Read Card Section                   │
│ [Label] "Read RFID Card"            │
│ [READ BUTTON - Green]               │
├─────────────────────────────────────┤
│ Spool Selection                     │
│ Horizontal scrolling cards:         │
│ [Pre-configured] [Read Spools]      │
├─────────────────────────────────────┤
│ Write Card Section                  │
│ "Write new data to card"            │
│ [WRITE BUTTON - Green]              │
├─────────────────────────────────────┤
│ Bottom Navigation                   │
│ Home | Read | Write | Settings | Profile │
└─────────────────────────────────────┘
```

## Component Design Specifications

### 1. Welcome Section
- **Background**: White (#FFFFFF)
- **Padding**: 24px horizontal, 32px vertical
- **Typography**: 
  - Greeting: Display Large (32px, Bold, #202020)
  - Subtitle: Body Medium (14px, Regular, #202020 with 70% opacity)

### 2. Action Cards (Read/Write)
- **Background**: Gray (#F2F3F5)
- **Border Radius**: 16px
- **Padding**: 20px
- **Margin**: 16px horizontal, 8px vertical
- **Shadow**: Subtle elevation (0px 2px 8px rgba(32, 32, 32, 0.08))

#### Action Buttons
- **Background**: Green (#C9F158)
- **Text Color**: Black (#202020)
- **Typography**: Label Large (14px, Medium)
- **Border Radius**: 12px
- **Padding**: 16px vertical, 24px horizontal
- **Height**: 48px minimum

### 3. Spool Selection Cards
- **Card Background**: White (#FFFFFF)
- **Border**: 1px solid #F2F3F5
- **Border Radius**: 12px
- **Width**: 280px
- **Height**: 140px
- **Spacing**: 12px between cards
- **Shadow**: 0px 1px 4px rgba(32, 32, 32, 0.06)

#### Selected State
- **Border**: 2px solid Green (#C9F158)
- **Background**: White with green tint

### 4. Bottom Navigation
- **Background**: White (#FFFFFF)
- **Height**: 80px
- **Border Top**: 1px solid #F2F3F5
- **Safe Area**: Respects device safe areas

#### Navigation Items
- **Icon Size**: 24px
- **Icon Color**: 
  - Active: Green (#C9F158)
  - Inactive: Black (#202020) with 40% opacity
- **Label Typography**: Label Small (12px, Regular)
- **Spacing**: 8px between icon and label

## Screen Specifications

### Home Screen Components

#### 1. Welcome Header
```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
  decoration: BoxDecoration(color: Colors.white),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Good morning, User",
        style: TextStyle(
          fontFamily: 'Space Grotesk',
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Color(0xFF202020),
        ),
      ),
      SizedBox(height: 8),
      Text(
        "Welcome to Spool Coder",
        style: TextStyle(
          fontFamily: 'Space Grotesk',
          fontSize: 14,
          color: Color(0xFF202020).withOpacity(0.7),
        ),
      ),
    ],
  ),
)
```

#### 2. Read Card Section
- Label with icon
- Large green action button
- Card-style container with subtle shadow

#### 3. Horizontal Spool Carousel
- Scrollable horizontally
- Shows pre-configured and previously read spools
- Visual feedback for selection

#### 4. Write Card Section
- Similar styling to read card
- Different icon and action text

## Navigation Design

### Bottom Navigation Bar
Five equally spaced items:
1. **Home** - House icon
2. **Read** - RFID/Tag icon  
3. **Write** - Edit/Write icon
4. **Settings** - Gear icon
5. **Profile** - User/Person icon

Each item shows:
- Icon (24px)
- Label text below (12px)
- Active state with green color
- Inactive state with muted black

## Interactive States

### Button States
1. **Default**: Green background, black text
2. **Pressed**: Darker green (Green with 20% black overlay)
3. **Disabled**: Gray background, muted text
4. **Loading**: Green background with spinner

### Card States
1. **Default**: White background, subtle border
2. **Hover/Focus**: Elevated shadow
3. **Selected**: Green border, slight green background tint
4. **Disabled**: Muted colors, reduced opacity

## Accessibility Considerations

- **Contrast Ratios**: All text meets WCAG AA standards
- **Touch Targets**: Minimum 44px for interactive elements
- **Focus Indicators**: Clear visual focus states
- **Screen Reader**: Proper semantic labels for all elements

## Implementation Notes

### Flutter Theming
- Create custom `ThemeData` with Space Grotesk font
- Define color scheme using specified hex codes
- Use consistent elevation and shadow values
- Implement custom button styles

### Responsive Design
- Adapt card sizes for different screen widths
- Ensure proper spacing on tablets
- Handle safe areas for different device types

This design concept provides a modern, clean interface that prioritizes usability while maintaining visual appeal. The consistent use of Space Grotesk font and the specified color palette creates a cohesive brand experience throughout the application.

## Detailed Screen Specifications

### Welcome Section Data Display
- **Logged In User**: Shows last read spool data, total spools managed, recent activity
- **Guest/New User**: Shows recommendations and example spools
- **Format**: "Good morning, [User]" / "Welcome to Spool Coder" for guests

### Spool Card Information
Each spool card displays:
- **Filament Type** (e.g., PLA, ABS, PETG) - Title Large
- **Color** (visual color indicator + name) - Body Medium
- **Brand** (manufacturer name) - Body Medium
- **Last Used Date** (relative time format) - Label Small
- **Amount** (remaining filament in kg) - Body Large with emphasis

#### Spool Card Layout
```
┌─────────────────────────────────┐
│ [Color Dot] Filament Type       │
│ Brand Name                      │
│ ───────────────────────────     │
│ 2.5 kg remaining               │
│ Last used: 2 days ago          │
└─────────────────────────────────┘
```

### Profile Screen Layout
Inspired by the provided profile reference, structured in clean sections:

#### Profile Header
- **Background**: White (#FFFFFF)
- **User Avatar**: 80px circular, green background (#C9F158) for placeholder
- **User Name**: Display Medium (24px, Bold, #202020)
- **Email Address**: Body Medium (14px, Regular, #202020 with 70% opacity)
- **Edit Profile Button**: Black background (#202020), white text, 12px border radius

#### Settings Sections
Organized in card-based groups with section headers:

##### 1. Account Management
- **Profile Settings** - Navigation item with arrow
- **Password Management** - Navigation item with arrow  
- **Subscription Plan** - Navigation item with arrow

##### 2. App Preferences
- **Notifications** - Toggle switch (Green when active)
- **Light/Dark Theme** - Toggle switch (Green when active)
- **Hardware Allowance** - Navigation item with arrow

##### 3. Support & Legal
- **Support / Report Issues** - Navigation item with arrow
- **Privacy Policy** - Navigation item with arrow
- **Terms of Service** - Navigation item with arrow

##### 4. Account Actions
- **Logout** - Red text (#FF3B30) for emphasis, no arrow

### Settings Screen Component Specifications

#### Section Headers
- **Typography**: Body Large (16px, Medium, #202020)
- **Margin**: 24px top, 16px bottom
- **Color**: Black (#202020) with 60% opacity
- **Text Transform**: None (normal case)

#### Setting Items Container
- **Background**: Gray (#F2F3F5)
- **Border Radius**: 16px
- **Margin**: 16px horizontal, 8px vertical
- **Padding**: 4px (inner items have individual padding)

#### Individual Setting Items
- **Container**: White background within gray container
- **Padding**: 16px vertical, 20px horizontal
- **Border Radius**: 12px (inner items)
- **Typography**: Body Large (16px, Regular, #202020)
- **Separator**: 1px line, #F2F3F5, between items

#### Toggle Switches
- **Active State**: Green (#C9F158) track, white thumb
- **Inactive State**: Gray (#F2F3F5) track, white thumb
- **Size**: 51px width, 31px height (iOS standard)
- **Animation**: Smooth transition (200ms)

#### Navigation Items (with arrows)
- **Icon**: 24px, left aligned, #202020
- **Text**: Body Large, left aligned after icon
- **Arrow**: 16px chevron right, #202020 with 40% opacity
- **Badge**: Green circle with number for items like "My stores"

#### Special Items
- **Logout**: 
  - Text color: #FF3B30 (red)
  - No arrow icon
  - No left icon
  - Same container styling

### Data Display Examples

#### Welcome Section Variations
**Logged In User:**
```
Good morning, Alex
Last read: PLA Blue (Prusament) • 3 spools managed
```

**Guest User:**
```
Welcome to Spool Coder
Discover smart filament management
```

#### Spool Card Data Examples
```
Card 1:
● PLA Matte Black
  Prusament
  ─────────────
  1.8 kg remaining
  Last used: Today

Card 2:  
● PETG Clear
  Overture
  ─────────────
  0.5 kg remaining
  Last used: 5 days ago
```
