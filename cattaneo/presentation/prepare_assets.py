"""Extract the cited theoretical diagrams from the user's local reading copies.

Only needed to refresh included assets. Requires PyMuPDF and the two supplied
PDFs in ../../resources. Empirical figures come from the separate Stata modules.
"""
from pathlib import Path
import json
import fitz

ROOT = Path(__file__).resolve().parent
CASES = [
    ('2020', 12, (102, 53, 342, 260), 'sharp_assignment', 1),
    ('2020', 14, (101, 53, 342, 301), 'sharp_effect', 2),
    ('2020', 43, (58, 53, 365, 338), 'local_polynomial', 12),
    ('2020', 45, (59, 53, 365, 302), 'approximation_bias', 14),
    ('2024', 14, (62, 53, 365, 193), 'experiment_rd', 2),
    ('2024', 17, (90, 53, 350, 255), 'local_randomization', 3),
    ('2024', 43, (61, 53, 377, 190), 'sharp_fuzzy', 7),
    ('2024', 86, (57, 53, 365, 248), 'cutoff_types', 12),
    ('2024', 88, (62, 53, 365, 254), 'cutoff_effects', 13),
    ('2024', 91, (62, 53, 377, 251), 'cutoff_extrapolation', 14),
    ('2024', 97, (64, 53, 377, 201), 'multiscore_regions', 16),
]
sources = []
for year, page_number, bounds, name, figure in CASES:
    source = ROOT.parents[1] / f'resources/Cattaneo et al. ({year}).pdf'
    doc = fitz.open(source)
    clip = fitz.Rect(bounds)
    out = fitz.open()
    page = out.new_page(width=clip.width, height=clip.height)
    page.show_pdf_page(page.rect, doc, page_number-1, clip=clip)
    out.save(ROOT / f'assets/{name}.pdf')
    sources.append(dict(file=name+'.pdf', authors='Cattaneo, Idrobo, and Titiunik',
                        year=year, figure=figure, pdf_page=page_number,
                        printed_page=page_number-6, clip=list(bounds),
                        source=f'User-supplied Cattaneo et al. ({year}).pdf',
                        transformation='Vector crop of theoretical figure; no substantive modification'))
(ROOT/'assets/sources.json').write_text(json.dumps(sources,indent=2)+'\n',encoding='utf-8')
print(f'Extracted {len(sources)} theoretical figures.')
