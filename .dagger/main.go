// A reproducible validation environment for the React Dart workspace.
//
// Dagger owns the toolchain and operating-system dependencies. The same
// functions run from tool/ci.sh on a developer machine and in GitHub Actions.
package main

import (
	"context"
	"fmt"
	"strings"

	"dagger/react-workspace-ci/internal/dagger"
)

const (
	dartImage       = "dart:3.13.0"
	nodeImage       = "node:24.11.0-bookworm-slim"
	rustImage       = "rust:1.88.0-bookworm"
	workspaceDir    = "/workspace"
	pubCacheDir     = "/root/.pub-cache"
	npmCacheDir     = "/root/.npm"
	cargoCacheDir   = "/root/.cargo/registry"
	browserCacheDir = "/root/.server_testing"
)

type ReactWorkspaceCi struct{}

type validationStage struct {
	name      string
	container *dagger.Container
}

// All runs the complete local and remote CI contract, including a real
// headless Chromium hydration test through package:server_testing.
func (m *ReactWorkspaceCi) All(
	ctx context.Context,
	source *dagger.Directory,
) (string, error) {
	prepared := m.preparedContainer(source, true)
	stages := []validationStage{
		{name: "quality", container: m.qualityStage(prepared)},
		{name: "tests", container: m.testsStage(prepared)},
		{name: "documentation", container: m.docsStage(prepared)},
		{name: "browser", container: m.browserStage(prepared)},
	}

	var output strings.Builder
	for _, stage := range stages {
		stdout, err := stage.container.Stdout(ctx)
		if err != nil {
			return "", fmt.Errorf("%s validation failed: %w", stage.name, err)
		}
		fmt.Fprintf(&output, "%s:\n%s\n", stage.name, stdout)
	}
	return output.String(), nil
}

// Quality checks formatting, static analysis, and the generated Web surface.
func (m *ReactWorkspaceCi) Quality(
	ctx context.Context,
	source *dagger.Directory,
) (string, error) {
	return m.stageOutput(
		ctx,
		"quality",
		m.qualityStage(m.preparedContainer(source, false)),
	)
}

// Tests runs every Dart package and each example's native, non-browser tests.
func (m *ReactWorkspaceCi) Tests(
	ctx context.Context,
	source *dagger.Directory,
) (string, error) {
	return m.stageOutput(
		ctx,
		"tests",
		m.testsStage(m.preparedContainer(source, false)),
	)
}

// Docs verifies Dartdoc for every publishable package and builds the site.
func (m *ReactWorkspaceCi) Docs(
	ctx context.Context,
	source *dagger.Directory,
) (string, error) {
	return m.stageOutput(
		ctx,
		"documentation",
		m.docsStage(m.preparedContainer(source, false)),
	)
}

// Browser runs the maintained SSR example in system Chromium and proves that
// hydration, a client event, and a typed server function work together.
func (m *ReactWorkspaceCi) Browser(
	ctx context.Context,
	source *dagger.Directory,
) (string, error) {
	return m.stageOutput(
		ctx,
		"browser",
		m.browserStage(m.preparedContainer(source, true)),
	)
}

func (m *ReactWorkspaceCi) stageOutput(
	ctx context.Context,
	name string,
	container *dagger.Container,
) (string, error) {
	stdout, err := container.Stdout(ctx)
	if err != nil {
		return "", fmt.Errorf("%s validation failed: %w", name, err)
	}
	return stdout, nil
}

func (m *ReactWorkspaceCi) qualityStage(
	prepared *dagger.Container,
) *dagger.Container {
	return prepared.WithExec([]string{
		"bash",
		"-c",
		"set -euo pipefail\n" +
			"find packages examples tool/web_idl -type f -name '*.dart' " +
				"! -path '*/.dart_tool/*' " +
				"! -path 'packages/react_tool/lib/src/hook/react_tool_prebuilts.g.dart' " +
				"-print0 | xargs -0 dart format --output=none --set-exit-if-changed\n" +
			"dart analyze --fatal-infos\n" +
			"npm ci --prefix third_party/web/web_generator/lib/src --no-audit --no-fund\n" +
			"dart run tool/web_idl/verify.dart --strict\n",
	})
}

func (m *ReactWorkspaceCi) testsStage(
	prepared *dagger.Container,
) *dagger.Container {
	return prepared.WithExec([]string{
		"bash",
		"-c",
		"set -euo pipefail\n" +
			"for package in packages/*; do\n" +
			"  if [ -d \"$package/test\" ]; then\n" +
			"    echo \"==> dart test $package\"\n" +
			"    (cd \"$package\" && dart test)\n" +
			"  fi\n" +
			"done\n" +
			"for example in examples/client examples/plugin_validation examples/ssr examples/superdesk packages/react_server_routed/example; do\n" +
			"  mapfile -d '' tests < <(cd \"$example\" && find test -type f -name '*_test.dart' -not -path 'test/browser/*' -print0 | sort -z)\n" +
			"  if [ \"${#tests[@]}\" -gt 0 ]; then\n" +
			"    echo \"==> dart test $example (${#tests[@]} files)\"\n" +
			"    (cd \"$example\" && dart test \"${tests[@]}\")\n" +
			"  fi\n" +
			"done\n",
	})
}

