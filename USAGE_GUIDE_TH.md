# ไทยตัดคำและการขึ้นบรรทัดใหม่ - คู่มือการใช้งาน

## บทนำ

ปลั๊กอิน `thai_word_segmentation` เป็นปลั๊กอิน Flutter สำหรับตัดคำภาษาไทยและการขึ้นบรรทัดใหม่แบบอัจฉริยะ โดยสนับสนุนการแสดงผลข้อความไทยอย่างถูกต้องตามกฎของภาษาไทย

## การติดตั้ง

### 1. เพิ่มปลั๊กอินไปยัง pubspec.yaml

```yaml
dependencies:
  thai_word_segmentation:
    path: ./thai_word_segmentation
```

### 2. เรียกใช้ pub get

```bash
flutter pub get
```

### 3. Import ปลั๊กอิน

```dart
import 'package:thai_word_segmentation/thai_word_segmentation.dart';
```

---

## ตัวอย่างการใช้งาน

### 1. การตัดคำภาษาไทย (Thai Text Segmentation)

#### ตัดคำเป็นชุด (Segment Words)

```dart
final segmenter = ThaiTextSegmenter();

// ตัดข้อความเป็นคำ
List<String> words = segmenter.segment('สวัสดีชาวไทยยินดีต้อนรับ');
// ผลลัพธ์: ['สวัสดี', 'ชาว', 'ไทย', 'ยินดี', 'ต้อน', 'รับ']

// วนลูปเพื่อประมวลผลแต่ละคำ
for (String word in words) {
  print('คำ: $word');
}
```

#### จัดกลุ่มตามพยางค์ (Group by Syllables)

```dart
final segmenter = ThaiTextSegmenter();

// จัดกลุ่มข้อความตามพยางค์
List<String> syllables = segmenter.groupBySyllables('สวัสดีชาวไทย');
// ผลลัพธ์: ['สวัสดี', 'ชาว', 'ไทย']
```

#### ตรวจสอบประเภทของตัวอักษร (Check Character Type)

```dart
// ตรวจสอบว่าเป็นตัวอักษรไทยหรือไม่
bool isThai = ThaiTextSegmenter.isThaiCharacter('ก');  // true
bool isEnglish = ThaiTextSegmenter.isThaiCharacter('a');  // false

// ตรวจสอบว่าเป็นพยัญชนะไทยหรือไม่
bool isConsonant = ThaiTextSegmenter.isThaiConsonant('ค');  // true

// ตรวจสอบว่าเป็นเครื่องหมายวรรณยุกต์หรือไม่
bool isDiacritic = ThaiTextSegmenter.isThaiDiacritic('่');  // true
```

---

### 2. การขึ้นบรรทัดใหม่ (Line Breaking)

#### การขึ้นบรรทัดพื้นฐาน (Basic Line Breaking)

```dart
final breaker = ThaiLineBreaker();

// แบ่งข้อความเป็นบรรทัด
List<String> lines = breaker.breakLines(
  'สวัสดีชาวไทยยินดีต้อนรับคุณเข้ามาในประเทศไทย',
  textStyle: TextStyle(fontSize: 16),
  maxWidth: 200,  // ความกว้างสูงสุด 200 pixels
);

// ผลลัพธ์จะมีหลายบรรทัด
for (int i = 0; i < lines.length; i++) {
  print('บรรทัด ${i + 1}: ${lines[i]}');
}
```

#### การขึ้นบรรทัดแบบเข้าใจภาษาไทย (Thai-Aware Line Breaking)

```dart
final breaker = ThaiLineBreaker();

// วิธีนี้ดีกว่าสำหรับข้อความไทย
List<String> lines = breaker.breakLinesThaiAware(
  'สวัสดีชาวไทยยินดีต้อนรับคุณเข้ามาในประเทศไทย',
  textStyle: TextStyle(fontSize: 16),
  maxWidth: 200,
);
```

