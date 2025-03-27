"""Command line program to change daily data from 00:00 centered to 12:00 centered"""
import pdb
import argparse

import cftime
import numpy as np
import xarray as xr
from xcdat.bounds import create_bounds


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


def set_12h(dt):
    """Set the hour of a cftime object to 12"""
    
    cftime_types = {
        'proleptic_gregorian': cftime.DatetimeProlepticGregorian,
        'noleap': cftime.DatetimeNoLeap,
        'standard': cftime.DatetimeGregorian,
        '360_day': cftime.Datetime360Day,
    }
    
    calendar = dt.calendar
    dt_12h = cftime_types[calendar](
        dt.year,
        dt.month,
        dt.day,
        12,
    )
    
    return dt_12h


def main(args):
    """Run the program."""

    time_coder = xr.coders.CFDatetimeCoder(use_cftime=True)
    ds = xr.open_dataset(args.infile, decode_times=time_coder)
    
    # Check that data is 00:00 centered
    np.testing.assert_array_equal(ds['time'].dt.hour.values, 0)
    np.testing.assert_array_equal(ds['time_bnds'].dt.hour.values, 12)

    # Increment times by 12 hours
    time_attrs = ds['time'].attrs
    ds['time'] = np.vectorize(set_12h)(ds['time'].values)
    ds['time_bnds'] = create_bounds('T', ds['time'])
    ds['time'].attrs = time_attrs
    ds['time_bnds'].attrs = {}

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