func (m *ReactWorkspaceCi) docsStage(
	prepared *dagger.Container,
) *dagger.Container {
	return prepared.WithExec([]string{
		"bash",
		"-c",
		"set -euo pipefail\n" +
			"for package in packages/*; do\n" +
			"  [ -f \"$package/pubspec.yaml\" ] || continue\n" +
			"  echo \"==> dart doc --dry-run $package\"\n" +
			"  dart doc --dry-run \"$package\"\n" +
			"done\n" +
			"cd .site\n" +
			"npm ci --no-audit --no-fund\n" +
			"npm run typecheck\n" +
			"npm run build\n",
	})
}

func (m *ReactWorkspaceCi) browserStage(
	prepared *dagger.Container,
) *dagger.Container {
	return prepared.
		WithExec([]string{
			"bash",
			"-c",
			"set -euo pipefail\n" +
				"mkdir -p /root/.server_testing/drivers\n" +
				"cp \"$(command -v chromedriver)\" /root/.server_testing/drivers/chromedriver\n" +
				"chmod 0755 /root/.server_testing/drivers/chromedriver\n" +
				"chromium --version\n" +
				"chromedriver --version\n",
		}).
		WithEnvVariable("SERVER_TESTING_CHROMIUM_BINARY", "/usr/bin/chromium").
		WithEnvVariable("SERVER_TESTING_DISABLE_LOGS", "1").
		WithEnvVariable("REACT_TESTING_PREGENERATED", "true").
		WithExec([]string{
			"bash",
			"-c",
			"set -euo pipefail\n" +
				"cd examples/ssr\n" +
				"dart test test/browser/hydration_test.dart --reporter expanded\n",
		})
}

func (m *ReactWorkspaceCi) preparedContainer(
	source *dagger.Directory,
	withBrowser bool,
) *dagger.Container {
	node := dag.Container().From(nodeImage)
	rust := dag.Container().From(rustImage)

	toolchain := dag.Container().
		From(dartImage).
		WithFile("/usr/local/bin/node", node.File("/usr/local/bin/node")).
		WithDirectory(
			"/usr/local/lib/node_modules",
			node.Directory("/usr/local/lib/node_modules"),
		).
		WithDirectory("/usr/local/cargo", rust.Directory("/usr/local/cargo")).
		WithDirectory("/usr/local/rustup", rust.Directory("/usr/local/rustup")).
		WithEnvVariable("CARGO_HOME", "/usr/local/cargo").
		WithEnvVariable("RUSTUP_HOME", "/usr/local/rustup").
		WithEnvVariable(
			"PATH",
			"/usr/local/cargo/bin:/usr/lib/dart/bin:/root/.pub-cache/bin:/usr/local/bin:/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/bin",
		).
		WithExec([]string{
			"bash",
			"-c",
			"set -euo pipefail\n" +
				"apt-get update\n" +
				"DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ca-certificates curl git unzip xz-utils build-essential pkg-config\n" +
				"rm -rf /var/lib/apt/lists/*\n" +
				"ln -sf ../lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm\n" +
				"ln -sf ../lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx\n" +
				"dart --version\n" +
				"node --version\n" +
				"npm --version\n" +
				"rustc --version\n" +
				"cargo --version\n",
		})
	if withBrowser {
		toolchain = toolchain.WithExec([]string{
			"bash",
			"-c",
			"set -euo pipefail\n" +
				"apt-get update\n" +
				"DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends chromium chromium-driver\n" +
				"rm -rf /var/lib/apt/lists/*\n" +
				"chromium --version\n" +
				"chromedriver --version\n",
		})
	}

	return toolchain.
		WithMountedCache(pubCacheDir, dag.CacheVolume("react-workspace-pub-cache")).
		WithMountedCache(npmCacheDir, dag.CacheVolume("react-workspace-npm-cache")).
		WithMountedCache(cargoCacheDir, dag.CacheVolume("react-workspace-cargo-cache")).
		WithMountedCache(
			browserCacheDir,
			dag.CacheVolume("react-workspace-browser-cache"),
		).
		WithDirectory(
			workspaceDir,
			source,
			dagger.ContainerWithDirectoryOpts{Gitignore: true},
		).
		WithWorkdir(workspaceDir).
		WithExec([]string{
			"bash",
			"-c",
			"set -euo pipefail\n" +
				"dart pub get\n" +
				"dart run build_runner build --workspace\n" +
				"for project in examples/client examples/plugin_validation examples/ssr examples/superdesk packages/react_server_routed/example; do\n" +
				"  echo \"==> react generate --sync-only $project\"\n" +
				"  (cd \"$project\" && dart run react_tool:react generate --sync-only)\n" +
				"done\n",
		})
}
