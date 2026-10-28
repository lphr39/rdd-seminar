"""Rebuild the slides (and optionally local private notes) using saved results."""
from pathlib import Path
import argparse
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parent


def compile_tex(directory, stem):
    build = directory / 'build'
    build.mkdir(exist_ok=True)
    commands = [
        ['pdflatex', '-interaction=nonstopmode', '-halt-on-error', '-file-line-error',
         '-output-directory=build', stem+'.tex'],
        ['biber', '--input-directory=build', '--output-directory=build', stem],
    ]
    # A final TeX pass settles Beamer/biblatex page references on a clean build.
    for n, command in enumerate([commands[0], commands[1], commands[0], commands[0], commands[0]], 1):
        result = subprocess.run(command, cwd=directory, stdout=subprocess.PIPE,
                                stderr=subprocess.STDOUT, text=True, errors='replace')
        (build / f'pass-{n}.txt').write_text(result.stdout, encoding='utf-8')
        if result.returncode:
            print(result.stdout[-8000:])
            raise RuntimeError(f'Build failed: {command[0]} (see {build})')
    shutil.copy2(build/(stem+'.pdf'), directory/(stem+'.pdf'))
    print('Built', directory/(stem+'.pdf'))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--notes', action='store_true', help='also compile private local notes')
    args = parser.parse_args()
    (ROOT/'build').mkdir(exist_ok=True)
    subprocess.run([sys.executable, str(ROOT/'build_tables.py')], check=True, cwd=ROOT)
    compile_tex(ROOT, 'slides')
    if args.notes:
        notes = ROOT.parent/'notes'
        if not (notes/'study_notes.tex').is_file():
            raise FileNotFoundError('Private notes are local and are not included in the public repository.')
        compile_tex(notes, 'study_notes')


if __name__ == '__main__':
    main()
