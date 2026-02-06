# เริ่มต้นใช้งาน Thai Word Segmentation อย่างรวดเร็ว

## 📱 ติดตั้งใน 3 ขั้นตอน

### ขั้นที่ 1: เพิ่มปลั๊กอิน

```yaml
# pubspec.yaml
dependencies:
  thai_word_segmentation:
    path: ./thai_word_segmentation
```

### ขั้นที่ 2: รัน pub get

```bash
flutter pub get
```

### ขั้นที่ 3: Import ปลั๊กอิน

```dart
import 'package:thai_word_segmentation/thai_word_segmentation.dart';
```

---

## ⚡ 5 ตัวอย่างที่ใช้บ่อย

### 1️⃣ แสดงข้อความไทยพร้อมขึ้นบรรทัดอัตโนมัติ

```dart
// ง่ายที่สุด! maxWidth เป็นตัวเลือก
ThaiLineBreakText(
  'สวัสดีชาวไทยยินดีต้อนรับ',
  style: TextStyle(fontSize: 16),
  // maxWidth เป็นตัวเลือก - ถ้าไม่ระบุจะใช้ความกว้างของ parent widget
)
```

### 2️⃣ ตัดคำภาษาไทยเป็นรายคำ

```dart
final segmenter = ThaiTextSegmenter();
List<String> words = segmenter.segment('สวัสดีชาวไทย');
// ผลลัพธ์: ['สวัสดี', 'ชาว', 'ไทย']
```

### 3️⃣ นับจำนวนคำและพยางค์

```dart
final controller = ThaiTextEditingController();
controller.text = 'สวัสดีชาวไทย';

print('คำ: ${controller.getWordCount()}');          // 3
print('พยางค์: ${controller.getSyllableCount()}');  // 4
```

### 4️⃣ ข้อความไทยที่มีสีต่างกัน

```dart
ThaiSegmentedText(
  'สวัสดี ชาวไทย',
  defaultStyle: TextStyle(fontSize: 16),
  wordStyles: {
    'สวัสดี': TextStyle(color: Colors.red),
    'ชาวไทย': TextStyle(color: Colors.blue),
  },
  maxWidth: 300,
)
```

### 5️⃣ ใช้ใน TextField ปกติ

```dart
final controller = ThaiTextEditingController();

TextField(
  controller: controller,
  onChanged: (text) {
    setState(() {});  // อัปเดต UI
  },
)

// แสดงข้อมูลสถิติ
Text('${controller.getWordCount()} คำ')
```

---

## 🎯 Widgets ที่พร้อมใช้

| Widget | ประโยชน์ | ตัวอย่าง |
|--------|---------|--------|
| **ThaiLineBreakText** | ข้อความพร้อมขึ้นบรรทัดอัตโนมัติ | `ThaiLineBreakText('สวัสดี', maxWidth: 300)` |
| **ThaiSegmentedText** | ข้อความที่มีสีต่างกัน | `ThaiSegmentedText('สวัสดี', wordStyles: {...})` |
| **ThaiRichText** | ข้อความจัดรูปแบบ | `ThaiRichText([...])` |

---

## 🔧 วิธีการทำงานหลัก

### ThaiTextSegmenter - ตัดคำ

```dart
final segmenter = ThaiTextSegmenter();

// ตัดคำ
segmenter.segment('สวัสดีชาวไทย')
  // → ['สวัสดี', 'ชาว', 'ไทย']

// จัดกลุ่มพยางค์
segmenter.groupBySyllables('สวัสดี')
  // → ['สวัสดี']

// ตรวจสอบประเภท
ThaiTextSegmenter.isThaiCharacter('ก')  // → true
ThaiTextSegmenter.isThaiConsonant('ค')   // → true
ThaiTextSegmenter.isThaiDiacritic('่')   // → true
```

### ThaiLineBreaker - ขึ้นบรรทัด

```dart
final breaker = ThaiLineBreaker();

// ขึ้นบรรทัดวิธีที่ 1: แบบพื้นฐาน
breaker.breakLines(text, textStyle: style, maxWidth: 200)

// ขึ้นบรรทัดวิธีที่ 2: แบบเข้าใจไทย (ดีกว่า)
breaker.breakLinesThaiAware(text, textStyle: style, maxWidth: 200)

// ขึ้นบรรทัดวิธีที่ 3: พร้อมข้อมูล
breaker.breakLinesWithInfo(text, textStyle: style, maxWidth: 200)
  // → [LineBreakInfo, LineBreakInfo, ...]
```

### ThaiTextEditingController - ควบคุม

```dart
final controller = ThaiTextEditingController();

controller.getSegments()         // → List<String>
controller.getWordCount()        // → int
controller.getSyllableCount()    // → int
controller.getLines(...)         // → List<String>
```

---

## 📊 ตัวอย่างแอปพลิเคชัน

