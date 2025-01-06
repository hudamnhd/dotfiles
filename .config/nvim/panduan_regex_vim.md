# Panduan Regex di Vim/Neovim

## Karakter Spesial

- `.` : Mewakili karakter tunggal apa saja kecuali newline.
- `\d` : Mewakili digit (angka), sama dengan `[0-9]`.
- `\w` : Mewakili karakter kata (huruf, angka, dan underscore), sama dengan `[a-zA-Z0-9_]`.
- `\s` : Mewakili karakter spasi (termasuk tab dan newline).

## Penambahan dan Pengulangan

- `*` : Mewakili nol atau lebih dari karakter sebelumnya.
- `+` : Mewakili satu atau lebih dari karakter sebelumnya.
- `?` : Mewakili nol atau satu dari karakter sebelumnya.
- `{n}` : Mewakili tepat `n` kali karakter sebelumnya.
- `{n,}` : Mewakili setidaknya `n` kali karakter sebelumnya.
- `{n,m}` : Mewakili antara `n` dan `m` kali karakter sebelumnya.

## Grup dan Alternasi

- `(abc)` : Grup tangkap yang menyimpan teks yang cocok dengan pola `abc`.
- `|` : Alternasi atau "or", seperti `abc|def` yang cocok dengan `abc` atau `def`.

## Anchor

- `^` : Anchors ke awal baris.
- `$` : Anchors ke akhir baris.
- `\b` : Batas kata.
- `\B` : Tidak pada batas kata.

## Contoh Pola Regex Beserta Penjelasan

1. **Mencari Kata yang Dimulai dengan Huruf Besar:**

   ```vim
   /\v\<[A-Z]\w*\>
   ```

   - `\<` : Awal kata.
   - `[A-Z]` : Huruf kapital.
   - `\w*` : Nol atau lebih karakter kata.
   - `\>` : Akhir kata.

2. **Mengganti Semua Angka dengan `#`:**

   ```vim
   :%s/\v\d+/#/g
   ```

   - `\v` : Very magic mode.
   - `\d+` : Satu atau lebih digit.
   - `#` : Teks pengganti.

3. **Mengganti Spasi Ganda dengan Spasi Tunggal:**

   ```vim
   :%s/\v\s+/ /g
   ```

   - `\v` : Very magic mode.
   - `\s+` : Satu atau lebih karakter spasi.
   - ` ` : Spasi tunggal.

4. **Menemukan Kalimat yang Dimulai dengan Kata "The":**

   ```vim
   /\v^The\s.*
   ```

   - `\v` : Very magic mode.
   - `^The` : "The" di awal baris.
   - `\s` : Spasi.
   - `.*` : Nol atau lebih karakter apa saja.

5. **Menemukan Kata yang Diapit oleh Kurung:**

   ```vim
   /\v\(\w+\)
   ```

   - `\v` : Very magic mode.
   - `\(` : Kurung buka literal.
   - `\w+` : Satu atau lebih karakter kata.
   - `\)` : Kurung tutup literal.

6. **Mencari atau Mengganti Semua Huruf Kecil:**

   ```vim
   /\v[a-z]+
   ```

   - `\v` : Very magic mode.
   - `[a-z]+` : Satu atau lebih huruf kecil.

7. **Mencari atau Mengganti Semua Huruf Besar:**

   ```vim
   /\v[A-Z]+
   ```

   - `\v` : Very magic mode.
   - `[A-Z]+` : Satu atau lebih huruf besar.

8. **Mencari atau Mengganti Kombinasi Huruf dan Angka:**

   ```vim
   /\v\w+
   ```

   - `\v` : Very magic mode.
   - `\w+` : Satu atau lebih karakter kata (huruf, angka, dan underscore).

9. **Mencari atau Mengganti Semua Teks dalam Tanda Kutip:**

   ```vim
   /\v".*"
   ```

   - `\v` : Very magic mode.
   - `".*"` : Teks di dalam tanda kutip ganda.

10. **Mencari atau Mengganti Email:**

    ```vim
    /\v[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}
    ```

    - `\v` : Very magic mode.
    - `[a-zA-Z0-9._%+-]+` : Satu atau lebih karakter kata, angka, atau simbol umum dalam email.
    - `@` : Simbol at.
    - `[a-zA-Z0-9.-]+` : Satu atau lebih karakter kata, angka, titik, atau tanda hubung.
    - `\.` : Titik literal.
    - `[a-zA-Z]{2,4}` : Dua hingga empat huruf (domain tingkat atas).

Dengan pola-pola regex ini, Anda dapat melakukan pencarian dan penggantian teks yang kompleks dengan lebih efisien di Vim atau Neovim.

---

# Panduan Belajar Regex di Neovim

Berikut adalah beberapa konsep dasar regex yang sering digunakan di Neovim untuk mengganti teks dengan cara yang lebih fleksibel dan powerful.

### 1. **Batas Kata: `\<` dan `\>`**

- **`\`\<**: Menandakan awal kata.
- **`\`>`**: Menandakan akhir kata.

**Contoh**:

