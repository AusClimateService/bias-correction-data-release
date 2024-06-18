"""Command line program for ACS bias correction data pre-processing."""
import pdb
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
    'hursmin': '%',
    'hursmax': '%',
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


def fix_metadata(ds, var):
    "Apply metadata fixes."""

    # Remove xcdat attributes
    del ds['lat_bnds'].attrs['xcdat_bounds']
    del ds['lon_bnds'].attrs['xcdat_bounds']
    try:
        del ds['time_bnds'].attrs['xcdat_bounds']
    except KeyError:
        pass

    # Rename input attributes
    for attr in ['tracking_id', 'doi']:
        if attr in ds.attrs:
            ds.attrs['input_' + attr] = ds.attrs[attr]
    
    # Delete global attributes
    keys_to_delete = [
        'tracking_id',
        'doi',
        'axiom_version',
        'axiom_schemas_version',
        'axiom_schema',
        'productive_version',
        'processing_level',
        'geospatial_lat_min',
        'geospatial_lat_max',
        'geospatial_lat_units',
        'geospatial_lon_min',
        'geospatial_lon_max',
        'geospatial_lon_units',
        'date_modified',
        'date_metadata_modified',
        'creation_date',
    ]
    for key in keys_to_delete:
        try:
            del ds.attrs[key]
        except KeyError:
            pass

    # Delete variable attributes
    try:
        del ds[var].attrs['cell_methods']
    except KeyError:
        pass

    # Add/update variable attributes
    ds['lat'].attrs['long_name'] = 'latitude'
    ds['lat'].attrs['standard_name'] = 'latitude'
    ds['lon'].attrs['long_name'] = 'longitude'
    ds['lon'].attrs['standard_name'] = 'longitude'
    ds['time'].attrs['long_name'] = 'time'
    ds['time'].attrs['standard_name'] = 'time'
    ds['time'].attrs['axis'] = 'T'

    # Add/update global attributes
    ds.attrs['domain'] = 'Australia/AGCD'
    ds.attrs['domain_id'] = 'AGCD-05i'
    ds.attrs['title'] = 'Pre-processed model output in preparation for bias adjustment'
    ds.attrs['frequency'] = 'day'
    ds.attrs['variable_id'] = var

    # Variables to delete
    drop_vars = ['sigma', 'level_height', 'model_level_number', 'height']
    for drop_var in drop_vars:
        try:
            ds = ds.drop(drop_var)
        except ValueError:
            pass
    try:
        del ds['time_bnds'].encoding['coordinates']
    except KeyError:
        pass

    return ds


def get_output_encoding(ds, var, nlats, nlons):
    """Define the output file encoding."""

    var_shape = ds[var].shape
    assert len(var_shape) == 3
    assert var_shape[1] == nlats
    assert var_shape[2] == nlons

    encoding = {}
    ds_vars = list(ds.coords) + list(ds.keys())
    for ds_var in ds_vars:
        encoding[ds_var] = {'_FillValue': None}
    encoding[var]['zlib'] = True
    encoding[var]['dtype'] = 'float32'
    encoding[var]['chunksizes'] = (1, nlats, nlons)
    encoding['time']['units'] = 'days since 1950-01-10'

    return encoding


def main(args):
    """Run the program."""
    
    input_ds = xcdat.open_dataset(args.infile, mask_and_scale=True)

    # Temporal aggregation
    if args.var == 'hursmax':
        input_ds = input_ds.resample(time='D').max('time', keep_attrs=True)
        input_ds = input_ds.rename({'hurs': 'hursmax'})
        input_ds['hursmax'].attrs['long_name'] = 'Daily Maximum Near-Surface Relative Humidity'
    elif args.var == 'hursmin':
        input_ds = input_ds.resample(time='D').min('time', keep_attrs=True)
        input_ds = input_ds.rename({'hurs': 'hursmin'})
        input_ds['hursmin'].attrs['long_name'] = 'Daily Minimum Near-Surface Relative Humidity'

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
    output_ds = fix_metadata(output_ds, args.var)
    output_ds.attrs['history'] = cmdprov.new_log(
        code_url='https://github.com/AusClimateService/bias-correction-data-release'
    )
    output_encoding = get_output_encoding(output_ds, args.var, len(lats), len(lons))
    output_ds.to_netcdf(args.outfile, encoding=output_encoding)


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

