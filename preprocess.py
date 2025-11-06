"""Command line program for ACS bias correction data pre-processing."""

import argparse

import cftime
import numpy as np
import xarray as xr
import xcdat as xc
import xesmf as xe
from xcdat.bounds import create_bounds
import xclim
import cmdline_provenance as cmdprov


output_units = {
    'tas': 'degC',
    'tasmax': 'degC',
    'tasmin': 'degC',
    'wbgt': 'degC',
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
        'K': 'degK',
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
            ds = ds.drop_vars(drop_var)
        except ValueError:
            pass

    return ds


def fix_metadata(ds, var, freq, grid, regrid):
    "Apply metadata fixes."""

    # Remove xcdat attributes
    del ds['lat_bnds'].attrs['xcdat_bounds']
    del ds['lon_bnds'].attrs['xcdat_bounds']
    del ds['time_bnds'].attrs['xcdat_bounds']

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
        'units_metadata',
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
        ds['time'].attrs['bounds'] = 'time_bnds'
        ds['time_bnds'].attrs = {}

    # Add/update global attributes
    ds.attrs['frequency'] = freq
    ds.attrs['variable_id'] = var
    ds.attrs['license'] = "CC BY 4.0"
    ds.attrs['domain'] = 'Australia'
    ds.attrs['domain_id'] = grid
    if regrid == 'native':
        ds.attrs['title'] = 'CORDEX-CMIP6 data for Australia'
    else:    
        ds.attrs['title'] = 'CORDEX-CMIP6 regridded data for Australia'
        grid_spacings = {
            'AUST-05i': '0.05',
            'AUST-11i': '0.11',
            'AUST-20i': '0.20',
        }
        grid_spacing = grid_spacings[grid]
        ds.attrs['grid'] = f'latitude-longitude with {grid_spacing} degree grid spacing for the Australia domain'

    return ds


def get_output_encoding(
    ds,
    var,
    nlats,
    nlons,
    chunking='temporal',
    min_chunk_size=1,
    compress=False
):
    """Define the output file encoding.

    chunking can be 'temporal', 'spatial' or 'contiguous' (no chunking)
    """

    encoding = {}
    #data type and fill value
    ds_vars = list(ds.coords) + list(ds.keys())
    for ds_var in ds_vars:
        if ds_var == var:
            encoding[ds_var] = {'_FillValue': np.float32(1e20)}
            encoding[ds_var]['dtype'] = 'float32'
        else:
            encoding[ds_var] = {'_FillValue': None}
            encoding[ds_var]['dtype'] = 'float64'
    #compression
    if compress:
        encoding[var]['zlib'] = True
        encoding[var]['least_significant_digit'] = 2
        encoding[var]['complevel'] = 5

    if not var == 'orog':
        #chunking
        var_shape = ds[var].shape
        assert len(var_shape) == 3
        assert var_shape[1] == nlats
        assert var_shape[2] == nlons
        ntimes = var_shape[0]
        if chunking == 'temporal':
            encoding[var]['chunksizes'] = (min_chunk_size, nlats, nlons)
        elif chunking == 'spatial':
            encoding[var]['chunksizes'] = (ntimes, min_chunk_size, min_chunk_size)
        elif chunking == 'contiguous':
            encoding[var]['contiguous'] = True
        else:
            raise ValueError('invalid chunking strategy')
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


def xesmf_regrid(ds, ds_grid, variable=None, method='bilinear'):
    """Regrid data using xesmf directly.
    
    Parameters
    ----------
    ds : xarray Dataset
        Dataset to be regridded
    ds_grid : xarray Dataset
        Dataset containing target horizontal grid
    variable : str, optional
        Variable to restore attributes for
    method : str, default bilinear
        Method for regridding
    
    Returns
    -------
    ds : xarray Dataset
    
    """
    
    global_attrs = ds.attrs
    if variable:
        var_attrs = ds[variable].attrs
    regridder = xe.Regridder(ds, ds_grid, method)
    ds = regridder(ds)
    ds.attrs = global_attrs
    if variable:
        ds[variable].attrs = var_attrs
    ds['lon_bnds'] = create_bounds('X', ds['lon'])
    ds['lat_bnds'] = create_bounds('Y', ds['lat'])
    del ds['lat'].attrs['coordinate']
    del ds['lon'].attrs['coordinate']

    return ds


def create_grid(grid_name):
    """Create the spatial grid"""

    if grid_name == 'AUST-05i':
        grid = xc.regridder.grid.create_uniform_grid(-44.5, -9.99, 0.05, 112, 156.26, 0.05)
        decimals = 2
        bnds_decimals = 3 
    elif grid_name == 'AUST-20i':
        grid = xc.regridder.grid.create_uniform_grid(-44.5, -9.89, 0.20, 111.9, 156.31, 0.20)
        decimals = 1
        bnds_decimals = 1
    elif grid_name == 'AUST-11i':
        grid = xc.regridder.grid.create_uniform_grid(-44.55, -10.02, 0.11, 112.02, 156.25, 0.11)
        decimals = 2
        bnds_decimals = 3
    grid['lat'] = grid['lat'].copy(data=np.round(grid['lat'].values, decimals=decimals))
    grid['lon'] = grid['lon'].copy(data=np.round(grid['lon'].values, decimals=decimals))
    grid['lat_bnds'] = grid['lat_bnds'].copy(data=np.round(grid['lat_bnds'].values, decimals=bnds_decimals))
    grid['lon_bnds'] = grid['lon_bnds'].copy(data=np.round(grid['lon_bnds'].values, decimals=bnds_decimals))

    return grid


def clip_grid(ds, grid_name):
    """Clip a grid to the AUST region"""

    assert 'AUST' in grid_name

    if grid_name == 'AUST-11':
        south_lat = -44.56
        north_lat = -10.1
        west_lat = 112
        east_lat = 156.25
    else:
        south_lat = -44.5
        north_lat = -10
        west_lat = 112
        east_lat = 156.25

    clipped_ds = ds.sel({'lat': slice(south_lat, north_lat)})
    clipped_ds = clipped_ds.sel({'lon': slice(west_lat, east_lat)})

    return clipped_ds


def main(args):
    """Run the program."""

    time_coder = xr.coders.CFDatetimeCoder(use_cftime=True)
    input_ds = xc.open_mfdataset(
        args.infiles,
        mask_and_scale=True,
        decode_times=time_coder,
        preprocess=drop_vars
    )
    if args.rlon:
        input_ds = replace_rlon(input_ds, args.rlon)

    # Temporal aggregation
    if (args.input_freq) == "1hr" and (args.output_freq == "day"):
        if (args.input_var == 'hurs') and (args.output_var == "hursmax"):
            input_ds = input_ds.resample(time='D').max('time', keep_attrs=True)
            input_ds['time'] = np.vectorize(set_12h)(input_ds['time'].values)
            input_ds = input_ds.rename({'hurs': 'hursmax'})
            input_ds['hursmax'].attrs['long_name'] = 'Daily Maximum Near-Surface Relative Humidity'
        elif (args.input_var == 'hurs') and (args.output_var == 'hursmin'):
            input_ds = input_ds.resample(time='D').min('time', keep_attrs=True)
            input_ds['time'] = np.vectorize(set_12h)(input_ds['time'].values)
            input_ds = input_ds.rename({'hurs': 'hursmin'})
            input_ds['hursmin'].attrs['long_name'] = 'Daily Minimum Near-Surface Relative Humidity'
        else:
            raise ValueError(f"temporal aggregation not coded up for {args.input_var} to {args.output_var}")

    if args.compute:
        input_ds = input_ds.compute()

    # Grid
    if args.regrid_method == 'native':
        if 'AUST' in args.output_grid:
            output_ds = clip_grid(input_ds, args.output_grid)
        else:
            output_ds = input_ds
    else:
        assert args.output_grid in ('AUST-05i', 'AUST-11i', 'AUST-20i'), "f{args.output_grid} not a recognised target for regridding"
        npcp_grid = create_grid(args.output_grid)
        output_ds = input_ds.regridder.horizontal(
            args.output_var,
            npcp_grid,
            tool='xesmf',
            method=args.regrid_method,
        )

    # Time bounds (including check that data is 12:00 centered)
    output_ds['time_bnds'] = create_bounds('T', output_ds['time'])
    if args.output_freq == "day":
        np.testing.assert_array_equal(output_ds['time'].dt.hour.values, 12)
        np.testing.assert_array_equal(output_ds['time_bnds'].dt.hour.values, 0)

    # Metadata
    output_ds[args.output_var] = convert_units(output_ds[args.output_var], output_units[args.output_var])
    output_ds = fix_metadata(
        output_ds,
        args.output_var,
        args.output_freq,
        args.output_grid,
        args.regrid_method,
    )
    output_ds.attrs['history'] = cmdprov.new_log(
        code_url='https://github.com/AusClimateService/bias-correction-data-release'
    )
    output_encoding = get_output_encoding(
        output_ds,
        args.output_var,
        len(output_ds.lat),
        len(output_ds.lon),
        chunking=args.chunking_strategy,
        min_chunk_size=args.min_chunk_size,
        compress=args.compress,
    )

    output_ds.to_netcdf(args.outfile, encoding=output_encoding, format='NETCDF4_CLASSIC')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter
    )     
    parser.add_argument("infiles", type=str, nargs='*', help="input files")
    parser.add_argument("input_var", type=str, help="input variable")
    parser.add_argument("input_freq", type=str, choices=("day", "1hr", "fx"), help="input frequency")
    parser.add_argument("output_var", type=str, help="input variable")
    parser.add_argument("output_freq", type=str, choices=("day", "1hr", "fx"), help="output frequency")
    parser.add_argument("output_grid", type=str, help="output grid label")
    parser.add_argument(
        "regrid_method",
        type=str,
        choices=('bilinear', 'conservative', 'native'),
        help="regridding method (native = no regridding)"
    )
    parser.add_argument("outfile", type=str, help="output file")
    parser.add_argument(
        "--chunking_strategy",
        default='temporal',
        choices=('temporal', 'spatial', 'contiguous'),
        type=str,
        help="apply temporal (default), spatial (i.e. lat/lon) or contiguous (i.e. none) chunking to outfile"
    )
    parser.add_argument(
        "--min_chunk_size",
        default=1,
        type=int,
        help="minimum chunk size"
    )
    parser.add_argument(
        "--rlon",
        default=None,
        type=str,
        help="file containing correct rlon values"
    )
    parser.add_argument(
        "--compute",
        action='store_true',
        default=False,
        help="read all the data into memory"
    )
    parser.add_argument(
        "--compress",
        action='store_true',
        default=False,
        help="apply compression to the output file"
    )
    args = parser.parse_args()
    main(args)