### หน้าแสดงผล: บทความ

```dart
Scaffold(
  appBar: AppBar(title: Text('บทความ')),
  body: Padding(
    padding: EdgeInsets.all(16),
    child: ThaiLineBreakText(
      articleText,
      style: TextStyle(fontSize: 16, height: 1.5),
      maxWidth: MediaQuery.of(context).size.width - 32,
    ),
  ),
)
```

### หน้าแสดงผล: หนังสือ

```dart
Column(
  children: [
    Text('บท 1: บทนำ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    SizedBox(height: 16),
    ThaiLineBreakText(
      chapterText,
      style: TextStyle(fontSize: 14),
      maxWidth: MediaQuery.of(context).size.width - 32,
    ),
  ],
)
```

### หน้าแรก: ชื่อปลั๊กอิน

```dart
ThaiSegmentedText(
  'ไทย ตัดคำ และ ขึ้นบรรทัด',
  defaultStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  wordStyles: {
    'ไทย': TextStyle(color: Colors.red),
    'ตัดคำ': TextStyle(color: Colors.blue),
    'ขึ้นบรรทัด': TextStyle(color: Colors.green),
  },
  maxWidth: 300,
)
```

---

## ✅ เช็คลิสต์การใช้งาน

### ก่อนเริ่มต้น
- [ ] ติดตั้งปลั๊กอิน
- [ ] Import ปลั๊กอิน
- [ ] เตรียมข้อความไทย

### เลือกวิธีการ
- [ ] ใช้ widget พร้อม ใช้ `ThaiLineBreakText`
- [ ] ตัดคำเอง ใช้ `ThaiTextSegmenter`
- [ ] ต้องการข้อมูล ใช้ `ThaiLineBreaker`

### สำหรับ TextField
- [ ] ใช้ `ThaiTextEditingController`
- [ ] เรียก `controller.getWordCount()`
- [ ] เรียก `controller.getSegments()`

---

## ⚠️ 3 ข้อเตือน

### 1. ทำให้ maxWidth เป็นตัวเลือก

```dart
// วิธีที่ 1: ไม่ระบุ maxWidth (ใช้ความกว้างของ parent widget)
// ✅ ง่ายที่สุด!
ThaiLineBreakText(
  text,
  style: TextStyle(fontSize: 16),
)

// วิธีที่ 2: ระบุ maxWidth ถ้าต้องการการควบคุมที่แน่นอน
// ✅ ถูก
ThaiLineBreakText(
  text,
  style: TextStyle(fontSize: 16),
  maxWidth: MediaQuery.of(context).size.width - 32,
)
```

### 2. ใช้ Thai-Aware Breaking

```dart
// ❌ ผิด
breaker.breakLines(text, ...)

// ✅ ถูก
breaker.breakLinesThaiAware(text, ...)
```

### 3. ตรวจสอบฟอนต์รองรับไทย

```dart
// ตรวจสอบว่าฟอนต์รองรับไทย
// ถ้าไม่รองรับ ข้อความจะแสดงเป็น ???

TextStyle(
  fontFamily: 'NotoSansThai',  // ตรวจสอบว่าติดตั้งเรียบร้อย
  fontSize: 16,
)
```

---

## 🆘 เมื่อมีปัญหา

### ข้อความไม่แสดง

```dart
// 1. ตรวจสอบ import
import 'package:thai_word_segmentation/thai_word_segmentation.dart';

// 2. ตรวจสอบ maxWidth
ThaiLineBreakText(text, maxWidth: 300)

// 3. ตรวจสอบฟอนต์
TextStyle(fontFamily: 'NotoSansThai')
```

### ตัดคำไม่ถูก

```dart
// แน่ใจว่าข้อความเป็นภาษาไทยจริง
String text = 'สวัสดี';  // ✓ ภาษาไทย
// String text = 's w s d i';  // ✗ ไม่ใช่ภาษาไทย
```

### ขึ้นบรรทัดผิด

```dart
// ใช้ Thai-Aware Breaking
breaker.breakLinesThaiAware(text, 
  textStyle: style,
  maxWidth: width,
)
```

---

## 📚 เอกสารเพิ่มเติม

- 📖 [คู่มือละเอียด (ภาษาไทย)](./USAGE_GUIDE_TH.md)
- 📖 [Comprehensive Guide (English)](./USAGE_GUIDE.md)
- 📘 [Full API Reference](./README.md)
- 💻 [ตัวอย่างแอป](./example/main.dart)

---

## 🎉 เสร็จแล้ว!

คุณพร้อมใช้งาน `thai_word_segmentation` แล้ว!

**คำแนะนำ:** เริ่มด้วย `ThaiLineBreakText` ก่อน เป็นวิธีที่ง่ายที่สุด

---

**Happy Coding! 🚀**
