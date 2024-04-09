"""Command line program for ACS bias correction data pre-processing."""

import argparse

import numpy as np
import xarray as xr
import xcdat
import xclim
import cmdline_provenance as cmdprov


output_units = {
    'tasmax': 'degC',
    'tasmin': 'degC',
    'pr': 'mm d-1',
    'sfcWindmax': 'm s-1',
    'rsds': 'W m-2',
}


def convert_units(da, target_units):
    """Convert units.

    Parameters
    ----------
    da : xarray DataArray
        Input array containing a units attribute
    target_units : str
        Units to convert to

    Returns
    -------
    da : xarray DataArray
       Array with converted units
    """

    xclim_unit_check = {
        'degrees_Celsius': 'degC',
        'deg_k': 'degK',
        'kg/m2/s': 'kg m-2 s-1',
        'mm': 'mm d-1',
    }

    if da.attrs["units"] in xclim_unit_check:
        da.attrs["units"] = xclim_unit_check[da.units]

    try:
        with xr.set_options(keep_attrs=True):
            da = xclim.units.convert_units_to(da, target_units)
    except Exception as e:
        if (da.attrs['units'] == 'kg m-2 s-1') and (target_units in ['mm d-1', 'mm day-1']):
            da = da * 86400
            da.attrs["units"] = target_units
        elif (da.attrs['units'] == 'MJ m^-2') and target_units == 'W m-2':
            da = da * (1e6 / 86400)
            da.attrs["units"] = target_units
        else:
            raise e
    
    if target_units == 'degC':
        da.attrs['units'] = 'degC'

    return da


def fix_metadata(ds):
    "Apply metadata fixes."""

    del ds['lat_bnds'].attrs['xcdat_bounds']
    del ds['lon_bnds'].attrs['xcdat_bounds']
    try:
        del ds['time_bnds'].attrs['xcdat_bounds']
    except KeyError:
        pass

    return ds
    

def main(args):
    """Run the program."""
    
    input_ds = xcdat.open_dataset(args.infile, mask_and_scale=True)

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
    output_ds[args.var] = convert_units(output_ds[args.var], output_units[args.var])
    output_ds = fix_metadata(output_ds)
    output_ds = output_ds.chunk({'time': 1, 'lat': -1, 'lon': -1})
    infile_log = {}
    if 'history' in input_ds.attrs:
        infile_log[args.infile] = input_ds.attrs['history']
    output_ds.attrs['history'] = cmdprov.new_log(
        infile_logs=infile_log,
        code_url='https://github.com/AusClimateService/bias-correction-data-release'
    )
    output_ds.to_netcdf(args.outfile, encoding={args.var: {'least_significant_digit': 2, 'zlib': True}})


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

