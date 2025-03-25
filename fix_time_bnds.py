"""Command line program to change daily data from 00:00 centered to 12:00 centered"""

import argparse

import numpy as np
import xarray as xr


def get_output_encoding(ds, var):
    """Define the output file encoding."""

    encoding = {}
    #remove fill value attribute
    ds_vars = list(ds.coords) + list(ds.keys())
    for ds_var in ds_vars:
        if ds_var == var:
            encoding[ds_var] = {'_FillValue': np.float32(1e20)}
            encoding[ds_var]['dtype'] = 'float32'
        else:
            encoding[ds_var] = {'_FillValue': None}
            encoding[ds_var]['dtype'] = 'float64'
    #compression and chunking
    encoding[var]['zlib'] = True
    encoding[var]['least_significant_digit'] = 2
    encoding[var]['complevel'] = 5
    #chunking
    var_shape = ds[var].shape
    nlats = var_shape[1]
    nlons = var_shape[2]
    encoding[var]['chunksizes'] = (1, nlats, nlons)
    #units 
    encoding['time']['units'] = 'days since 1950-01-01'

    return encoding


def main(args):
    """Run the program."""

    ds = xr.open_dataset(args.infile)
    
    # Check that data is 00:00 centered
    np.testing.assert_array_equal(ds['time'].dt.hour.values, 0)
    np.testing.assert_array_equal(ds['time_bnds'].dt.hour.values, 12)

    # Increment times by 12 hours
    time_attrs = ds['time'].attrs
    ds['time'] = ds['time'] + np.timedelta64(12, 'h')
    ds['time'].attrs = time_attrs
    ds['time_bnds'] = ds['time_bnds'] + np.timedelta64(12, 'h')

    # Check that data is 12:00 centered
    np.testing.assert_array_equal(ds['time'].dt.hour.values, 12)
    np.testing.assert_array_equal(ds['time_bnds'].dt.hour.values, 0)
    
    output_encoding = get_output_encoding(ds, args.var)
    ds.to_netcdf(args.outfile, encoding=output_encoding, format='NETCDF4_CLASSIC')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter
    )     
    parser.add_argument('infile', type=str, help='input file')
    parser.add_argument('var', type=str, help='variable')
    parser.add_argument('outfile', type=str, help='output file')
    args = parser.parse_args()
    main(args)

