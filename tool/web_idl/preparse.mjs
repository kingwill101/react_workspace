import {createRequire} from 'node:module';
import {mkdir, writeFile} from 'node:fs/promises';
import {dirname, join, resolve} from 'node:path';
import {fileURLToPath} from 'node:url';

const scriptDirectory = dirname(fileURLToPath(import.meta.url));
const workspaceRoot = resolve(scriptDirectory, '../..');
const dataRoot = join(
  workspaceRoot,
  'third_party/web/web_generator/lib/src',
);
const requireFromDataRoot = createRequire(join(dataRoot, 'package.json'));

const idl = requireFromDataRoot('@webref/idl');
const css = requireFromDataRoot('@webref/css');
const elements = requireFromDataRoot('@webref/elements');

function outputPath(arguments_) {
  const outputIndex = arguments_.indexOf('--output');
  if (outputIndex === -1) {
    return join(workspaceRoot, 'tool/web_idl/snapshots/web_apis.json');
  }
  const value = arguments_[outputIndex + 1];
  if (!value) throw new Error('--output requires a path.');
  return resolve(workspaceRoot, value);
}

async function main() {
  const destination = outputPath(process.argv.slice(2));
  const [parsedIdls, cssData, elementsData] = await Promise.all([
    idl.parseAll(),
    css.listAll(),
    elements.listAll(),
  ]);

  await mkdir(dirname(destination), {recursive: true});
  await writeFile(
    destination,
    JSON.stringify(
      {idl: parsedIdls, css: cssData, elements: elementsData},
      null,
      2,
    ),
  );
  console.log(`Generated normalized Web data at ${destination}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
