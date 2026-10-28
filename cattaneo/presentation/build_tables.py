"""Build slide tables from the saved, executed Stata results; no estimation."""
from pathlib import Path
import csv

ROOT = Path(__file__).resolve().parent
RESULTS = ROOT.parent / 'exercises/results'


def main():
    with (RESULTS/'rd_results.csv').open(newline='',encoding='utf-8-sig') as stream:
        rows = {r['model']: r for r in csv.DictReader(stream)}
    specs = {
        'turkey_main': [('MSE bandwidth','turkey_mserd'),('CER bandwidth','turkey_cerrd')],
        'turkey_sensitivity': [('Half bandwidth','turkey_bandwidth_1'),('Baseline','turkey_bandwidth_2'),
                              ('1.5 times bandwidth','turkey_bandwidth_3'),('Local quadratic','turkey_quadratic'),('Donut','turkey_donut')],
        'turkey_balance': [('Log population, 1994','balance_lpop1994'),('Number of parties, 1994','balance_partycount'),('Islamic mayor, 1989','balance_i89')],
        'turkey_placebo': [('Placebo at -20','placebo_minus20'),('Placebo at +20','placebo_plus20')],
        'senate': [('Continuity at cutoff','senate_continuity')],
        'fuzzy': [('First stage (pp)','spp_D'),('Eligibility effect (pp)','spp_Y'),('Receipt LATE (pp)','spp_fuzzy')],
        'probation': [('Continuity method','probation_continuity'),('Cluster by score','probation_cluster_score')],
        'cutoffs': [('Metropolitan (-57.21)','cutoff_-57.21'),('Other urban (-56.32)','cutoff_-56.32'),('Rural (-40.75)','cutoff_-40.75'),('Normalized pool','cutoff_normalized_pool')],
        'boundary': [('(0, 0)','boundary_0_0'),('(30, 0)','boundary_30_0'),('(0, 50)','boundary_0_50')],
        'geographic': [('Boundary point 1','geographic_dist1'),('Boundary point 2','geographic_dist2'),('Boundary point 3','geographic_dist3'),('Whole-boundary distance','geographic_perp_dist')],
    }
    for name,items in specs.items():
        tex=[r'\begin{center}',r'\small\renewcommand{\arraystretch}{1.3}',
             r'\begin{tabular}{@{}lrrr@{}}\toprule',
             r' & Estimate & Bias-corrected & Robust 95\% CI\\\midrule']
        for label,key in items:
            row=rows[key]
            f=lambda col:f'{float(row[col]):.2f}'
            tex.append(f"{label} & {f('tau_cl')} & {f('tau_bc')} & $[{f('ci_l')}, {f('ci_r')}]$"+r'\\')
        tex += [r'\bottomrule\end{tabular}',r'\end{center}']
        (ROOT/f'assets/{name}.tex').write_text('\n'.join(tex)+'\n',encoding='utf-8')
    print(f'Built {len(specs)} tables from {len(rows)} executed specifications.')


if __name__ == '__main__':
    main()
