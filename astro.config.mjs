import { defineConfig } from 'astro/config';
import { astroFont } from 'astro-font/integration';

export default defineConfig({
  integrations: [astroFont()],
  site: 'https://dawiddroz.github.io',
  base: '/trattoria-dei-cacciatori-velletri',
  compressHTML: true,
  server: {
    allowedHosts: true,
  },
});
