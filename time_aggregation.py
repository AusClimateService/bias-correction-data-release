"""Command line program for time aggregation."""

import argparse

import cftime
import xarray as xr
import xcdat as xc
import cmdline_provenance as cmdprov


def update_var_attrs(ds, var):
    """Update the variable attributes."""

    long_name = ds[var].attrs['long_name']
    standard_name = ds[var].attrs['standard_name']
    if var == 'pr':
        ds[var].attrs['units'] = 'mm'
        ds[var].attrs['long_name'] = f'Total Monthly {long_name}'
        ds[var].attrs['standard_name'] = 'precipitation'
    elif var in ['tasmin', 'tasmax', 'hursmin', 'hursmax']:
        ds[var].attrs['long_name'] = f'Monthly Mean {long_name}'

    return ds


def main(args):
    """Run the program."""

    time_coder = xr.coders.CFDatetimeCoder(use_cftime=True)
    input_ds = xc.open_mfdataset(
        args.infiles,
        decode_times=time_coder,
    )

    if args.var == 'pr':
        output_ds = input_ds.resample(time='M').sum('time', keep_attrs=True)
    elif args.var == 'hursmin':
        output_ds = input_ds.resample(time='M').mean('time', keep_attrs=True)
    output_ds.attrs['frequency'] = 'mon'

    output_ds = update_var_attrs(output_ds, args.var)

    output_ds.attrs['history'] = cmdprov.new_log(
        code_url='https://github.com/AusClimateService/bias-correction-data-release'
    )
    nlats = len(output_ds.lat.values)
    nlons = len(output_ds.lon.values)
    output_encoding = preprocess.get_output_encoding(output_ds, args.var, nlats, nlons)
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

