"""
Ebisu App Icon Generator
Generates a stylized "E" logo with warm terracotta background.

Install dependencies: pip install Pillow
Run: python tool/create_icon.py
"""

from PIL import Image, ImageDraw, ImageFont
import os

# Colors matching the app theme
TERRACOTTA = (194, 123, 92)  # #C27B5C
WHITE = (255, 255, 255)
CREAM = (255, 248, 240)  # #FFF8F0

def create_ebisu_icon(size=1024, with_background=True):
    """Create a stylized E icon for Ebisu app."""
    # Create image with transparency or solid background
    if with_background:
        img = Image.new('RGBA', (size, size), TERRACOTTA + (255,))
    else:
        img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    
    draw = ImageDraw.Draw(img)
    
    # Calculate dimensions for the "E"
    padding = size * 0.2
    e_left = padding
    e_right = size - padding
    e_top = padding
    e_bottom = size - padding
    e_width = e_right - e_left
    e_height = e_bottom - e_top
    
    # Stroke width for the E
    stroke = size * 0.12
    
    # Draw the stylized "E"
    # The E is designed to look like stacked progress bars / quest scroll
    
    # Vertical bar (left side of E)
    vertical_left = e_left
    vertical_right = e_left + stroke
    draw.rounded_rectangle(
        [vertical_left, e_top, vertical_right, e_bottom],
        radius=stroke * 0.3,
        fill=WHITE
    )
    
    # Top horizontal bar (like a scroll header)
    top_bar_left = e_left
    top_bar_right = e_right
    top_bar_top = e_top
    top_bar_bottom = e_top + stroke
    draw.rounded_rectangle(
        [top_bar_left, top_bar_top, top_bar_right, top_bar_bottom],
        radius=stroke * 0.3,
        fill=WHITE
    )
    
    # Middle horizontal bar (shorter, like a progress indicator)
    middle_y = e_top + (e_height - stroke) / 2
    middle_bar_left = e_left
    middle_bar_right = e_right - stroke * 0.8  # Slightly shorter
    draw.rounded_rectangle(
        [middle_bar_left, middle_y, middle_bar_right, middle_y + stroke],
        radius=stroke * 0.3,
        fill=WHITE
    )
    
    # Bottom horizontal bar (full width, like a foundation)
    bottom_bar_top = e_bottom - stroke
    draw.rounded_rectangle(
        [e_left, bottom_bar_top, e_right, e_bottom],
        radius=stroke * 0.3,
        fill=WHITE
    )
    
    # Add subtle decorative elements - small dots suggesting XP or progress
    dot_radius = stroke * 0.15
    dot_color = CREAM if with_background else WHITE
    
    # Dots near the middle bar end (like progress indicators)
    dot_x = e_right - stroke * 0.3
    dot_y = middle_y + stroke / 2
    if with_background:
        draw.ellipse(
            [dot_x - dot_radius, dot_y - dot_radius, 
             dot_x + dot_radius, dot_y + dot_radius],
            fill=dot_color
        )
    
    return img


def create_adaptive_foreground(size=1024):
    """Create foreground for adaptive icons (Android)."""
    # Adaptive icons need extra padding (safe zone is 66% of the total)
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    
    # Create the E at a smaller size centered in the image
    inner_size = int(size * 0.6)  # 60% of total for safe zone
    e_icon = create_ebisu_icon(inner_size, with_background=False)
    
    # Paste centered
    offset = (size - inner_size) // 2
    img.paste(e_icon, (offset, offset), e_icon)
    
    return img


def main():
    """Generate all required icon files."""
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_dir = os.path.dirname(script_dir)
    icon_dir = os.path.join(project_dir, 'assets', 'icon')
    
    # Create directory if it doesn't exist
    os.makedirs(icon_dir, exist_ok=True)
    
    print("Generating Ebisu app icons...")
    print(f"Output directory: {icon_dir}")
    print()
    
    # Main app icon (1024x1024)
    print("Creating app_icon.png (1024x1024)...")
    icon = create_ebisu_icon(1024)
    icon.save(os.path.join(icon_dir, 'app_icon.png'), 'PNG')
    
    # Adaptive icon foreground for Android
    print("Creating app_icon_foreground.png (1024x1024)...")
    foreground = create_adaptive_foreground(1024)
    foreground.save(os.path.join(icon_dir, 'app_icon_foreground.png'), 'PNG')
    
    # Web icons (already handled by flutter_launcher_icons, but let's add extras)
    print("Creating favicon.png (32x32)...")
    favicon = create_ebisu_icon(32)
    favicon.save(os.path.join(icon_dir, 'favicon.png'), 'PNG')
    
    print()
    print("✓ Icons generated successfully!")
    print()
    print("Next steps:")
    print("1. Run: flutter pub get")
    print("2. Run: dart run flutter_launcher_icons")
    print()


if __name__ == '__main__':
    main()