#### รับข้อมูลเพิ่มเติมของแต่ละบรรทัด (Get Line Information)

```dart
final breaker = ThaiLineBreaker();

// รับข้อมูลบรรทัดโดยละเอียด
List<LineBreakInfo> lineInfo = breaker.breakLinesWithInfo(
  'สวัสดีชาวไทยยินดีต้อนรับ',
  textStyle: TextStyle(fontSize: 16),
  maxWidth: 200,
);

// ข้อมูลแต่ละบรรทัด
for (LineBreakInfo info in lineInfo) {
  print('บรรทัด ${info.lineNumber}: "${info.text}"');
  print('  ความกว้าง: ${info.width.toStringAsFixed(2)} pixels');
  print('  ตำแหน่งเริ่มต้น: ${info.startOffset}');
}
```

---

### 3. Widget ของ Flutter

#### ThaiLineBreakText - Widget ที่ขึ้นบรรทัดใหม่อัตโนมัติ

```dart
// Widget นี้จะแบ่งข้อความเป็นบรรทัดโดยอัตโนมัติ
ThaiLineBreakText(
  'สวัสดีชาวไทยยินดีต้อนรับคุณเข้ามาในประเทศไทย',
  style: TextStyle(fontSize: 16),
  maxWidth: 300,  // ตัวเลือก: ความกว้างสูงสุด 300 pixels (ถ้าไม่ระบุจะใช้ความกว้างของ parent)
  maxLines: 3,    // จำนวนบรรทัดสูงสุด
  useThaiAwareBreaking: true,  // ใช้การตัดคำแบบเข้าใจภาษาไทย
)
```

#### ThaiSegmentedText - Widget สำหรับข้อความที่มีสไตล์แตกต่างกัน

```dart
// ใช้สไตล์ต่างกันสำหรับคำต่างๆ
ThaiSegmentedText(
  'สวัสดี ชาวไทย',
  defaultStyle: TextStyle(fontSize: 16),
  wordStyles: {
    'สวัสดี': TextStyle(
      fontSize: 16,
      color: Colors.red,
      fontWeight: FontWeight.bold,
    ),
    'ชาวไทย': TextStyle(
      fontSize: 16,
      color: Colors.blue,
    ),
  },
  maxWidth: 300,
)
```

#### ThaiRichText - Widget สำหรับข้อความที่มีการจัดรูปแบบ

```dart
// ใช้สำหรับข้อความที่มีการจัดรูปแบบแตกต่างกัน
ThaiRichText(
  [
    ThaiTextSpan(
      text: 'สวัสดี ',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.red,
      ),
    ),
    ThaiTextSpan(
      text: 'ชาวไทย',
      style: TextStyle(
        fontSize: 16,
        color: Colors.blue,
      ),
    ),
  ],
  maxWidth: 300,
  enableLineBreaking: true,
)
```

---

### 4. TextEditingController แบบ Thai (Thai Text Controller)

#### ใช้ controller สำหรับข้อมูลข้อความไทย

```dart
final controller = ThaiTextEditingController();

TextField(
  controller: controller,
  decoration: InputDecoration(
    hintText: 'พิมพ์ข้อความไทยที่นี่',
    border: OutlineInputBorder(),
  ),
  onChanged: (text) {
    // อัปเดต UI เมื่อข้อความเปลี่ยน
    setState(() {});
  },
)

// แสดงข้อมูลสถิติของข้อความ
Text('จำนวนตัวอักษร: ${controller.text.length}'),
Text('จำนวนคำ: ${controller.getWordCount()}'),
Text('จำนวนพยางค์: ${controller.getSyllableCount()}'),

// รับคำที่ตัดแล้ว
List<String> segments = controller.getSegments();

// รับบรรทัดที่แบ่งแล้ว
List<String> lines = controller.getLines(
  style: TextStyle(fontSize: 16),
  maxWidth: 300,
);
```

---

## ตัวอย่างการใช้งานจริง

