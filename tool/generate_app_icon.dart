// ignore_for_file: avoid_print
// Ebisu App Icon Generator
// A standalone Dart script that creates app icons using dart:ui
//
// Run with: dart run tool/generate_app_icon.dart
// Note: Requires dart:ui, run within Flutter context or use flutter run

import 'dart:io';
import 'dart:typed_data';
import 'dart:math' as math;

/// Simple PNG encoder for generating app icons
/// Creates a stylized "E" icon with warm terracotta background
class IconGenerator {
  static const int _terracottaR = 194;
  static const int _terracottaG = 123;
  static const int _terracottaB = 92;
  
  /// Generates the app icon as PNG bytes
  static Uint8List generateIcon(int size, {bool withBackground = true}) {
    // Create RGBA pixel data
    final pixels = Uint8List(size * size * 4);
    
    // Dimensions for the "E"
    final padding = size * 0.2;
    final eLeft = padding;
    final eRight = size - padding;
    final eTop = padding;
    final eBottom = size - padding;
    final stroke = size * 0.12;
    
    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        final idx = (y * size + x) * 4;
        
        // Check if pixel is part of the "E"
        bool isE = false;
        
        // Vertical bar (left side)
        if (x >= eLeft && x <= eLeft + stroke &&
            y >= eTop && y <= eBottom) {
          isE = true;
        }
        
        // Top horizontal bar
        if (x >= eLeft && x <= eRight &&
            y >= eTop && y <= eTop + stroke) {
          isE = true;
        }
        
        // Middle horizontal bar (slightly shorter)
        final middleY = eTop + (eBottom - eTop - stroke) / 2;
        if (x >= eLeft && x <= eRight - stroke * 0.8 &&
            y >= middleY && y <= middleY + stroke) {
          isE = true;
        }
        
        // Bottom horizontal bar
        if (x >= eLeft && x <= eRight &&
            y >= eBottom - stroke && y <= eBottom) {
          isE = true;
        }
        
        if (isE) {
          // White for the E
          pixels[idx] = 255;     // R
          pixels[idx + 1] = 255; // G
          pixels[idx + 2] = 255; // B
          pixels[idx + 3] = 255; // A
        } else if (withBackground) {
          // Terracotta background
          pixels[idx] = _terracottaR;
          pixels[idx + 1] = _terracottaG;
          pixels[idx + 2] = _terracottaB;
          pixels[idx + 3] = 255;
        } else {
          // Transparent
          pixels[idx] = 0;
          pixels[idx + 1] = 0;
          pixels[idx + 2] = 0;
          pixels[idx + 3] = 0;
        }
      }
    }
    
    return _encodePng(pixels, size, size);
  }
  
  /// Encodes RGBA pixel data as PNG
  static Uint8List _encodePng(Uint8List pixels, int width, int height) {
    final out = BytesBuilder();
    
    // PNG signature
    out.add([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]);
    
    // IHDR chunk
    final ihdr = BytesBuilder();
    ihdr.add(_intToBytes(width, 4));
    ihdr.add(_intToBytes(height, 4));
    ihdr.addByte(8);  // bit depth
    ihdr.addByte(6);  // color type: RGBA
    ihdr.addByte(0);  // compression
    ihdr.addByte(0);  // filter
    ihdr.addByte(0);  // interlace
    _writeChunk(out, 'IHDR', ihdr.toBytes());
    
    // IDAT chunk - raw pixel data with filter bytes
    final rawData = BytesBuilder();
    for (int y = 0; y < height; y++) {
      rawData.addByte(0); // No filter for this row
      for (int x = 0; x < width; x++) {
        final idx = (y * width + x) * 4;
        rawData.addByte(pixels[idx]);     // R
        rawData.addByte(pixels[idx + 1]); // G
        rawData.addByte(pixels[idx + 2]); // B
        rawData.addByte(pixels[idx + 3]); // A
      }
    }
    
    // Compress with zlib
    final compressed = _zlibCompress(rawData.toBytes());
    _writeChunk(out, 'IDAT', compressed);
    
    // IEND chunk
    _writeChunk(out, 'IEND', Uint8List(0));
    
    return out.toBytes();
  }
  
  static Uint8List _intToBytes(int value, int length) {
    final bytes = Uint8List(length);
    for (int i = length - 1; i >= 0; i--) {
      bytes[i] = value & 0xFF;
      value >>= 8;
    }
    return bytes;
  }
  
  static void _writeChunk(BytesBuilder out, String type, Uint8List data) {
    out.add(_intToBytes(data.length, 4));
    final typeBytes = Uint8List.fromList(type.codeUnits);
    out.add(typeBytes);
    out.add(data);
    
    // CRC32
    final crcData = BytesBuilder();
    crcData.add(typeBytes);
    crcData.add(data);
    out.add(_intToBytes(_crc32(crcData.toBytes()), 4));
  }
  
  // Simple zlib compression (store only, no actual compression)
  static Uint8List _zlibCompress(Uint8List data) {
    final out = BytesBuilder();
    
    // Zlib header
    out.addByte(0x78); // CMF
    out.addByte(0x01); // FLG
    
    // Deflate: store blocks
    int offset = 0;
    while (offset < data.length) {
      final remaining = data.length - offset;
      final blockSize = math.min(remaining, 65535);
      final isLast = offset + blockSize >= data.length;
      
      out.addByte(isLast ? 0x01 : 0x00); // BFINAL and BTYPE=00 (stored)
      out.addByte(blockSize & 0xFF);
      out.addByte((blockSize >> 8) & 0xFF);
      out.addByte((~blockSize) & 0xFF);
      out.addByte(((~blockSize) >> 8) & 0xFF);
      
      out.add(data.sublist(offset, offset + blockSize));
      offset += blockSize;
    }
    
    // Adler-32 checksum
    final adler = _adler32(data);
    out.addByte((adler >> 24) & 0xFF);
    out.addByte((adler >> 16) & 0xFF);
    out.addByte((adler >> 8) & 0xFF);
    out.addByte(adler & 0xFF);
    
    return out.toBytes();
  }
  
  static int _adler32(Uint8List data) {
    int a = 1;
    int b = 0;
    for (final byte in data) {
      a = (a + byte) % 65521;
      b = (b + a) % 65521;
    }
    return (b << 16) | a;
  }
  
  static final List<int> _crcTable = _makeCrcTable();
  
  static List<int> _makeCrcTable() {
    final table = List<int>.filled(256, 0);
    for (int n = 0; n < 256; n++) {
      int c = n;
      for (int k = 0; k < 8; k++) {
        if ((c & 1) != 0) {
          c = 0xEDB88320 ^ (c >> 1);
        } else {
          c = c >> 1;
        }
      }
      table[n] = c;
    }
    return table;
  }
  
  static int _crc32(Uint8List data) {
    int crc = 0xFFFFFFFF;
    for (final byte in data) {
      crc = _crcTable[(crc ^ byte) & 0xFF] ^ (crc >> 8);
    }
    return crc ^ 0xFFFFFFFF;
  }
}

void main() async {
  final projectDir = Directory.current.path;
  final iconDir = '$projectDir/assets/icon';
  
  // Ensure directory exists
  await Directory(iconDir).create(recursive: true);
  
  print('Generating Ebisu app icons...');
  print('Output directory: $iconDir');
  print('');
  
  // Main app icon
  print('Creating app_icon.png (1024x1024)...');
  final icon = IconGenerator.generateIcon(1024);
  await File('$iconDir/app_icon.png').writeAsBytes(icon);
  
  // Adaptive foreground (with extra padding for safe zone)
  print('Creating app_icon_foreground.png (1024x1024)...');
  final foreground = IconGenerator.generateIcon(1024, withBackground: false);
  await File('$iconDir/app_icon_foreground.png').writeAsBytes(foreground);
  
  print('');
  print('✓ Icons generated successfully!');
  print('');
  print('Next steps:');
  print('1. Run: flutter pub get');
  print('2. Run: dart run flutter_launcher_icons');
}
