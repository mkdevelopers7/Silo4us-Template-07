import io
from pathlib import Path

ROOT = Path(__file__).parent
INDEX = ROOT / 'index.html'

replacements = [
    ('https://www.equiduct.com/wp-content', '/wp-content'),
    ('https://www.equiduct.com/wp-includes', '/wp-includes'),
    ('http://www.equiduct.com/wp-content', '/wp-content'),
    ('http://www.equiduct.com/wp-includes', '/wp-includes'),
]

def main():
    txt = INDEX.read_text(encoding='utf-8')
    orig = txt
    total = 0
    for a, b in replacements:
        if a in txt:
            count = txt.count(a)
            txt = txt.replace(a, b)
            total += count
    if txt != orig:
        backup = INDEX.with_suffix('.html.bak')
        backup.write_text(orig, encoding='utf-8')
        INDEX.write_text(txt, encoding='utf-8')
        print(f'Updated {INDEX} — replaced {total} occurrences. Backup at {backup.name}')
    else:
        print('No replacements needed')

if __name__ == '__main__':
    main()
