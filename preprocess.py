"""Command line program for ACS bias correction data pre-processing."""

import argparse

import cftime
import numpy as np
import xarray as xr
import xcdat
import xclim
import cmdline_provenance as cmdprov


output_units = {
    'tas': 'degC',
    'tasmax': 'degC',
    'tasmin': 'degC',
    'pr': 'mm d-1',
    'prsn': 'mm d-1',
    'sfcWind': 'm s-1',
    'sfcWindmax': 'm s-1',
    'rsds': 'W m-2',
    'rlds': 'W m-2',
    'hurs': '%',
    'hursmin': '%',
    'hursmax': '%',
    'ps': 'Pa',
    'psl': 'Pa',
    'orog': 'm',
    'huss': '1',
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


def drop_vars(ds):
    """Drop variables from dataset"""

    drop_vars = [
        'sigma',
        'level_height',
        'height',
        'model_level_number',
        'crs',
    ]
 
    for drop_var in drop_vars:
        try:
            ds = ds.drop(drop_var)
        except ValueError:
            pass

    return ds


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
    global_keys_to_delete = [
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
        'time_coverage_start',
        'time_coverage_end',
        'time_coverage_duration',
        'time_coverage_resolution',
        'git_url_postprocessing',
        'git_hash_postprocessing',
        'project_id',
        'comment',
        'DPIE_WRF_HASH',
        'wrf_options',
        'contact',
        'product',
        'nest_level',
        'nest_parent',
        'wrf_schemes_ra_sw_physics',
        'wrf_schemes_ra_lw_physics',
        'wrf_schemes_sf_sfclay_physics',
        'wrf_schemes_sf_surface_physics',
        'wrf_schemes_mp_physics',
        'wrf_schemes_bl_pbl_physics',
        'wrf_schemes_cu_physics',
        'references',
        'NCO',
        'activity_id',
        'rlong0',
        'rlat0',
        'schmidt',
        'il',
        'kl',
        'native_resolution',
        'units',
        'nco_openmp_thread_number',
        'CDO',
        'CDI',
    ]
    for key in global_keys_to_delete:
        try:
            del ds.attrs[key]
        except KeyError:
            pass

    # Delete variable attributes
    var_keys_to_delete = [
        'cell_methods',
        'valid_range',
        'grid_mapping',
        'MD5',
        'coordinates',
    ]
    for key in var_keys_to_delete:
        try:
            del ds[var].attrs[key]
        except KeyError:
            pass

    # Add/update variable attributes
    ds['lat'].attrs['long_name'] = 'latitude'
    ds['lat'].attrs['standard_name'] = 'latitude'
    ds['lon'].attrs['long_name'] = 'longitude'
    ds['lon'].attrs['standard_name'] = 'longitude'
    if not var == 'orog':
        ds['time'].attrs['long_name'] = 'time'
        ds['time'].attrs['standard_name'] = 'time'
        ds['time'].attrs['axis'] = 'T'
        ds['time_bnds'].attrs = {}

    # Add/update global attributes
    ds.attrs['domain'] = 'Australia/AGCD'
    ds.attrs['domain_id'] = 'AUST-05i'
    ds.attrs['title'] = 'CORDEX-CMIP6 regridded data for Australia'
    if var == 'orog':
        ds.attrs['frequency'] = 'fx'
    else:
        ds.attrs['frequency'] = 'day'
    ds.attrs['variable_id'] = var
    ds.attrs['license'] = "CC BY 4.0"
    ds.attrs['grid'] = 'latitude-longitude with 0.05 degree grid spacing for Australia domain (the standard AGCD grid)'

    return ds


def get_output_encoding(ds, var, nlats, nlons):
    """Define the output file encoding."""

    encoding = {}
    ds_vars = list(ds.coords) + list(ds.keys())
    #data type and fill value
    for ds_var in ds_vars:
        encoding[ds_var] = {'_FillValue': None}
        if ds_var == var:
            encoding[ds_var]['dtype'] = 'float32'
        else:
            encoding[ds_var]['dtype'] = 'float64'
    #compression
    encoding[var]['zlib'] = True
    encoding[var]['complevel'] = 5
    if not var == 'orog':
        #chunking
        var_shape = ds[var].shape
        assert len(var_shape) == 3
        assert var_shape[1] == nlats
        assert var_shape[2] == nlons
        encoding[var]['chunksizes'] = (1, nlats, nlons)
        #time units
        encoding['time']['units'] = 'days since 1950-01-01'

    return encoding


def replace_rlon(ds, rlon_file):
    """Replace rlon values (needed for NARCliM2.0)"""

    rlon_values = []
    with open(rlon_file, 'r') as file:
        for line in file.readlines():
            rlon_values.append(float(line))

    rlon_attrs = ds['rlon'].attrs
    ds['rlon'] = rlon_values
    ds['rlon'].attrs = rlon_attrs
    
    ds = ds.drop_vars('rlon_bnds')
    ds = ds.bounds.add_missing_bounds()

    return ds

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
    
    input_ds = xcdat.open_mfdataset(args.infiles, mask_and_scale=True, preprocess=drop_vars)
    if args.rlon:
        input_ds = replace_rlon(input_ds, args.rlon)

    # Temporal aggregation
    if args.var == 'hursmax':
        input_ds = input_ds.resample(time='D').max('time', keep_attrs=True)
        input_ds['time'] = np.vectorize(set_12h)(input_ds['time'].values)
        input_ds = input_ds.rename({'hurs': 'hursmax'})
        input_ds['hursmax'].attrs['long_name'] = 'Daily Maximum Near-Surface Relative Humidity'
    elif args.var == 'hursmin':
        input_ds = input_ds.resample(time='D').min('time', keep_attrs=True)
        input_ds['time'] = np.vectorize(set_12h)(input_ds['time'].values)
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
    output_ds.to_netcdf(args.outfile, encoding=output_encoding, format='NETCDF4_CLASSIC')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter
    )     
    parser.add_argument("infiles", type=str, nargs='*', help="input files")
    parser.add_argument("var", type=str, help="input variable")
    parser.add_argument("method", type=str, choices=('bilinear', 'conservative'), help="regridding method")
    parser.add_argument("outfile", type=str, help="output file")
    parser.add_argument(
        "--rlon",
        default=None,
        type=str,
        help="file containing correct rlon values"
    )
    args = parser.parse_args()
    main(args)