### ตัวอย่างที่ 1: แสดงข้อความไทยพร้อมการขึ้นบรรทัดอัตโนมัติ

```dart
class ThaiArticleScreen extends StatelessWidget {
  final String articleText = 'สวัสดีชาวไทยยินดีต้อนรับเข้าไปในแอปพลิเคชัน...';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('บทความ')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ThaiLineBreakText(
          articleText,
          style: TextStyle(fontSize: 16, height: 1.5),
          maxWidth: MediaQuery.of(context).size.width - 32,
          useThaiAwareBreaking: true,
        ),
      ),
    );
  }
}
```

### ตัวอย่างที่ 2: การนับตัวอักษรและคำในช่องข้อความ

```dart
class TextStatisticsScreen extends StatefulWidget {
  @override
  State<TextStatisticsScreen> createState() => _TextStatisticsScreenState();
}

class _TextStatisticsScreenState extends State<TextStatisticsScreen> {
  late ThaiTextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ThaiTextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('สถิติข้อความ')),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            minLines: 5,
            maxLines: 10,
            decoration: InputDecoration(
              hintText: 'พิมพ์ข้อความไทยที่นี่',
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
          ),
          SizedBox(height: 16),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('จำนวนตัวอักษร: ${_controller.text.length}'),
                  Text('จำนวนคำ: ${_controller.getWordCount()}'),
                  Text('จำนวนพยางค์: ${_controller.getSyllableCount()}'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

### ตัวอย่างที่ 3: การแสดงคำพร้อมสีต่างๆ

```dart
class HighlightedThaiText extends StatelessWidget {
  final String text = 'สวัสดี ชาวไทย ยินดีต้อนรับ';

  @override
  Widget build(BuildContext context) {
    return ThaiSegmentedText(
      text,
      defaultStyle: TextStyle(fontSize: 16),
      wordStyles: {
        'สวัสดี': TextStyle(fontSize: 16, color: Colors.red),
        'ชาวไทย': TextStyle(fontSize: 16, color: Colors.green),
        'ยินดีต้อนรับ': TextStyle(fontSize: 16, color: Colors.blue),
      },
      maxWidth: 300,
    );
  }
}
```

---

## เคล็ดลับการใช้งาน

### 1. การตั้งค่าความกว้างที่ถูกต้อง

```dart
// maxWidth เป็นตัวเลือก - ถ้าไม่ระบุจะใช้ความกว้างของ parent widget

// วิธีที่ 1: ไม่ระบุ maxWidth (ง่ายที่สุด)
ThaiLineBreakText(
  text,
  style: TextStyle(fontSize: 16),
)

// วิธีที่ 2: ระบุ maxWidth ถ้าต้องการให้แม่นยำ
double maxWidth = MediaQuery.of(context).size.width - 32; // 16 padding × 2
ThaiLineBreakText(
  text,
  style: TextStyle(fontSize: 16),
  maxWidth: maxWidth,
)
```

### 2. ใช้ Thai-Aware Breaking เสมอ

```dart
// วิธีที่ดี (unleash Thai text handling)
breaker.breakLinesThaiAware(text, ...)

// วิธีที่ไม่ดี (basic breaking)
breaker.breakLines(text, ...)
```

### 3. แคช (Cache) ผลลัพธ์สำหรับข้อความที่ไม่เปลี่ยน

```dart
// ตั้งค่าเพียงครั้งเดียว
final words = segmenter.segment(text);

// ใช้ซ้ำหลายครั้ง
for (String word in words) {
  // ประมวลผล
}
```

### 4. ตรวจสอบประเภทอักษรก่อนประมวลผล

```dart
String userInput = getInput();

// ตรวจสอบว่ามีอักษรไทยหรือไม่
bool hasThaiCharacters = userInput.split('').any(
  (char) => ThaiTextSegmenter.isThaiCharacter(char)
);

