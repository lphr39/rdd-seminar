"""Generate slide table inputs exclusively from the Stata CSV outputs."""
from pathlib import Path
import csv
import json

ROOT = Path(__file__).resolve().parent
RESULTS = ROOT.parent / 'exercises/hansen_results'

def read_table(name):
    with (RESULTS / (name + '.csv')).open(newline='', encoding='utf-8') as f:
        return {r['statistic']: {k: float(v) for k, v in r.items() if k != 'statistic'}
                for r in csv.DictReader(f)}

def table(headers, rows):
    out = [r'\begin{center}\small', r'\renewcommand{\arraystretch}{1.15}',
           r'\begin{tabular}{@{}l' + 'r' * len(headers) + r'@{}}\toprule',
           ' & ' + ' & '.join(headers) + r'\\\midrule']
    out += [label + ' & ' + ' & '.join(values) + r'\\' for label, values in rows]
    out += [r'\bottomrule\end{tabular}\end{center}']
    return '\n'.join(out) + '\n'

def main():
    balance = read_table('table_6_6')
    keys = ['White', 'Male', 'Age', 'Accident']
    rows = [(label, [f'{balance[key][k]:.4f}' for k in keys]) for label, key in
            [('Discontinuity', 'DUI_effect'), ('Robust SE', 'Robust_SE'),
             ('Sample mean', 'Mean_outcome'),
             ('Untreated cutoff level', 'Untreated_mean_at_cutoff')]]
    rows.append(('Observations', [f'{int(balance["Observations"][k]):,}' for k in keys]))
    (ROOT / 'assets/table_6_6.tex').write_text(table(keys, rows), encoding='utf-8')
    ols = read_table('table_6_7')
    keys = ['Linear', 'Quadratic']
    rows = [(label, [f'{100*ols[key][k]:.3f}' for k in keys]) for label, key in
            [('Effect (pp)', 'DUI_effect'), ('Robust SE (pp)', 'Robust_SE'),
             ('Sample recidivism (\\%)', 'Mean_outcome'),
             ('Untreated cutoff level (\\%)', 'Untreated_mean_at_cutoff')]]
    rows.append(('Observations', [f'{int(ols["Observations"][k]):,}' for k in keys]))
    (ROOT / 'assets/table_6_7.tex').write_text(table(keys, rows), encoding='utf-8')
    rd = read_table('table_6_8')
    keys = ['Constant', 'Linear', 'Quadratic']
    rows = [(label, [f'{100*rd[key][k]:.3f}' for k in keys]) for label, key in
            [('Bias-corrected effect (pp)', 'DUI_effect'), ('RBC SE (pp)', 'Robust_BC_SE')]]
    rows.append(('Polynomial order', [f'{int(rd["Polynomial_order"][k])}' for k in keys]))
    rows.extend((label, [f'{rd[key][k]:.4f}' for k in keys]) for label, key in
                [('Bandwidth left', 'Bandwidth_left'), ('Bandwidth right', 'Bandwidth_right')])
    rows.extend((label, [f'{int(rd[key][k]):,}' for k in keys]) for label, key in
                [('Effective N left', 'Effective_N_left'), ('Effective N right', 'Effective_N_right'),
                 ('Effective N total', 'Effective_N_total')])
    (ROOT / 'assets/table_6_8.tex').write_text(table(keys, rows), encoding='utf-8')
    tau = 100 * rd['DUI_effect']['Linear']
    se = 100 * rd['Robust_BC_SE']['Linear']
    lower, upper = tau - 1.96 * se, tau + 1.96 * se
    summary = (r'\begin{block}{Local linear estimate}' + '\n'
               + f'A reduction of \\textbf{{{abs(tau):.2f} percentage points}} in recidivism.\\\\[0.6em]\n'
               + f'Robust bias-corrected 95\\% CI: $[{lower:.2f},\\ {upper:.2f}]$ percentage points.\n'
               + r'\end{block}' + '\n')
    (ROOT / 'assets/local_linear_summary.tex').write_text(summary, encoding='utf-8')
    (ROOT / 'build/numeric_summary.json').write_text(
        json.dumps({'balance': balance, 'ols': ols, 'rd': rd,
                    'local_linear_ci_pp': [lower, upper]}, indent=2), encoding='utf-8')
    print(f'Local linear: {tau:.4f} pp; RBC SE {se:.4f}; CI [{lower:.4f}, {upper:.4f}]')

if __name__ == '__main__':
    main()
