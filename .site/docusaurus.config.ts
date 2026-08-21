import {themes as prismThemes} from 'prism-react-renderer';
import type {Config} from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';

const config: Config = {
  title: 'React Dart',
  tagline: 'Typed React applications in Dart.',
  favicon: 'img/favicon.ico',

  future: {
    v4: true,
  },

  url: 'https://react-dart.example.com',
  baseUrl: '/',

  organizationName: 'kingwill101',
  projectName: 'react_workspace',

  onBrokenLinks: 'throw',

  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  presets: [
    [
      'classic',
      {
        docs: {
          sidebarPath: './sidebars.ts',
          editUrl: 'https://github.com/kingwill101/react_workspace/edit/master/.site/docs/',
        },
        blog: {
          showReadingTime: true,
          feedOptions: {
            type: ['rss', 'atom'],
            xslt: true,
          },
          editUrl: 'https://github.com/kingwill101/react_workspace/edit/master/.site/blog/',
          onInlineTags: 'warn',
          onInlineAuthors: 'warn',
          onUntruncatedBlogPosts: 'warn',
        },
        theme: {
          customCss: './src/css/custom.css',
        },
      } satisfies Preset.Options,
    ],
  ],

  themeConfig: {
    colorMode: {
      respectPrefersColorScheme: true,
    },
    navbar: {
      title: 'React Dart',
      logo: {
        alt: 'React Dart Logo',
        src: 'img/logo.svg',
      },
      items: [
        {
          type: 'docSidebar',
          sidebarId: 'tutorialSidebar',
          position: 'left',
          label: 'Docs',
        },
        {
          to: '/docs/guides/wrapper-packages',
          label: 'Wrapper guide',
          position: 'left',
        },
        {
          to: '/docs/reference/cli',
          label: 'CLI',
          position: 'left',
        },
        {
          href: 'https://github.com/kingwill101/react_workspace',
          label: 'GitHub',
          position: 'right',
        },
      ],
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'Start',
          items: [
            {
              label: 'Quick start',
              to: '/docs/getting-started/quick-start',
            },
            {
              label: 'Project structure',
              to: '/docs/getting-started/project-structure',
            },
          ],
        },
        {
          title: 'Build',
          items: [
            {
              label: 'Server rendering',
              to: '/docs/guides/ssr',
            },
            {
              label: 'Server functions',
              to: '/docs/guides/server-functions',
            },
            {
              label: 'Wrapper packages',
              to: '/docs/guides/wrapper-packages',
            },
          ],
        },
        {
          title: 'Reference',
          items: [
            {
              label: 'CLI commands',
              to: '/docs/reference/cli',
            },
            {
              label: 'Configuration',
              to: '/docs/reference/react-yaml',
            },
            {
              label: 'GitHub',
              href: 'https://github.com/kingwill101/react_workspace',
            },
          ],
        },
      ],
      copyright: `React Dart / ${new Date().getFullYear()} / MIT licensed`,
    },
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
    },
  } satisfies Preset.ThemeConfig,
};

export default config;
