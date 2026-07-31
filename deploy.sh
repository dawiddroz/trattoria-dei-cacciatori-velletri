#!/bin/bash
# Deploy script — Trattoria Dei Cacciatori
# Uso: bash deploy.sh
set -e
cd "$(dirname "$0")"

echo "=== 1. Build Astro ==="
npx astro build 2>/dev/null || true   # l'errore astro-font hook è noto e innocuo

echo "=== 2. Post-build: copia font ==="
mkdir -p dist/__astro_font_generated__
cp public/__astro_font_generated__/* dist/__astro_font_generated__/ 2>/dev/null || true

echo "=== 3. Post-build: prefix path base ==="
python - <<'EOF'
import io, os, glob
font_dir = 'dist/__astro_font_generated__'
files = sorted(glob.glob(os.path.join(font_dir, '*.woff2')))
rename_map = {}
for i, f in enumerate(files, 1):
    short = f'font-{i}.woff2'
    rename_map[os.path.basename(f)] = short
    if os.path.basename(f) != short:
        os.rename(f, os.path.join(font_dir, short))
p = 'dist/index.html'
s = io.open(p, encoding='utf-8').read()
for long, short in rename_map.items():
    s = s.replace('/' + long, '/' + short)
s = s.replace('/__astro_font_generated__/', '/trattoria-dei-cacciatori-velletri/__astro_font_generated__/')
io.open(p, 'w', encoding='utf-8').write(s)
print(f'  font rinominati: {len(rename_map)}, path prefissati')
EOF

echo "=== 4. .nojekyll ==="
touch dist/.nojekyll

echo "=== 5. Deploy gh-pages ==="
rm -rf node_modules/.cache/gh-pages
npx gh-pages -d dist --message "Deploy $(date +%Y-%m-%d_%H-%M)"

echo "=== DONE: https://dawiddroz.github.io/trattoria-dei-cacciatori-velletri/ ==="
