# การติดตั้ง Thai Word Segmentation Plugin

## 🔗 ติดตั้งผ่าน Git

### วิธีท่ี 1: จากเนื้อหา URL git (ข้อราคี master branch)

หากเก็บโค้ดไว้ใน GitLab, GitHub, หรือ git repository อื่นๆ:

```yaml
# pubspec.yaml
dependencies:
  thai_word_segmentation:
    git:
      url: https://github.com/KhunBaw/thai_word_segmentation_flutter.git
```

จากนั้นรัน:

```bash
flutter pub get
```

### วิธีที่ 2: จากเนื้อหา URL git + Branch เฉพาะ

หากต้องการดึง code จาก branch เฉพาะ:

```yaml
# pubspec.yaml
dependencies:
  thai_word_segmentation:
    git:
      url: https://github.com/KhunBaw/thai_word_segmentation_flutter.git
      ref: develop  # ชื่อ branch
```

### วิธีที่ 3: จากเนื้อหา URL git + Tag เรียน

หากต้องการดึง code จาก tag เฉพาะ:

```yaml
# pubspec.yaml
dependencies:
  thai_word_segmentation:
    git:
      url: https://github.com/KhunBaw/thai_word_segmentation_flutter.git
      ref: v0.0.1  # ชื่อ tag
```

### วิธีที่ 4: จากเนื้อหา URL git + Commit SHA

หากต้องการดึง code จาก commit เฉพาะ:

```yaml
# pubspec.yaml
dependencies:
  thai_word_segmentation:
    git:
      url: https://github.com/KhunBaw/thai_word_segmentation_flutter.git
      ref: abc123def456  # commit hash (อย่างน้อย 40 ตัวอักษร)
```

---

## 📍 Repository URLs

### GitLab

```yaml
dependencies:
  thai_word_segmentation:
    git:
      url: https://github.com/KhunBaw/thai_word_segmentation_flutter.git
```

### GitHub

```yaml
dependencies:
  thai_word_segmentation:
    git:
      url: https://github.com/your-username/thai_word_segmentation.git
```

### Bitbucket

```yaml
dependencies:
  thai_word_segmentation:
    git:
      url: https://bitbucket.org/your-username/thai_word_segmentation.git
```

### Private Repository (requires SSH key)

```yaml
dependencies:
  thai_word_segmentation:
    git:
      url: git@gitlab.com:your-username/thai_word_segmentation.git
```

---

## 📁 ติดตั้งจากเส้นทางในเครื่อง (Local Path)

หากไฟล์อยู่บนเครื่องคอมพิวเตอร์เดียวกัน:

### วิธีที่ 1: Absolute Path

```yaml
# pubspec.yaml
dependencies:
  thai_word_segmentation:
    path: /Users/username/Documents/git/gitlab/thai_word_segmentation
```

### วิธีที่ 2: Relative Path (แนะนำ)

ถ้า plugin folder อยู่นอก project folder:

```yaml
# pubspec.yaml
dependencies:
  thai_word_segmentation:
    path: ../thai_word_segmentation
```

ถ้า plugin folder อยู่ใน project folder:

```yaml
# pubspec.yaml
dependencies:
  thai_word_segmentation:
    path: ./packages/thai_word_segmentation
```

---

## ⚙️ SSH vs HTTPS

### HTTPS (ค่าเริ่มต้น - แนะนำสำหรับผู้เริ่มต้น)

```yaml
dependencies:
  thai_word_segmentation:
    git:
      url: https://github.com/KhunBaw/thai_word_segmentation_flutter.git
```

**ข้อดี:**
- ไม่ต้องตั้งค่า SSH key
- ใช้ username + password (หรือ personal access token)
- สำหรับ public repository ไม่ต้องการข้อมูลไม่มี

**ข้อด้อย:**
- ต้องป้อน credentials ที่กำหรับ private repository
- ช้ากว่า SSH เล็กน้อย

### SSH (สำหรับ advanced users)

```yaml
dependencies:
  thai_word_segmentation:
    git:
      url: git@gitlab.com:your-username/thai_word_segmentation.git
```

**ข้อดี:**
- ปลอดภัยกว่า
- เร็วกว่า
- เหมาะสำหรับ automation/CI-CD

**ข้อด้อย:**
- ต้องตั้งค่า SSH keys
- ซับซ้อนกว่า

---

## 🔐 Personal Access Token (สำหรับ Private Repository)

### GitLab

```yaml
dependencies:
  thai_word_segmentation:
    git:
      url: https://oauth2:YOUR_ACCESS_TOKEN@gitlab.com/your-username/thai_word_segmentation.git
```

### GitHub

```yaml
dependencies:
  thai_word_segmentation:
    git:
      url: https://YOUR_USERNAME:YOUR_ACCESS_TOKEN@github.com/your-username/thai_word_segmentation.git
```

