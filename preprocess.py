"""Command line program for ACS bias correction data pre-processing."""

import argparse

import numpy as np
import xcdat
import cmdline_provenance as cmdprov


def fix_metadata(ds):
    "Apply metadata fixes."""

    del ds['lat_bnds'].attrs['xcdat_bounds']
    del ds['lon_bnds'].attrs['xcdat_bounds']
    try:
        del ds['time_bnds'].attrs['xcdat_bounds']
    except KeyError:
        pass
    # TODO: Delete time_bnds altogether?

    return ds
    

def main(args):
    """Run the program."""
    
    input_ds = xcdat.open_dataset(args.infile)

    # AGCD grid
    lats = np.round(np.arange(-44.5, -9.99, 0.05), decimals=2)
    lons = np.round(np.arange(112, 156.26, 0.05), decimals=2)
    npcp_grid = xcdat.create_grid(lats, lons)
    output_ds = input_ds.regridder.horizontal(
        args.var,
        npcp_grid,
        tool='xesmf',
        method=args.method,
    )
    output_ds = fix_metadata(output_ds)
    infile_log = {}
    if 'history' in input_ds.attrs:
        infile_log[args.infile] = input_ds.attrs['history']
    output_ds.attrs['history'] = cmdprov.new_log(infile_logs=infile_log)
    output_ds.to_netcdf(args.outfile)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter
    )     
    parser.add_argument("infile", type=str, help="input file")
    parser.add_argument("var", type=str, help="input variable")
    parser.add_argument("method", type=str, choices=('bilinear', 'conservative'), help="regridding method")
    parser.add_argument("outfile", type=str, help="output file")
    args = parser.parse_args()
    main(args)