if (hasThaiCharacters) {
  // ใช้ segmenter
} else {
  // ใช้วิธีอื่น
}
```

---

## สนับสนุนตัวอักษร

ปลั๊กอินรองรับ:

| องค์ประกอบ | รายละเอียด |
|-----------|----------|
| ตัวอักษรไทย | U+0E00 ถึง U+0E7F |
| พยัญชนะ | 44 ตัว |
| สระ | 12 ตำแหน่งสระ |
| เครื่องหมายวรรณยุกต์ | 4 เครื่องหมาย |
| ตัวเลขไทย | 10 ตัว |
| ข้อความผสม | ไทย + English + ตัวเลข + เครื่องหมายวรรณยุกต์ |

---

## การแก้ไขปัญหา (Troubleshooting)

### ปัญหา: ข้อความไม่ถูกตัดคำ

```dart
// วิธีแก้: ตรวจสอบว่า Unicode ถูกต้อง
String text = 'สวัสดี'; // U+0E2A U+0E27 U+0E31 U+0E2A U+0E14 U+0E35

// ใช้เครื่องมือตรวจสอบ
for (int i = 0; i < text.length; i++) {
  int codeUnit = text.codeUnitAt(i);
  print('Position $i: U+${codeUnit.toRadixString(16).toUpperCase()}');
}
```

### ปัญหา: การขึ้นบรรทัดไม่ถูกต้อง

```dart
// วิธีแก้: ตรวจสอบ maxWidth
print('Screen width: ${MediaQuery.of(context).size.width}');

double maxWidth = MediaQuery.of(context).size.width - 32;
ThaiLineBreakText(
  text,
  style: TextStyle(fontSize: 16), // ตรวจสอบขนาดฟอนต์
  maxWidth: maxWidth,
)
```

### ปัญหา: ฟอนต์ไม่รองรับภาษาไทย

```dart
// วิธีแก้: เพิ่มฟอนต์ที่รองรับไทย
// ใน pubspec.yaml
flutter:
  fonts:
    - family: Noto Sans Thai
      fonts:
        - asset: assets/fonts/NotoSansThai-Regular.ttf
        - asset: assets/fonts/NotoSansThai-Bold.ttf
          weight: 700

// ใช้ฟอนต์ที่รองรับ
TextStyle(
  fontFamily: 'Noto Sans Thai',
  fontSize: 16,
)
```

---

## API ทั้งหมด

### ThaiTextSegmenter

```dart
// ตัดคำ
List<String> segment(String text)

// จัดกลุ่มตามพยางค์
List<String> groupBySyllables(String text)

// ตรวจสอบประเภทอักษร
static bool isThaiCharacter(String char)
static bool isThaiConsonant(String char)
static bool isThaiDiacritic(String char)
```

### ThaiLineBreaker

```dart
// ขึ้นบรรทัดพื้นฐาน
List<String> breakLines(
  String text,
  {required TextStyle textStyle, required double maxWidth}
)

// ขึ้นบรรทัดแบบเข้าใจไทย
List<String> breakLinesThaiAware(
  String text,
  {required TextStyle textStyle, required double maxWidth}
)

// ขึ้นบรรทัดพร้อมข้อมูล
List<LineBreakInfo> breakLinesWithInfo(
  String text,
  {required TextStyle textStyle, required double maxWidth}
)
```

### Widgets

```dart
ThaiLineBreakText(...)
ThaiSegmentedText(...)
ThaiRichText(...)
ThaiTextEditingController(...)
```

---

## เพิ่มเติม

- ดูตัวอย่างฟังชั่นทั้งหมดใน `example/` folder
- ดูการทดสอบหน่วยใน `test/` folder
- ดู API documentation อย่างละเอียดใน [README.md](./README.md)

## ติดต่อและสนับสนุน

หากพบปัญหาหรือมีข้อเสนอแนะ โปรดสร้าง issue ใน repository นี้

---

**เขียนด้วย ❤️ สำหรับชุมชน Flutter ไทย**
