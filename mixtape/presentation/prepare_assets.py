"""Fetch the original book figures and retain their source provenance."""
from pathlib import Path
import concurrent.futures
import json
import urllib.request
import re
import fitz

ROOT = Path(__file__).resolve().parent
ASSETS = ROOT / 'assets'
BASE = 'https://mixtape.scunning.com/'
FIGURES = {
    'alcohol_drinking.png': 'graphics/alcohol_drinking1.png',
    'alcohol_mortality.png': 'graphics/alcohol_mortality.png',
    'sharp_fuzzy.svg': '06-Regression_Discontinuity_files/mediabag/klaauw2002.svg',
    'potential_homogeneous.svg': '06-Regression_Discontinuity_files/mediabag/rdd_po_homog.svg',
    'potential_heterogeneous.svg': '06-Regression_Discontinuity_files/mediabag/rdd_po_het.svg',
    'smoothness.png': 'graphics/rdd_smoothness.png',
    'observed_jump.png': 'graphics/rdd_smoothness2.png',
    'misspecification.png': 'graphics/rdd_quad.png',
    'boundary_bias.svg': '06-Regression_Discontinuity_files/mediabag/parallel_bins_adjusted_x_values.svg',
    'density.jpg': 'graphics/mccrary_density_test.jpg',
    'election_balance.jpg': 'graphics/lee_moretti_butler_fig3.jpg',
    'birthweight_heaping.jpg': 'graphics/heaping.jpg',
    'medicare_employment.jpg': 'graphics/EmploymentRatesMenbyAge.jpg',
    'medicare_hospital.jpg': 'graphics/cardetal2008_fig3.jpg',
    'hoekstra_firststage.jpg': 'graphics/rdd_hoekstra1.jpg',
}

def fetch(item):
    name, rel = item
    target = ASSETS / name
    if not target.exists():
        target.write_bytes(urllib.request.urlopen(BASE + rel, timeout=45).read())
    if target.suffix == '.svg':
        doc = fitz.open(target)
        (ASSETS / (target.stem + '.pdf')).write_bytes(doc.convert_to_pdf())
    return {'file': name, 'source': BASE + rel}

def main():
    ASSETS.mkdir(exist_ok=True)
    with concurrent.futures.ThreadPoolExecutor(max_workers=6) as pool:
        records = list(pool.map(fetch, FIGURES.items()))
    handout = fitz.open(ROOT.parents[1] / 'resources/rdd-smoothness-and-hoekstra.pdf')
    page = handout[2]
    # Retain the supplied schematic as vector PDF, excluding surrounding prose.
    out = fitz.open()
    crop = fitz.Rect(45, 231, 554, 442)
    new = out.new_page(width=crop.width, height=crop.height)
    new.show_pdf_page(new.rect, handout, 2, clip=crop)
    out.save(ASSETS / 'smoothness_observed_counterfactual.pdf')
    records.append({'file': 'smoothness_observed_counterfactual.pdf',
                    'source': '../../resources/rdd-smoothness-and-hoekstra.pdf', 'page': 3})
    (ASSETS / 'sources.json').write_text(json.dumps(records, indent=2), encoding='utf-8')
    print(f'Prepared {len(records)} figure assets.')

if __name__ == '__main__':
    main()
