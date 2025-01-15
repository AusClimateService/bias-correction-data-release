"""Command line program to fix metadata in ACS bias correction files."""

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
    
    # Edit existing global attributes
    ds.attrs['version_realisation'] = 'v1-r1'
    ds.attrs['domain_id'] = 'AUST-05i'
    ds.attrs['title'] = 'CORDEX-CMIP6-based regridded and calibrated data for Australia'
    ds.attrs['license'] = "CC BY 4.0"
    ds.attrs['grid'] = 'latitude-longitude with 0.05 degree grid spacing for Australia domain (matches standard AGCD grid)'
    if 'bc_method_id' in ds.attrs:
        bc_method = ds.attrs['bc_method_id']
        if bc_method == 'ACS-QME':
            ds.attrs['bc_code'] = 'https://doi.org/10.5281/zenodo.14635627'
        elif bc_method == 'ACS-MRNBC':
            ds.attrs['bc_code'] = 'https://doi.org/10.5281/zenodo.14641854'
        else:
            raise ValueError(f'No citation for bias correction method {bc_method}') 
        if '-AGCD-' in ds.attrs['bc_info']:
            ds.attrs['bc_info'] = ds.attrs['bc_info'].replace('-AGCD-', '-AGCDv1-')
        if 'BARRA-R2' in ds.attrs['bc_info']:
            ds.attrs['bc_info'] = ds.attrs['bc_info'].replace('BARRA-R2', 'BARRAR2')
        if ds.attrs['bc_observation_id'] == 'AGCD':
            ds.attrs['bc_observation_id'] = 'AGCDv1'
        if ds.attrs['bc_observation_id'] == 'BARRA-R2':
            ds.attrs['bc_observation_id'] = 'BARRAR2'
    
    # Remove global attributes
    global_attrs_to_delete = [
        'activity_id',
        'rlong0',
        'rlat0',
        'schmidt',
        'il',
        'kl',
        'native_resolution',
        'comment',
    ]
    for attr in global_attrs_to_delete:
        try:
            del ds.attrs[attr]
        except KeyError:
            pass
            
    # Remove variable attributes
    ds['time_bnds'].attrs = {}
    var_attrs_to_delete = ['cell_methods', 'grid_mapping']
    for attr in var_attrs_to_delete:
        try:
            del ds[args.var].attrs[attr]
        except KeyError:
            pass
    
    output_encoding = get_output_encoding(ds, args.var)
    ds.to_netcdf(args.outfile, encoding=output_encoding, format='NETCDF4_CLASSIC')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter
    )     
    parser.add_argument('infile', type=str, help='input files')
    parser.add_argument('var', type=str, help='variable')
    parser.add_argument('outfile', type=str, help='output file')
    args = parser.parse_args()
    main(args)

