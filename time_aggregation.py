"""Command line program for time aggregation."""

import os
import argparse

import xcdat as xc
import cmdline_provenance as cmdprov

import preprocess


def update_global_attrs(ds, infile0, input_history):
    """Update the global file attributes."""

    global_keys_to_delete = [
        'time_coverage_start',
        'time_coverage_end',
        'time_coverage_duration',
        'time_coverage_resolution',
        'creation_date',
    ]
    for key in global_keys_to_delete:
        try:
            del ds.attrs[key]
        except KeyError:
            pass
    ds.attrs['frequency'] = 'mon'
    ds.attrs['history'] = cmdprov.new_log(
        infile_logs={infile0: input_history},
        code_url='https://github.com/AusClimateService/bias-correction-data-release',
        wildcard_prefixes=[os.path.dirname(infile0),],
    )

    return ds


def update_var_attrs(ds, var):
    """Update the variable attributes."""

    daily_extreme_vars = [
        'tasminAdjust',
        'tasmaxAdjust',
        'hursminAdjust',
        'hursmaxAdjust',
        'tasmin',
        'tasmax',
        'hursmin',
        'hursmax',
    ]
    long_name = ds[var].attrs['long_name']
    standard_name = ds[var].attrs['standard_name']
    if 'pr' in var:
        ds[var].attrs['units'] = 'mm'
        ds[var].attrs['long_name'] = f'Total Monthly {long_name}'
        ds[var].attrs['standard_name'] = 'precipitation'
    elif var in daily_extreme_vars:
        ds[var].attrs['long_name'] = f'Monthly Mean {long_name}'

    del ds['time_bnds'].attrs['xcdat_bounds']

    return ds


def main(args):
    """Run the program."""

    input_ds = xc.open_mfdataset(args.infiles)

    if 'pr' in args.var:
        output_ds = input_ds.resample(time='ME').sum('time', skipna=True, keep_attrs=True)
    else:
        output_ds = input_ds.resample(time='ME').mean('time', skipna=True, keep_attrs=True)
    output_ds.time.encoding['calendar'] = 'proleptic_gregorian'
    output_ds = output_ds.bounds.add_time_bounds(method='freq', freq='month', end_of_month=True)
    output_ds = xc.center_times(output_ds)

    output_ds = update_var_attrs(output_ds, args.var)
    output_ds = update_global_attrs(output_ds, args.infiles[0], input_ds.attrs['history'])

    nlats = len(output_ds.lat.values)
    nlons = len(output_ds.lon.values)
    output_encoding = preprocess.get_output_encoding(output_ds, args.var, nlats, nlons, compress=True)
    output_ds.to_netcdf(args.outfile, encoding=output_encoding, format='NETCDF4_CLASSIC')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter
    )     
    parser.add_argument("infiles", type=str, nargs='*', help="input files")
    parser.add_argument("var", type=str, help="input variable")
    parser.add_argument("outfile", type=str, help="output file")
    args = parser.parse_args()
    main(args)

