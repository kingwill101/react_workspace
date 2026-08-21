import type {ReactNode} from 'react';
import Link from '@docusaurus/Link';
import Layout from '@theme/Layout';

import styles from './index.module.css';

const runtimeLayers = [
  ['01', 'Author in Dart', 'Typed components, familiar hooks, host elements, and composable props.', 'react + react_dom'],
  ['02', 'Compile both ways', 'One component tree becomes a browser bundle and a Node SSR worker.', 'react_tool build'],
  ['03', 'Serve your way', 'Bring the generated runtime to Routed or Shelf through focused adapters.', 'server adapters'],
];

const packages = [
  ['react', 'Portable tree + hooks'],
  ['react_dom', 'Typed host elements'],
  ['react_web', 'Portable Web APIs'],
  ['react_server', 'SSR runtime'],
  ['react_tool', 'Build + scaffolding'],
  ['react_testing', 'Native test harnesses'],
];

function CodeWindow(): ReactNode {
  return (
    <div className={styles.codeWindow} aria-label="React Dart component example">
      <div className={styles.windowBar}>
        <span className={styles.windowDots} aria-hidden="true"><i /><i /><i /></span>
        <span>lib/app.dart</span>
        <span className={styles.liveLabel}>portable</span>
      </div>
      <pre className={styles.code}><code>
        <span className={styles.codeMuted}>@reactComponent</span>{'\n'}
        <span className={styles.codeType}>ReactNode</span>{' '}
        <span className={styles.codeFn}>Counter</span>{'(({String title}) props) {\n'}
        {'  final (count, setCount) = '}<span className={styles.codeFn}>useState</span>{'(0);\n\n'}
        {'  return '}<span className={styles.codeFn}>button</span>{'(\n'}
        {'    className: '}<span className={styles.codeFn}>classNames</span>{"('counter', {\n"}
        {"      'counter--active': count > 0,\n"}{'    }),\n'}
        {'    style: '}<span className={styles.codeFn}>css</span>{'(padding: 16, borderRadius: 8),\n'}
        {'    onClick: (_) => setCount(count + 1),\n'}
        {"    children: ['${props.title}: $count'],\n"}{'  );\n}'}
      </code></pre>
      <div className={styles.compilerBar}>
        <span className={styles.compilerPulse} /> browser.js
        <span className={styles.compilerArrow}>+</span> ssr.js
        <span className={styles.compilerOk}>ready</span>
      </div>
    </div>
  );
}

function Hero(): ReactNode {
  return (
    <header className={styles.hero}>
      <div className={styles.heroGrid} aria-hidden="true" />
      <div className={styles.heroOrbit} aria-hidden="true"><span /><span /><span /></div>
      <div className={`container ${styles.heroInner}`}>
        <div className={styles.heroCopy}>
          <div className={styles.eyebrow}>
            <span>React runtime for Dart</span><span className={styles.eyebrowRule} /><span>SSR / browser / server</span>
          </div>
          <h1>One language.<br /><em>Every side</em> of React.</h1>
          <p className={styles.heroLead}>
            Build typed React interfaces in Dart, render them on the server,
            hydrate them in the browser, and call backend functions without
            hand-writing the transport layer.
          </p>
          <div className={styles.heroActions}>
            <Link className={styles.primaryAction} to="/docs/getting-started/quick-start">Start building <span>↗</span></Link>
            <Link className={styles.secondaryAction} to="/docs/reference/cli">Explore the CLI</Link>
          </div>
          <div className={styles.heroFacts}>
            <span><strong>01</strong> portable components</span>
            <span><strong>02</strong> typed boundaries</span>
            <span><strong>03</strong> native testing</span>
          </div>
        </div>
        <div className={styles.heroCode}>
          <div className={styles.codeCaption}>THE SAME TREE, TWICE EXECUTED</div>
          <CodeWindow />
        </div>
      </div>
    </header>
  );
}

function Ergonomics(): ReactNode {
  return (
    <section className={styles.ergonomics} id="ergonomics">
      <div className="container">
        <div className={styles.sectionHeading}>
          <p>Designed for daily use</p>
          <h2>Typed where it matters.<br />Fluid where it helps.</h2>
          <span>The low-level AST stays portable. The authoring surface stays concise—even when the DOM API is large.</span>
        </div>
        <div className={styles.ergoGrid}>
          <article className={`${styles.ergoCard} ${styles.ergoPrimary}`}>
            <div className={styles.cardNumber}>A</div>
            <h3>Generated host factories</h3>
            <p>HTML and SVG elements arrive as typed Dart functions with typed events, refs, accessibility props, and escape hatches.</p>
            <pre><code>{`button(
  disabled: saving,
  onClick: (_) => save(),
  children: ['Save'],
)`}</code></pre>
          </article>
          <article className={styles.ergoCard}>
            <div className={styles.cardNumber}>B</div>
            <h3>Composable prop helpers</h3>
            <p>Build React-safe styles and conditional class names without dropping into stringly-typed host nodes.</p>
            <pre><code>{`style: css(
  display: 'flex',
  gap: 12,
)..custom('--accent', color)`}</code></pre>
          </article>
          <article className={styles.ergoCard}>
            <div className={styles.cardNumber}>C</div>
            <h3>Fluent builders when useful</h3>
            <p>Generated component and element factories expose a builder path for cascades, reuse, and OverReact-style composition.</p>
            <pre><code>{`final props = buttonProps()
  ..className = 'primary'
  ..disabled = saving;

return props(['Ship it']);`}</code></pre>
          </article>
          <article className={`${styles.ergoCard} ${styles.ergoSignal}`}>
            <div className={styles.cardNumber}>D</div>
            <h3>One import, portable output</h3>
            <p>Author against <code>package:react_dom</code>. Generated shims preserve the right shapes for browser execution and SSR.</p>
            <Link to="/docs/guides/component-ergonomics">Read the authoring guide <span>→</span></Link>
          </article>
        </div>
      </div>
    </section>
  );
}

