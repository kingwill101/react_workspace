import type {SidebarsConfig} from '@docusaurus/plugin-content-docs';

const sidebars: SidebarsConfig = {
  tutorialSidebar: [
    'intro',
    {
      type: 'category',
      label: 'Getting Started',
      items: ['getting-started/quick-start', 'getting-started/project-structure'],
    },
    {
      type: 'category',
      label: 'Guides',
      items: [
        'guides/ssr',
        'guides/client-only',
        'guides/server-functions',
        'guides/component-ergonomics',
        'guides/styling',
        'guides/state-management',
        'guides/foreign-components',
        'guides/wrapper-packages',
        'guides/testing',
        'guides/deployment',
      ],
    },
    {
      type: 'category',
      label: 'Tutorials',
      items: [
        'tutorials/shadcn-components',
        'tutorials/custom-dart-hooks',
        'tutorials/server-actions',
      ],
    },
    {
      type: 'category',
      label: 'Reference',
      items: [
        'reference/react-yaml',
        'reference/cli',
        'reference/api',
      ],
    },
    {
      type: 'category',
      label: 'Comparison',
      items: ['comparison/ssr-gap-analysis'],
    },
    {
      type: 'category',
      label: 'Maintainers',
      items: ['maintainers/maintenance'],
    },
  ],
};

export default sidebars;
