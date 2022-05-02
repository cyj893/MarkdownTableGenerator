# Markdown Table Generator

|<img src="https://cyj893.github.io/img/Projects/2/readme/talbe_ex.PNG" title="home" alt="home" />|
| - |

- Example Result in Markdown:

    | head1	 | head2	 | head3	 |
    | :-- | :--: | --: |
    | body1<br>body111	 | ~~_**<ul><li>`body2`</li><li>`body22`</li><li>`body222`</li></ul>**_~~	 | body3	 |
    | body4	 | <ol><li>body5</li><li>body55</li></ol>	 | [body6](https://github.com/cyj893)   |

<br>

| **Now v0.1.2-beta abvailable [here](https://cyj893.github.io/markdown_table_generator/).** |
| - |

<br>

## Outline

### Features

> **Make Markdown Tables Easier**

- Decorate your text freely
- Put multi-lines and a list inside your table with HTML code
- Upload your CSV files and make table
- Copy & Paste tables from Excel, Word and Web

### Environment
- Flutter 2.8.1
- Dart 2.15.1

### Develop Period
2022/02/18 ~ 2022/03/09 (3 weeks)

### Package Dependencies
[desktop_drop](https://pub.dev/packages/desktop_drop): ^0.3.2  
[file_picker](https://pub.dev/packages/file_picker): ^4.5.0  
[cp949](https://pub.dev/packages/cp949): ^1.2.1  
[adaptive_scrollbar](https://pub.dev/packages/adaptive_scrollbar) ^2.1.2  

## Contents
### Menu

|<img src="https://cyj893.github.io/img/Projects/2/readme/menu.PNG" title="menu" alt="menu" />|
| - |

| Buttons	 | Content	 | In Markdown	 |
| :-- | :-- | :-- |
| **Add/Delete Row**	 | <ul><li>add row on top</li><li>add row below</li><li>delete row</li></ul>	 | 	 |
| **Add/Delete Column**	 | <ul><li>add column to the left</li><li>add column to the right</li><li>delete column</li></ul>	 | 	 |
| **Align**	 | <ul><li>left</li><li>center</li><li>right</li></ul>	 | <ul><li>`:--`</li><li>`:--:`</li><li>`--:`</li></ul>	 |
| **Text Deco / Link**	 | <ul><li>bold</li><li>italic</li><li>strikethrough</li><li>code</li><li>clear all deco</li><li>make link</li></ul>	 | <ul><li>`**bold**`</li><li>`_italic_`</li><li>`~~strikethrough~~`</li><li>``code``</li><li></li><li>`[make link](address)`</li></ul>	 |
| **Multiline**	 | <ul><li>no multiline</li><li>multiline</li><li>unordered listing</li><li>ordered listing</li></ul>	 | <ul><li></li><li>`<br>`</li><li>`<ul><li></li></ul>`</li><li>`<ol><li></li></ol>`</li></ul>	 |
| **Upload CSV**	 | upload *.csv file	 | 	 |
| **Clear**	 | clear table	 | 	 |

---

### Decorate your text freely

|<img src="https://cyj893.github.io/img/Projects/2/readme/text_deco.gif" title="text_deco" alt="text_deco" />|
| - |

- Make text **bold**, _italic_, ~~strikethrough~~, `code style`
- Can multi select by long press

---

### Put multi-lines and a list inside your table with HTML code

|<img src="https://cyj893.github.io/img/Projects/2/readme/listing.gif" title="listing" alt="listing" />|
| - |

- Put multi-lines by `<br>` tags
- Put a list by `<ul></ul>` or `<ol></ol>`

---

### Upload your CSV files and make table

|<img src="https://cyj893.github.io/img/Projects/2/readme/from_csv.gif" title="from_csv" alt="from_csv" />|
| - |

- Upload your \*.CSV files by drag & drop, or file explorer
    - Supporting `UTF-8`, `CP949` Encoding

---

### Copy & Paste tables from Excel, Word and Web

|<img src="https://cyj893.github.io/img/Projects/2/readme/from_web.gif" title="from_web" alt="from_web" />|
| - |

- Can copy & paste tables from Excel, Word and Web

---

## License
MarkdownTableGenerator is released under the [MIT License](http://www.opensource.org/licenses/mit-license).