---

## 📥 ตัวอย่าง pubspec.yaml แบบเต็ม

### ใช้จาก Git

```yaml
name: my_app
description: My Thai application

environment:
  sdk: ^3.10.7
  flutter: ">=1.17.0"

dependencies:
  flutter:
    sdk: flutter
  thai_word_segmentation:
    git:
      url: https://github.com/KhunBaw/thai_word_segmentation_flutter.git
      ref: main  # optional

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
```

### ใช้จากเส้นทางในเครื่อง

```yaml
name: my_app
description: My Thai application

environment:
  sdk: ^3.10.7
  flutter: ">=1.17.0"

dependencies:
  flutter:
    sdk: flutter
  thai_word_segmentation:
    path: ../thai_word_segmentation

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
```

---

## 🚀 ขั้นตอนการติดตั้ง

### ขั้นที่ 1: แก้ไข pubspec.yaml

เพิ่มปลั๊กอินลงในส่วน `dependencies`:

```bash
# ใน project folder
nano pubspec.yaml
# หรือ
code pubspec.yaml
```

### ขั้นที่ 2: รัน pub get

```bash
cd your_project
flutter pub get
```

หรือ:

```bash
flutter pub get
```

### ขั้นที่ 3: Import ปลั๊กอิน

```dart
import 'package:thai_word_segmentation/thai_word_segmentation.dart';
```

### ขั้นที่ 4: เริ่มใช้งาน

```dart
final segmenter = ThaiTextSegmenter();
List<String> words = segmenter.segment('สวัสดีชาวไทย');
print(words);  // ['สวัสดี', 'ชาว', 'ไทย']
```

---

## 🔄 อัปเดตปลั๊กอิน

### จาก Git

```bash
flutter pub get  # Updates to latest from specified branch/tag
```

หรือ:

```bash
flutter pub upgrade thai_word_segmentation
```

### จากเส้นทางในเครื่อง

การเปลี่ยนแปลงในโฟลเดอร์ plugin จะสะท้อนอัตโนมัติ ไม่จำเป็นต้อง pub get อีกครั้ง

---

## ❌ แก้ไขปัญหา

### ปัญหา: "Permission denied" หรือ "Host key verification failed"

**เหตุ:** ใช้ SSH แต่ยังไม่ตั้งค่า SSH keys

**วิธีแก้:**
1. ใช้ HTTPS แทน SSH
2. หรือตั้งค่า SSH keys:
   ```bash
   ssh-keygen -t rsa -b 4096
   ssh-add ~/.ssh/id_rsa
   ```

### ปัญหา: "Could not find a version that matches"

**เหตุ:** Git URL ผิด หรือ branch/tag ไม่มีอยู่

**วิธีแก้:**
1. ตรวจสอบ URL ให้ถูกต้อง
2. ตรวจสอบชื่อ branch/tag
3. ตรวจสอบ credentials สำหรับ private repository

### ปัญหา: "Timeout"

**เหตุ:** เชื่อมต่ออินเทอร์เน็ตช้า

**วิธีแก้:**
```bash
flutter pub get --verbose
```

---

## 📝 ตัวอย่างการจัดเก็บ

### โครงสร้าง Monorepo (หลายปลั๊กอิน)

```
project-root/
├── packages/
│   ├── thai_word_segmentation/
│   ├── other_plugin_1/
│   └── other_plugin_2/
├── app/
│   ├── pubspec.yaml
│   └── lib/
└── README.md
```

การตั้งค่า:
```yaml
# app/pubspec.yaml
dependencies:
  thai_word_segmentation:
    path: ../packages/thai_word_segmentation
  other_plugin_1:
    path: ../packages/other_plugin_1
```

---

## 🎯 ข้อแนะนำ

### สำหรับ Development

ใช้ local path:
```yaml
dependencies:
  thai_word_segmentation:
    path: ../thai_word_segmentation
```

### สำหรับ Production

ใช้ Git tag:
```yaml
dependencies:
  thai_word_segmentation:
    git:
      url: https://github.com/KhunBaw/thai_word_segmentation_flutter.git
      ref: v0.0.1
```

### สำหรับ Testing

ใช้ Git branch:
```yaml
dependencies:
  thai_word_segmentation:
    git:
      url: https://github.com/KhunBaw/thai_word_segmentation_flutter.git
      ref: develop
```

---

## 📚 ข้อมูลเพิ่มเติม

- [Pub.dev Dependencies Documentation](https://dart.dev/tools/pub/pubspec)
- [Git Dependencies in Pub](https://dart.dev/tools/pub/dependencies#git)
- [Flutter Package Guide](https://flutter.dev/packages-and-plugins/using-packages)

---

**สำเร็จ! ✅ ตอนนี้คุณพร้อมใช้งาน Thai Word Segmentation Plugin แล้ว**