function RuntimePipeline(): ReactNode {
  return (
    <section className={styles.pipeline} id="runtime">
      <div className="container">
        <div className={styles.pipelineTop}>
          <div><p className={styles.kicker}>A complete runtime, not a UI wrapper</p><h2>From component to response.</h2></div>
          <p>Framework-neutral pieces sit at the center; explicit integrations live at the edge. Choose your server without dragging every adapter into core.</p>
        </div>
        <div className={styles.runtimeTrack}>
          {runtimeLayers.map(([index, title, copy, signal], position) => (
            <div className={styles.runtimeStep} key={index}>
              <div className={styles.stepMarker}><span>{index}</span></div>
              <div className={styles.stepBody}><span className={styles.stepSignal}>{signal}</span><h3>{title}</h3><p>{copy}</p></div>
              {position < runtimeLayers.length - 1 && <span className={styles.trackArrow}>→</span>}
            </div>
          ))}
        </div>
        <div className={styles.commandStrip}>
          <span className={styles.prompt}>$</span><code>dart run react_tool:react serve</code>
          <span className={styles.commandResult}>SSR worker :3001</span><span className={styles.commandResult}>Engine :8080</span>
        </div>
      </div>
    </section>
  );
}

function Interop(): ReactNode {
  return (
    <section className={styles.interop} id="interop">
      <div className={`container ${styles.interopInner}`}>
        <div className={styles.interopVisual} aria-hidden="true">
          <span className={styles.tsTile}>TS</span><span className={styles.bridgeLine} /><span className={styles.dartTile}>DART</span>
          <span className={styles.shimLabel}>generated shim</span>
        </div>
        <div className={styles.interopCopy}>
          <p className={styles.kicker}>Use the JavaScript ecosystem</p>
          <h2>Wrap once.<br />Keep the types.</h2>
          <p>Point the CLI at TypeScript declarations and generate the Dart binding, runtime shim, and package metadata. Keep a custom facade only where the JavaScript API deserves one—like the Zustand wrapper.</p>
          <div className={styles.interopActions}>
            <Link to="/docs/guides/wrapper-packages">Build a wrapper package <span>↗</span></Link>
            <Link to="/docs/guides/foreign-components">Use foreign components</Link>
          </div>
        </div>
      </div>
    </section>
  );
}

function PackageMap(): ReactNode {
  return (
    <section className={styles.packageSection} id="packages">
      <div className="container">
        <div className={styles.packageHeading}>
          <div><p className={styles.kicker}>A layered workspace</p><h2>Take the pieces you need.</h2></div>
          <Link to="/docs/intro">View the architecture <span>→</span></Link>
        </div>
        <div className={styles.packageGrid}>
          {packages.map(([name, copy]) => (
            <Link className={styles.packageCard} to="/docs/reference/api" key={name}>
              <span className={styles.packageGlyph}>{name.slice(0, 2)}</span>
              <span><strong>{name}</strong><small>{copy}</small></span><i>↗</i>
            </Link>
          ))}
        </div>
      </div>
    </section>
  );
}

function FinalCallout(): ReactNode {
  return (
    <section className={styles.finalCallout}>
      <div className="container">
        <div className={styles.finalInner}>
          <div><span>READY / SET / RENDER</span><h2>Start with the app.<br />Reveal the machinery when you need it.</h2></div>
          <div className={styles.finalAction}>
            <code>dart run react_tool:react init my_app --template routed</code>
            <Link to="/docs/getting-started/quick-start">Open quick start <span>→</span></Link>
          </div>
        </div>
      </div>
    </section>
  );
}

export default function Home(): ReactNode {
  return (
    <Layout title="Typed React applications in Dart" description="Build typed React applications in Dart with SSR, server functions, generated Web APIs, and JavaScript package interop.">
      <main className={styles.main}><Hero /><Ergonomics /><RuntimePipeline /><Interop /><PackageMap /><FinalCallout /></main>
    </Layout>
  );
}