- `:s/\<Select\>/Replaced/g`  
  Mengganti kata `Select` yang berdiri sendiri, bukan bagian dari kata lain seperti `Selected`.

---

### 2. **Titik (`.`)**

- Mewakili **satu karakter apapun**, kecuali newline.

**Contoh**:

- `:s/a.c/xyz/g`  
  Mengganti kata yang dimulai dengan `a`, diikuti satu karakter apapun, dan diakhiri dengan `c`, seperti `abc`, `axc`, dll.

---

### 3. **Bintang (`*`)**

- **`*`** cocok dengan **nol atau lebih karakter** dari elemen sebelumnya.

**Contoh**:

- `:s/a.*c/xyz/g`  
  Mengganti kata yang dimulai dengan `a`, diikuti oleh nol atau lebih karakter apapun, dan diakhiri dengan `c`, seperti `ac`, `abc`, `axxxc`, dll.

---

### 4. **Plus (`+`)**

- **`+`** cocok dengan **satu atau lebih karakter** dari elemen sebelumnya (harus ada minimal satu karakter).

**Contoh**:

- `:s/a.+c/xyz/g`  
  Mengganti kata yang dimulai dengan `a`, diikuti oleh satu atau lebih karakter apapun, dan diakhiri dengan `c`.

---

### 5. **Tanda Tanya (`?`)**

- **`?`** cocok dengan **nol atau satu karakter** dari elemen sebelumnya.

**Contoh**:

- `:s/a?b/xyz/g`  
  Mengganti kata `b` atau `ab` menjadi `xyz`.

---

### 6. **Karakter Pilihan (`[]`)**

- **`[]`** digunakan untuk mencocokkan **salah satu karakter** di dalam tanda kurung.

**Contoh**:

- `:s/a[bcd]e/xyz/g`  
  Mengganti `abe`, `ace`, atau `ade` menjadi `xyz`.

---

### 7. **Karakter Negasi (`[^]`)**

- **`[^]`** mencocokkan karakter **apa saja kecuali** yang ada di dalam tanda kurung.

**Contoh**:

- `:s/a[^b]*e/xyz/g`  
  Mengganti kata yang dimulai dengan `a`, diikuti oleh karakter apapun kecuali `b`, dan diakhiri dengan `e`.

---

### 8. **Grup dan Referensi Kembali (`\(...\)` dan `\1`, `\2`, ...)**

- **`\(...\)`** digunakan untuk membuat **grup** yang dapat dirujuk kembali.
- **`\1`, `\2`, dll** adalah referensi untuk grup pertama, kedua, dll.

**Contoh**:

- `:s/\(Select\)/\1Radix/g`  
  Mengganti `Select` dengan `SelectRadix`.

- `:s/\(abc\)\(123\)/\2\1/g`  
  Membalikkan urutan antara `abc` dan `123`, menjadi `123abc`.

---

### 9. **Menangkap Semua Karakter dalam Tanda Kurung (`\([^)]*\)`)**

- **`\([^)]*\)`** menangkap semua karakter di dalam tanda kurung `()`.

**Contoh**:

- `:s/(\([^)]*\))/\1Replaced/g`  
  Mengganti teks yang ada di dalam tanda kurung, seperti `Select(Item)` menjadi `ItemReplaced`.

---

### 10. **Awal dan Akhir Baris (`^` dan `$`)**

- **`^`** cocok dengan **awal baris**.
- **`$`** cocok dengan **akhir baris**.

**Contoh**:

- `:s/^Select/Begin/g`  
  Mengganti `Select` yang berada di awal baris menjadi `Begin`.

- `:s/End$/Finish/g`  
  Mengganti `End` yang berada di akhir baris menjadi `Finish`.

---

### 11. **Substitusi di Semua Baris (`%`)**

- **`%`** digunakan untuk mengganti di **seluruh file**.

**Contoh**:

- `:%s/Select/Modified/g`  
  Mengganti semua kata `Select` di seluruh file menjadi `Modified`.

---

### 12. **Menambahkan Teks dengan Grup Referensi**

- Menambahkan teks baru setelah kata yang cocok menggunakan grup referensi.

**Contoh**:

- `:s/\(Select\)\(Item\)/\1Radix\2/g`  
  Mengganti `SelectItem` menjadi `SelectRadixItem`.

---

### 13. **Substitusi di Baris Tertentu**

- Kamu bisa menentukan **baris tertentu** untuk mengganti teks, misalnya baris 3 sampai 5:

**Contoh**:

- `:3,5s/old/new/g`  
  Mengganti kata `old` dengan `new` hanya di baris 3 sampai 5.

---

### Kesimpulan

Dengan memahami dan menguasai pola-pola regex ini, kamu bisa melakukan pencarian dan penggantian yang lebih canggih di Neovim. Cobalah eksperimen dengan pola-pola ini dan lihat bagaimana fleksibilitas regex dapat membantu dalam pemrosesan teks.

---

Semoga panduan ini membantu! Jika ada pertanyaan lebih lanjut atau ingin menggali lebih dalam tentang regex, jangan ragu untuk bertanya!
